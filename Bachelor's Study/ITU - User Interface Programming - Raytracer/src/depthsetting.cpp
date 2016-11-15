#include "depthsetting.h"
#include "ui_depth.h"
#include <iostream>
#include <QSlider>

#define MAX_DEPTH 99
#define MIN_DEPTH 1

depthSetting::depthSetting(QWidget *parent, int parentDepth) :
        QDialog(parent),
        ui(new Ui::depthWindow)
{
    depth.setNum(parentDepth);
    if(depth.toInt() > MAX_DEPTH) depth.setNum(MAX_DEPTH);
    if(depth.toInt() < MIN_DEPTH) depth.setNum(MIN_DEPTH);

    ui->setupUi(this);
    ui->lineEdit->clear();
    ui->lineEdit->insert(depth);
    ui->horizontalSlider->setValue(depth.toInt());

    connect(ui->okButt, SIGNAL( clicked() ), this, SLOT ( setDepth() ) );
    connect(ui->canceButt, SIGNAL( clicked() ), this, SLOT ( close() ) );
    connect(this, SIGNAL( sendDepth(int) ), this->parent(), SLOT ( setDepth(int) ) );
    connect(ui->horizontalSlider,SIGNAL(valueChanged(int)),this,SLOT(myDepth(int)));
}

depthSetting::~depthSetting()
{
    delete ui;
}

void depthSetting::myDepth(int position)
{
   depth.setNum(position);
   ui->lineEdit->clear();
   ui->lineEdit->insert(depth);
   ui->lineEdit->update();
}

void depthSetting::setDepth()
{
   ui->horizontalSlider->sliderPosition();

   sendDepth(ui->horizontalSlider->sliderPosition());
   this->close();

}
