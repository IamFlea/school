#ifndef SHORCUTSSETTING_H
#define SHORCUTSSETTING_H

#include <QWidget>
#include <QDialog>
#include "ui_shotcuts.h"
#include "mainwindow.h"

namespace Ui {
    class shorcuts;
}

enum{
    newAct,
    openAct,
    saveAct,
    exitAct,
    addCube,
    addSphere,
    addPyramid,
    addLight,
    addNew
};

class shorcutssetting : public QDialog
{
Q_OBJECT
public:
    explicit shorcutssetting(MainWindow *parent);
    ~shorcutssetting();
    void initShortcut(int action, QString value);

private:
    Ui::shorcuts *ui;
    QWidget *scParent;

signals:
    void sendAction(int,QString);
    
public slots:
    void setShortcuts();
};

#endif // SHORCUTSSETTING_H
