#ifndef MYBUTTON_H
#define MYBUTTON_H

#include <QWidget>
#include <QPushButton>
#include "treewidget.h"

class myButton : public QPushButton
{
Q_OBJECT
public:
    explicit myButton(QWidget *parent = 0);
    QIcon ico;

signals:

public slots:
    void changeIcon(QString);

};

#endif // MYBUTTON_H
