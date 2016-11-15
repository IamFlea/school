#include <iostream>
#include "mybutton.h"

myButton::myButton(QWidget *parent) :
    QPushButton(parent)
{

    if(parent->objectName() == "funcWid"){
        ico.addFile(QString(":/icons/right_arrow.png"));
    }else{
        ico.addFile(QString(":/icons/left_arrow.png"));
    }
    this->setIcon(ico);
}

void myButton::changeIcon(QString file)
{
    ico.addFile(file);
    this->setIcon(ico);
}
