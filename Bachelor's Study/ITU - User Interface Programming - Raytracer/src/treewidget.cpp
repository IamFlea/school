#include "treewidget.h"
#include <iostream>
#include <iterator>
#include <QLabel>
#include <QList>
#include <QTreeWidgetItem>
#include <QFileDialog>

TreeWidget::TreeWidget(QWidget *parent) :
    QDockWidget(parent)
{
    hidden = false;
    fixed = false;
    R = 192;
    G = 192;
    B = 192;
}

void TreeWidget::initChildren()
{
    insertR(R);
    insertG(G);
    insertB(B);

    QWidget* funcChild = this->findChild<QWidget*>("funcWid");
    QWidget* treeChild = this->findChild<QWidget*>("treeWid");

    if(funcChild != NULL) {
        funcChild->setLayoutDirection(Qt::LeftToRight);
        arrowHidden = QString(":/icons/left_arrow.png");
        arrowShowed = QString(":/icons/right_arrow.png");
        lastDock = Qt::RightDockWidgetArea;
        myChild = funcChild;


    } else if(treeChild != NULL) {
        treeChild->setLayoutDirection(Qt::LeftToRight);
        arrowHidden = QString(":/icons/right_arrow.png");
        arrowShowed = QString(":/icons/left_arrow.png");
        lastDock = Qt::LeftDockWidgetArea;
        myChild = treeChild;
        tree = myChild->findChild<QTreeWidget*>("treeWidget");
        tree->setColumnCount(1);
        tree->setHeaderLabel (QString("Raytracer"));

        topItem = new QTreeWidgetItem();
        topItem->setText(0, "Scene");
        tree->addTopLevelItem(topItem);
    }

}

void TreeWidget::enterEvent ( QEvent * event )
{
    if(fixed) {
        hideMe();
    }
};

void TreeWidget::leaveEvent ( QEvent * event )
{
    if(fixed) {
        hideMe();
    }
};

void TreeWidget::changeFixed()
{
    fixed = !fixed;
}

void TreeWidget::changeDock(Qt::DockWidgetArea dock) {

    if(dock != lastDock) {
        QString tmp = arrowHidden;
        arrowHidden = arrowShowed;
        arrowShowed = tmp;

        if(hidden) {
            changeArrow(arrowHidden);
        } else {
            changeArrow(arrowShowed);
        }

        if(myChild->layoutDirection() == Qt::RightToLeft) {
            myChild->setLayoutDirection(Qt::LeftToRight);
        } else {
            myChild->setLayoutDirection(Qt::RightToLeft);
        }
        lastDock = dock;
    }
}

void TreeWidget::hideMe()
{
    if (hidden) { // schovano
        changeArrow(arrowShowed);
        showYou();
        this->setMaximumWidth(524287);
        this->setMinimumWidth(120);
        hidden = false;
    } else { // roztazeno
        changeArrow(arrowHidden);
        this->setMinimumWidth(18);
        this->setMaximumWidth(18);
        hideYou();
        hidden = true;
    }
}

void TreeWidget::addObject(QString name)
{
    QTreeWidgetItem *item = new QTreeWidgetItem();
    item->setText(0,name);
    topItem->addChild(item);
}

void TreeWidget::removeObject(QString name)
{
    QTreeWidgetItemIterator it(topItem);

    while (*it) {
        if ((*it)->text(0) == name){
            topItem->removeChild(*it);
            deleteNode(name);
            break;
        }
        ++it;
    }
}

void TreeWidget::deleteAll()
{
    topItem->takeChildren();
}

void TreeWidget::deleteItem(QTreeWidgetItem* item,int pos)
{
    removeObject(item->text(pos));
    deleteNode(item->text(pos));
}

void TreeWidget::getItemName(QTreeWidgetItem* item,int pos)
{
    node = item->text(pos);
}

void TreeWidget::myOpenFile()
{
    QString name = QFileDialog::getOpenFileName(this, tr("Open Texture File"),"",tr("File (*.png *.jpg *.jpeg)"));
    setFileName(name);
}

void TreeWidget::setR(int newR)
{
    R = newR;
}

void TreeWidget::setG(int newG)
{
    G = newG;
}

void TreeWidget::setB(int newB)
{
    B = newB;
}

void TreeWidget::getColor()
{
    setNewColor(node,R,G,B);
}

