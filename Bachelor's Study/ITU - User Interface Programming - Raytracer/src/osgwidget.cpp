#include "osgwidget.h"
#include <QtCore/QTimer>
#include <QtGui/QApplication>
#include <QtGui/QGridLayout>
#include <QLabel>

#include <osgViewer/CompositeViewer>
#include <osgViewer/ViewerEventHandlers>
#include <osgGA/TrackballManipulator>
#include <osgDB/ReadFile>
#include <osgDB/WriteFile>
#include <osgQt/GraphicsWindowQt>
#include <osg/Node>
#include <osg/Material>
#include <osg/Group>
#include <osg/Geode>
#include <osg/ShapeDrawable>
#include <iostream>
#include <ostream>

osgWidget::osgWidget(QWidget *parent) :
        QFrame(parent)
{
    this->setGeometry( parent->x(),parent->y(),parent->width(),parent->height());
    setThreadingModel(osgViewer::ViewerBase::SingleThreaded);

    cubes = 0;
    spheres = 0;
    pyramids = 0;
    lights = 0;

    model = new osg::Node();
    group = new osg::Group();

    camera = createCamera(parent->x(),parent->y(),parent->width(),parent->height());
    QWidget* widget = addViewWidget( group );

    grid = new QGridLayout;
    grid->addWidget(widget);
    setLayout( grid );

   connect( &_timer, SIGNAL(timeout()), this, SLOT(update()) );
   _timer.start( 10 );
}

osgWidget::~osgWidget()
{

}

QWidget* osgWidget::addViewWidget(osg::Node* scene )
{
    view = new osgViewer::View;
    view->setCamera( camera );
    addView( view );
    view->setSceneData( scene );
    view->addEventHandler( new osgViewer::StatsHandler );
    view->setCameraManipulator( new osgGA::TrackballManipulator );

    osgQt::GraphicsWindowQt* gw = dynamic_cast<osgQt::GraphicsWindowQt*>( camera->getGraphicsContext() );
    return gw ? gw->getGLWidget() : NULL;
}

osg::Camera* osgWidget::createCamera( int x, int y, int w, int h, const std::string& name, bool windowDecoration )
{
    osg::DisplaySettings* ds = osg::DisplaySettings::instance().get();
    osg::ref_ptr<osg::GraphicsContext::Traits> traits = new osg::GraphicsContext::Traits;
    traits->windowName = name;
    traits->windowDecoration = windowDecoration;
    traits->x = x;
    traits->y = y;
    traits->width = w;
    traits->height = h;
    traits->doubleBuffer = true;
    traits->alpha = ds->getMinimumNumAlphaBits();
    traits->stencil = ds->getMinimumNumStencilBits();
    traits->sampleBuffers = ds->getMultiSamples();
    traits->samples = ds->getNumMultiSamples();

    osg::ref_ptr<osg::Camera> camera = new osg::Camera;
    camera->setGraphicsContext( new osgQt::GraphicsWindowQt(traits.get()) );

    camera->setClearColor( osg::Vec4(0.2, 0.2, 0.6, 1.0) );
    camera->setViewport( new osg::Viewport(0, 0, traits->width, traits->height) );
    camera->setProjectionMatrixAsPerspective(
        30.0f, static_cast<double>(traits->width)/static_cast<double>(traits->height), 1.0f, 10000.0f );
    return camera.release();
}


void osgWidget::runViewer(QString file)
{
    view->init();

    if(group != NULL){
        group->removeChildren(0,group->getNumChildren());
        deleteTree();
    }

    model = osgDB::readNodeFile(file.toStdString());
    if(model != NULL){
        model->addDescription(file.toStdString().c_str());
        addToTree(file);
    }
    group->addChild(model);
    view->setSceneData(group);
}

void osgWidget::saveFile(QString file)
{
   osgDB::writeNodeFile(*group,file.toStdString()+".osg");
}

void osgWidget::addCube(QString obj, int x, int y, int z)
{
    osg::Geode* cube = new osg::Geode();
    cube->addDrawable(new osg::ShapeDrawable(new osg::Box()));
    cube->addDescription(obj.toStdString().c_str());
    positionObject(cube,x,y,z);
    view->setSceneData(group);
    cubes++;
}

void osgWidget::addSphere(QString obj, int x, int y, int z)
{
    osg::Geode* sphere = new osg::Geode();
    sphere->addDrawable(new osg::ShapeDrawable(new osg::Sphere()));
    sphere->addDescription(obj.toStdString().c_str());
    positionObject(sphere,x,y,z);
    view->setSceneData(group);
    spheres++;
}

void osgWidget::addPyramid(QString obj, int x, int y, int z)
{
    pyramids++;
}

void osgWidget::addLight(QString obj, int x, int y, int z)
{
    lights++;
}

void osgWidget::positionObject(osg::Node *node,int x,int y,int z)
{
    double dbX = x/50.0;
    double dbY = y/50.0;
    double dbZ = z/50.0;

    if(group->containsNode(node)){
        group->removeChild(node);
    }
    osg::PositionAttitudeTransform* transformObj = new osg::PositionAttitudeTransform();
    transformObj->addChild(node);
    transformObj->addDescription(node->getDescription(0));
    transformObj->setPosition(osg::Vec3(dbX,dbY,dbZ));
    group->addChild(transformObj);
}

void osgWidget::dragEnterEvent(QDragEnterEvent *event)
{
    if (event->mimeData()->hasText()) {
        if (event->source() == this) {
            event->setDropAction(Qt::MoveAction);
            event->accept();
        } else {
            event->acceptProposedAction();
        }
    } else {
        event->ignore();
    }
}

void osgWidget::dragMoveEvent(QDragMoveEvent *event)
{
    if (event->mimeData()->hasText()) {
        if (event->source() == this) {
            event->setDropAction(Qt::MoveAction);
            event->accept();
        } else {
            event->acceptProposedAction();
        }
    } else {
        event->ignore();
    }
}

void osgWidget::dropEvent(QDropEvent *event)
{
    if (event->mimeData()->hasText()) {
        QPoint point;
        point = event->pos();

        QString str = event->mimeData()->text();
        QString object = str+"_";
        openedFile(str);

        if(str == "cube"){
            object.append(QString::number(cubes));
            addCube(object,point.x(),point.y(),0);


        }else if(str == "sphere"){
            object.append(QString::number(spheres));
            addSphere(object,point.x(),point.y(),0);

        }else if(str == "pyramid"){
            object.append(QString::number(pyramids));
            addPyramid(object,point.x(),point.y(),0);

        }else if(str == "light"){
            object.append(QString::number(lights));
            addLight(object,point.x(),point.y(),0);

        } else return;

        addToTree(object);

        if (event->source() == this) {
            event->setDropAction(Qt::MoveAction);
            event->accept();
        } else {
            event->acceptProposedAction();
        }
    } else {
        event->ignore();
    }
}

void osgWidget::mousePressEvent(QMouseEvent *event)
{
    std::cout<<"HIT OBJECT"<<std::endl;
}

const char *osgWidget::toString(int value)
{
    std::ostringstream oss;
    oss << value;
    std::string str = oss.str();
    return str.c_str();
}

void osgWidget::deleteNode(QString obj)
{
    int count = group->getNumChildren();
    for(int i=0;i<count;i++){
        osg::Node *node = group->getChild(i);
        if(node->getDescription(0) == obj.toStdString()){
            group->removeChild(node);
            break;
        }
    }
}

void osgWidget::setColor(QString object,int R, int G, int B)
{
    int count = group->getNumChildren();
    for(int i=0;i<count;i++){
        osg::Node *node = group->getChild(i);
        if(node->getDescription(0) == object.toStdString()){

            osg::Material *material = new osg::Material();
            material->setColorMode(osg::Material::OFF);
            material->setEmission(osg::Material::FRONT_AND_BACK,osg::Vec4(R/255.0,G/255.0,B/255.0,1.0f));

            osg::StateSet *state;
            state = node->getOrCreateStateSet();
            state ->setAttributeAndModes(material,osg::StateAttribute::OVERRIDE);

            break;
        }
    }
}

void osgWidget::getResult()
{
    QWidget *result = new QWidget();
    result->setWindowTitle(QString("Render result"));
    QPixmap *map = new QPixmap(QString(":/objects/cornell_box.jpg"));
    QLabel *label = new QLabel(result);
    label->setMinimumHeight(map->height());
    label->setMinimumWidth(map->width());
    result->show();
    label->show();
    label->setPixmap(*map);
}

void osgWidget::deleteScene()
{
    if(group != NULL){
        group->removeChildren(0,group->getNumChildren());
        deleteTree();
    }
}
