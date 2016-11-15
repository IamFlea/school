#include "objectlabel.h"
#include <QLabel>

objectLabel::objectLabel(QWidget *parent) :
    QLabel(parent)
{
}

void objectLabel::setObject(QString file){
    this->setPixmap(QPixmap(file));
    this->show();
}

void objectLabel::setFile(QString file){
    setObject(file);
}
