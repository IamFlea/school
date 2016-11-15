#ifndef OSGWIDGET_H
#define OSGWIDGET_H

#include <QWidget>
#include <osgQt/GraphicsWindowQt>
#include <osgQt/QGraphicsViewAdapter>
#include <osgViewer/Viewer>
#include <osg/ref_ptr>
#include <osg/PositionAttitudeTransform>
#include <osgViewer/Viewer>
#include <osgViewer/CompositeViewer>
#include <osgGA/TrackballManipulator>
#include <osgGA/StateSetManipulator>
#include <osgViewer/ViewerEventHandlers>
#include <osg/Node>
#include <osg/Group>
#include <osgDB/ReadFile>
#include <osgDB/WriteFile>
#include <osg/Referenced>
#include <QtGui/QApplication>
#include <QTimer>
#include <QFrame>
#include <QGridLayout>

QT_BEGIN_NAMESPACE
class QDragEnterEvent;
class QDropEvent;
QT_END_NAMESPACE

class osgWidget : public QFrame, public osgViewer::CompositeViewer
{
    Q_OBJECT

public:
    explicit osgWidget(QWidget *parent = 0);
    virtual ~osgWidget();
    void loadFile();
    virtual void paintEvent( QPaintEvent* event )
    { frame(); }

    QWidget* addViewWidget( osg::Node* scene );
    osg::Camera* createCamera( int x, int y, int w, int h, const std::string& name="", bool windowDecoration=false );
    void addCube(QString obj,int x, int y, int z);
    void addSphere(QString obj, int x, int y, int z);
    void addPyramid(QString obj, int x, int y, int z);
    void addLight(QString obj, int x, int y, int z);
    void setPosition(osg::Node *node);
    const char *toString(int value);

    QWidget *parentWidget;
    QWidget* widget;
    osg::Camera* camera;
    QGridLayout* grid;
    osgViewer::View* view;
    int cubes,spheres,pyramids,lights;

private:
      osg::Group* group;
      osgViewer::Viewer *viewer;
      osg::Node *model;

signals:
    void openedFile(QString);
    void addToTree(QString);
    void deleteFromTree(QString);
    void deleteTree();

protected:
    QTimer _timer;
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);
    void mousePressEvent(QMouseEvent *event);

public slots:
    void runViewer(QString value);
    void saveFile(QString file);
    void getResult();
    void positionObject(osg::Node *node,int x,int y,int z);
    void deleteNode(QString obj);
    void deleteScene();
    void setColor(QString node,int R, int G, int B);
};

#endif // OSGWIDGET_H
