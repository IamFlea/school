#include <QtGui/QApplication>
#include <osgQt/GraphicsWindowQt>
#include "mainwindow.h"

USE_GRAPICSWINDOW_IMPLEMENTATION(Qt);

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
