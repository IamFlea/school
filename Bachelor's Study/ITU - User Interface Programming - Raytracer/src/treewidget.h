#ifndef TREEWIDGET_H
#define TREEWIDGET_H

#include <QDockWidget>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QModelIndex>

class TreeWidget : public QDockWidget
{
Q_OBJECT
private:
    bool hidden;
    bool fixed;
    QString arrowHidden;
    QString arrowShowed;
    QRect myGeometry;
    QWidget *myChild;
    int lastDock;
    QTreeWidget *tree;
    QTreeWidgetItem *topItem;

    QString node;
    int R,G,B;

protected:
    void enterEvent ( QEvent * event );
    void leaveEvent ( QEvent * event );

public:
    explicit TreeWidget (QWidget *parent = 0);

signals:
    void hideYou ();
    void showYou ();
    void changeArrow (QString);
    void addTreeItem(const QTreeWidgetItem*);
    void deleteNode(QString); // odesle signal osgWidgetu
    void settingNode(QString);
    void setFileName (QString);
    void setNewColor(QString,int,int,int);
    void insertR(int);
    void insertG(int);
    void insertB(int);


public slots:
    void changeFixed ();
    void hideMe ();
    void changeDock (Qt::DockWidgetArea);
    void initChildren();

    void addObject(QString);
    void removeObject(QString); // prijme signal pro smazani
    void deleteItem(QTreeWidgetItem*,int);
    void deleteAll();
    void myOpenFile ();
    void getItemName(QTreeWidgetItem*,int);

    void setR(int newR);
    void setG(int newG);
    void setB(int newB);
    void getColor();

};

#endif // TREEWIDGET_H
