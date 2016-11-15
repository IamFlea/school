/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created: Wed Dec 5 09:50:07 2012
**      by: Qt User Interface Compiler version 4.6.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QDockWidget>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QStatusBar>
#include <QtGui/QToolBar>
#include <QtGui/QToolBox>
#include <QtGui/QTreeWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include "objectlabel.h"
#include "objectwidget.h"
#include "osgwidget.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionAbout;
    QAction *actionNew;
    QAction *actionOpen;
    QAction *actionSave;
    QAction *actionExit;
    QAction *actionTextures;
    QAction *actionShaders;
    QAction *actionDepth_setting;
    QAction *actionScene_tree;
    QAction *actionFunctions;
    QWidget *centralWidget;
    QVBoxLayout *verticalLayout;
    osgWidget *widget;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;
    QDockWidget *treeDock;
    QWidget *treeMainWidget;
    QVBoxLayout *verticalLayout_2;
    QTreeWidget *treeWidget;
    QDockWidget *functionDock;
    QWidget *functionWidget;
    QVBoxLayout *verticalLayout_3;
    QToolBox *toolBox;
    QWidget *position;
    QWidget *rotation;
    QWidget *color;
    QWidget *textures;
    QWidget *shaders;
    QMenuBar *menuBar;
    QMenu *menuHelp;
    QMenu *menuRaytracer;
    QMenu *menuAdvanced;
    QMenu *menuView;
    QMenu *menuFile;
    QDockWidget *objectDock;
    QWidget *objects;
    QHBoxLayout *horizontalLayout;
    objectWidget *objectFrame;
    QHBoxLayout *horizontalLayout_2;
    objectLabel *cube;
    objectLabel *sphere;
    objectLabel *pyramid;
    objectLabel *light;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(600, 400);
        MainWindow->setMinimumSize(QSize(600, 400));
        actionAbout = new QAction(MainWindow);
        actionAbout->setObjectName(QString::fromUtf8("actionAbout"));
        actionNew = new QAction(MainWindow);
        actionNew->setObjectName(QString::fromUtf8("actionNew"));
        actionOpen = new QAction(MainWindow);
        actionOpen->setObjectName(QString::fromUtf8("actionOpen"));
        actionSave = new QAction(MainWindow);
        actionSave->setObjectName(QString::fromUtf8("actionSave"));
        actionExit = new QAction(MainWindow);
        actionExit->setObjectName(QString::fromUtf8("actionExit"));
        actionTextures = new QAction(MainWindow);
        actionTextures->setObjectName(QString::fromUtf8("actionTextures"));
        actionTextures->setCheckable(true);
        actionShaders = new QAction(MainWindow);
        actionShaders->setObjectName(QString::fromUtf8("actionShaders"));
        actionShaders->setCheckable(true);
        actionDepth_setting = new QAction(MainWindow);
        actionDepth_setting->setObjectName(QString::fromUtf8("actionDepth_setting"));
        actionScene_tree = new QAction(MainWindow);
        actionScene_tree->setObjectName(QString::fromUtf8("actionScene_tree"));
        actionScene_tree->setCheckable(true);
        actionScene_tree->setChecked(true);
        actionScene_tree->setEnabled(true);
        actionFunctions = new QAction(MainWindow);
        actionFunctions->setObjectName(QString::fromUtf8("actionFunctions"));
        actionFunctions->setCheckable(true);
        actionFunctions->setChecked(true);
        actionFunctions->setEnabled(true);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        verticalLayout = new QVBoxLayout(centralWidget);
        verticalLayout->setSpacing(6);
        verticalLayout->setContentsMargins(11, 11, 11, 11);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        widget = new osgWidget(centralWidget);
        widget->setObjectName(QString::fromUtf8("widget"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(widget->sizePolicy().hasHeightForWidth());
        widget->setSizePolicy(sizePolicy);
        widget->setMinimumSize(QSize(0, 200));
        widget->setAutoFillBackground(true);

        verticalLayout->addWidget(widget);

        MainWindow->setCentralWidget(centralWidget);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);
        treeDock = new QDockWidget(MainWindow);
        treeDock->setObjectName(QString::fromUtf8("treeDock"));
        treeDock->setEnabled(true);
        QSizePolicy sizePolicy1(QSizePolicy::MinimumExpanding, QSizePolicy::MinimumExpanding);
        sizePolicy1.setHorizontalStretch(0);
        sizePolicy1.setVerticalStretch(0);
        sizePolicy1.setHeightForWidth(treeDock->sizePolicy().hasHeightForWidth());
        treeDock->setSizePolicy(sizePolicy1);
        treeDock->setMinimumSize(QSize(120, 243));
        treeDock->setFloating(false);
        treeDock->setFeatures(QDockWidget::DockWidgetMovable);
        treeDock->setAllowedAreas(Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea);
        treeDock->setWindowTitle(QString::fromUtf8(""));
        treeMainWidget = new QWidget();
        treeMainWidget->setObjectName(QString::fromUtf8("treeMainWidget"));
        sizePolicy.setHeightForWidth(treeMainWidget->sizePolicy().hasHeightForWidth());
        treeMainWidget->setSizePolicy(sizePolicy);
        treeMainWidget->setMinimumSize(QSize(110, 0));
        treeMainWidget->setMouseTracking(true);
        treeMainWidget->setAcceptDrops(true);
        verticalLayout_2 = new QVBoxLayout(treeMainWidget);
        verticalLayout_2->setSpacing(0);
        verticalLayout_2->setContentsMargins(11, 11, 11, 11);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setSizeConstraint(QLayout::SetFixedSize);
        verticalLayout_2->setContentsMargins(5, 0, 0, 0);
        treeWidget = new QTreeWidget(treeMainWidget);
        treeWidget->setObjectName(QString::fromUtf8("treeWidget"));
        treeWidget->setEnabled(true);
        sizePolicy1.setHeightForWidth(treeWidget->sizePolicy().hasHeightForWidth());
        treeWidget->setSizePolicy(sizePolicy1);
        treeWidget->setMinimumSize(QSize(100, 200));

        verticalLayout_2->addWidget(treeWidget);

        treeDock->setWidget(treeMainWidget);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), treeDock);
        functionDock = new QDockWidget(MainWindow);
        functionDock->setObjectName(QString::fromUtf8("functionDock"));
        functionDock->setEnabled(true);
        sizePolicy1.setHeightForWidth(functionDock->sizePolicy().hasHeightForWidth());
        functionDock->setSizePolicy(sizePolicy1);
        functionDock->setMinimumSize(QSize(100, 243));
        functionDock->setFloating(false);
        functionDock->setFeatures(QDockWidget::DockWidgetMovable);
        functionDock->setAllowedAreas(Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea);
        functionDock->setWindowTitle(QString::fromUtf8(""));
        functionWidget = new QWidget();
        functionWidget->setObjectName(QString::fromUtf8("functionWidget"));
        sizePolicy.setHeightForWidth(functionWidget->sizePolicy().hasHeightForWidth());
        functionWidget->setSizePolicy(sizePolicy);
        verticalLayout_3 = new QVBoxLayout(functionWidget);
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setContentsMargins(11, 11, 11, 11);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        toolBox = new QToolBox(functionWidget);
        toolBox->setObjectName(QString::fromUtf8("toolBox"));
        sizePolicy1.setHeightForWidth(toolBox->sizePolicy().hasHeightForWidth());
        toolBox->setSizePolicy(sizePolicy1);
        toolBox->setMinimumSize(QSize(0, 0));
        toolBox->setMaximumSize(QSize(16777215, 200));
        position = new QWidget();
        position->setObjectName(QString::fromUtf8("position"));
        position->setEnabled(false);
        position->setGeometry(QRect(0, 0, 82, 30));
        position->setMaximumSize(QSize(16777215, 30));
        toolBox->addItem(position, QString::fromUtf8("Position"));
        rotation = new QWidget();
        rotation->setObjectName(QString::fromUtf8("rotation"));
        rotation->setGeometry(QRect(0, 0, 82, 30));
        rotation->setMaximumSize(QSize(16777215, 30));
        toolBox->addItem(rotation, QString::fromUtf8("Rotate"));
        color = new QWidget();
        color->setObjectName(QString::fromUtf8("color"));
        color->setGeometry(QRect(0, 0, 82, 30));
        color->setMaximumSize(QSize(16777215, 30));
        toolBox->addItem(color, QString::fromUtf8("Color"));
        textures = new QWidget();
        textures->setObjectName(QString::fromUtf8("textures"));
        textures->setGeometry(QRect(0, 0, 82, 30));
        textures->setMaximumSize(QSize(16777215, 30));
        toolBox->addItem(textures, QString::fromUtf8("Textures"));
        shaders = new QWidget();
        shaders->setObjectName(QString::fromUtf8("shaders"));
        shaders->setGeometry(QRect(0, 0, 82, 30));
        shaders->setMaximumSize(QSize(16777215, 30));
        toolBox->addItem(shaders, QString::fromUtf8("Shaders"));

        verticalLayout_3->addWidget(toolBox);

        functionDock->setWidget(functionWidget);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(2), functionDock);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 600, 23));
        menuHelp = new QMenu(menuBar);
        menuHelp->setObjectName(QString::fromUtf8("menuHelp"));
        menuRaytracer = new QMenu(menuBar);
        menuRaytracer->setObjectName(QString::fromUtf8("menuRaytracer"));
        menuAdvanced = new QMenu(menuBar);
        menuAdvanced->setObjectName(QString::fromUtf8("menuAdvanced"));
        menuView = new QMenu(menuBar);
        menuView->setObjectName(QString::fromUtf8("menuView"));
        menuFile = new QMenu(menuBar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        MainWindow->setMenuBar(menuBar);
        objectDock = new QDockWidget(MainWindow);
        objectDock->setObjectName(QString::fromUtf8("objectDock"));
        objectDock->setMinimumSize(QSize(418, 130));
        objectDock->setMouseTracking(false);
        objectDock->setContextMenuPolicy(Qt::NoContextMenu);
        objectDock->setAcceptDrops(false);
        objectDock->setFeatures(QDockWidget::NoDockWidgetFeatures);
        objectDock->setAllowedAreas(Qt::NoDockWidgetArea);
        objects = new QWidget();
        objects->setObjectName(QString::fromUtf8("objects"));
        objects->setMinimumSize(QSize(0, 100));
        horizontalLayout = new QHBoxLayout(objects);
        horizontalLayout->setSpacing(6);
        horizontalLayout->setContentsMargins(11, 11, 11, 11);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        objectFrame = new objectWidget(objects);
        objectFrame->setObjectName(QString::fromUtf8("objectFrame"));
        objectFrame->setMinimumSize(QSize(0, 100));
        horizontalLayout_2 = new QHBoxLayout(objectFrame);
        horizontalLayout_2->setSpacing(0);
        horizontalLayout_2->setContentsMargins(0, 0, 0, 0);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        cube = new objectLabel(objectFrame);
        cube->setObjectName(QString::fromUtf8("cube"));
        cube->setMinimumSize(QSize(100, 100));
        cube->setMaximumSize(QSize(100, 100));

        horizontalLayout_2->addWidget(cube);

        sphere = new objectLabel(objectFrame);
        sphere->setObjectName(QString::fromUtf8("sphere"));
        sphere->setMinimumSize(QSize(100, 100));
        sphere->setMaximumSize(QSize(100, 100));

        horizontalLayout_2->addWidget(sphere);

        pyramid = new objectLabel(objectFrame);
        pyramid->setObjectName(QString::fromUtf8("pyramid"));
        pyramid->setMinimumSize(QSize(100, 100));
        pyramid->setMaximumSize(QSize(100, 100));

        horizontalLayout_2->addWidget(pyramid);

        light = new objectLabel(objectFrame);
        light->setObjectName(QString::fromUtf8("light"));
        light->setMinimumSize(QSize(80, 80));
        light->setMaximumSize(QSize(100, 100));

        horizontalLayout_2->addWidget(light);


        horizontalLayout->addWidget(objectFrame);

        objectDock->setWidget(objects);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), objectDock);
        functionDock->raise();
        treeDock->raise();

        menuBar->addAction(menuFile->menuAction());
        menuBar->addAction(menuView->menuAction());
        menuBar->addAction(menuAdvanced->menuAction());
        menuBar->addAction(menuRaytracer->menuAction());
        menuBar->addAction(menuHelp->menuAction());
        menuHelp->addAction(actionAbout);
        menuRaytracer->addAction(actionDepth_setting);
        menuAdvanced->addAction(actionTextures);
        menuAdvanced->addAction(actionShaders);
        menuView->addAction(actionScene_tree);
        menuView->addAction(actionFunctions);
        menuFile->addAction(actionNew);
        menuFile->addSeparator();
        menuFile->addAction(actionOpen);
        menuFile->addAction(actionSave);
        menuFile->addSeparator();
        menuFile->addAction(actionExit);

        retranslateUi(MainWindow);
        QObject::connect(actionExit, SIGNAL(activated()), MainWindow, SLOT(close()));
        QObject::connect(actionScene_tree, SIGNAL(toggled(bool)), treeDock, SLOT(setVisible(bool)));
        QObject::connect(actionFunctions, SIGNAL(toggled(bool)), functionDock, SLOT(setVisible(bool)));

        toolBox->setCurrentIndex(0);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0, QApplication::UnicodeUTF8));
        actionAbout->setText(QApplication::translate("MainWindow", "About", 0, QApplication::UnicodeUTF8));
        actionNew->setText(QApplication::translate("MainWindow", "New", 0, QApplication::UnicodeUTF8));
        actionOpen->setText(QApplication::translate("MainWindow", "Open", 0, QApplication::UnicodeUTF8));
        actionSave->setText(QApplication::translate("MainWindow", "Save", 0, QApplication::UnicodeUTF8));
        actionExit->setText(QApplication::translate("MainWindow", "Exit", 0, QApplication::UnicodeUTF8));
        actionTextures->setText(QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
        actionShaders->setText(QApplication::translate("MainWindow", "Shaders", 0, QApplication::UnicodeUTF8));
        actionDepth_setting->setText(QApplication::translate("MainWindow", "Depth setting", 0, QApplication::UnicodeUTF8));
        actionScene_tree->setText(QApplication::translate("MainWindow", "Scene tree", 0, QApplication::UnicodeUTF8));
        actionFunctions->setText(QApplication::translate("MainWindow", "Functions", 0, QApplication::UnicodeUTF8));
        QTreeWidgetItem *___qtreewidgetitem = treeWidget->headerItem();
        ___qtreewidgetitem->setText(0, QApplication::translate("MainWindow", "Scene", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(position), QApplication::translate("MainWindow", "Position", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(rotation), QApplication::translate("MainWindow", "Rotate", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(color), QApplication::translate("MainWindow", "Color", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(textures), QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(shaders), QApplication::translate("MainWindow", "Shaders", 0, QApplication::UnicodeUTF8));
        menuHelp->setTitle(QApplication::translate("MainWindow", "Help", 0, QApplication::UnicodeUTF8));
        menuRaytracer->setTitle(QApplication::translate("MainWindow", "Raytracer", 0, QApplication::UnicodeUTF8));
        menuAdvanced->setTitle(QApplication::translate("MainWindow", "Advanced", 0, QApplication::UnicodeUTF8));
        menuView->setTitle(QApplication::translate("MainWindow", "View", 0, QApplication::UnicodeUTF8));
        menuFile->setTitle(QApplication::translate("MainWindow", "File", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
