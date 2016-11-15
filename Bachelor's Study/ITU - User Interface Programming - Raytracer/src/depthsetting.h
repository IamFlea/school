#ifndef DEPTHSETTING_H
#define DEPTHSETTING_H

#include <QDialog>
#include "ui_depth.h"

#define DEFAULT_DEPTH 10

namespace Ui {
    class depthWindow;
}

class depthSetting : public QDialog
{
    Q_OBJECT

public:
    depthSetting(QWidget *parent = 0, int depth = DEFAULT_DEPTH);
    ~depthSetting();

private:
    Ui::depthWindow *ui;
    QString depth;

private slots:
    void setDepth();
    void myDepth(int position);

signals:
    void sendDepth(int newDepth);

};

#endif // DEPTHSETTING_H
