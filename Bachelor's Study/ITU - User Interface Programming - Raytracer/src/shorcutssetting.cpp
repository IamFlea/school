#include "mainwindow.h"
#include "shorcutssetting.h"
#include "ui_shotcuts.h"
#include <QDialog>
#include <iostream>

shorcutssetting::shorcutssetting(MainWindow *parent) :
    QDialog(parent),
    ui(new Ui::shorcuts)
{
    ui->setupUi(this);
    connect(ui->OkButt,SIGNAL(clicked()),this,SLOT(setShortcuts()));
    connect(ui->CancelButt,SIGNAL(clicked()),this,SLOT(close()));
    connect(this,SIGNAL(sendAction(int,QString)),parent,SLOT(setShorcut(int,QString)));
}

shorcutssetting::~shorcutssetting()
{
    delete ui;
}

void shorcutssetting::initShortcut(int action, QString value)
{
    switch(action)
    {
        case newAct:
            ui->newLine->setText(value);
            break;
        case openAct:
            ui->openLine->setText(value);
            break;
        case saveAct:
            ui->saveLine->setText(value);
            break;
        case exitAct:
            ui->exitLine->setText(value);
            break;

        default:
            break;
    }
}

void shorcutssetting::setShortcuts()
{
    sendAction(newAct,ui->newLine->text());
    sendAction(openAct,ui->openLine->text());
    sendAction(saveAct,ui->saveLine->text());
    sendAction(exitAct,ui->exitLine->text());
    this->close();
}
