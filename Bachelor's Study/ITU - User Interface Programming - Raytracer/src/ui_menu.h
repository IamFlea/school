/********************************************************************************
** Form generated from reading UI file 'menu.ui'
**
** Created: Mon Dec 10 17:09:45 2012
**      by: Qt User Interface Compiler version 4.6.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MENU_H
#define UI_MENU_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QFormLayout>
#include <QtGui/QGridLayout>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QMainWindow>
#include <QtGui/QMenu>
#include <QtGui/QMenuBar>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QSpacerItem>
#include <QtGui/QSpinBox>
#include <QtGui/QStatusBar>
#include <QtGui/QToolBox>
#include <QtGui/QToolButton>
#include <QtGui/QTreeWidget>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>
#include "mybutton.h"
#include "objectlabel.h"
#include "objectwidget.h"
#include "osgwidget.h"
#include "treewidget.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QAction *actionNew;
    QAction *actionOpen;
    QAction *actionSave;
    QAction *actionExit;
    QAction *actionScene_tree;
    QAction *actionFunctions;
    QAction *actionTextures;
    QAction *actionShaders;
    QAction *actionDepth_setting;
    QAction *actionAbout;
    QAction *actionShortcuts;
    QAction *actionUndo;
    QAction *actionRedo;
    QAction *actionObjects;
    QWidget *centralwidget;
    QVBoxLayout *verticalLayout_4;
    osgWidget *widget;
    QVBoxLayout *verticalLayout_3;
    QSpacerItem *horizontalSpacer_2;
    QSpacerItem *verticalSpacer;
    objectWidget *objectFrame;
    QHBoxLayout *horizontalLayout_2;
    objectLabel *cube;
    objectLabel *sphere;
    objectLabel *pyramid;
    objectLabel *light;
    QWidget *add;
    QHBoxLayout *horizontalLayout;
    QPushButton *addButt;
    QWidget *doRender;
    QHBoxLayout *horizontalLayout_10;
    QPushButton *doIt;
    QMenuBar *menubar;
    QMenu *menuFile;
    QMenu *menuView;
    QMenu *menuAdvanced;
    QMenu *menuRaytracer;
    QMenu *menuHelp;
    QMenu *menuEdit;
    QStatusBar *statusbar;
    TreeWidget *functionDock;
    QWidget *funcWid;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout_9;
    myButton *pushButton_2;
    QSpacerItem *horizontalSpacer_3;
    QPushButton *funcHoverButt;
    QToolBox *toolBox;
    QWidget *Position;
    QFormLayout *formLayout;
    QLabel *label;
    QSpinBox *spinBox_4;
    QLabel *label_2;
    QSpinBox *spinBox_5;
    QLabel *label_3;
    QSpinBox *spinBox_6;
    QWidget *Rotation;
    QGridLayout *gridLayout;
    QLabel *label_5;
    QLineEdit *lineEdit_5;
    QLineEdit *lineEdit_6;
    QSlider *verticalSlider_3;
    QLineEdit *lineEdit_4;
    QLabel *label_6;
    QSlider *verticalSlider_2;
    QLabel *label_4;
    QSlider *verticalSlider;
    QWidget *Color;
    QVBoxLayout *verticalLayout_8;
    QHBoxLayout *horizontalLayout_8;
    QSpacerItem *horizontalSpacer_11;
    QFormLayout *formLayout_2;
    QLabel *label_7;
    QSpinBox *spinBox_2;
    QLabel *label_9;
    QSpinBox *spinBox_3;
    QSpinBox *spinBox;
    QLabel *label_8;
    QSpacerItem *horizontalSpacer_10;
    QHBoxLayout *horizontalLayout_6;
    QSpacerItem *horizontalSpacer_8;
    QPushButton *Confirm;
    QSpacerItem *horizontalSpacer_9;
    QWidget *textures;
    QVBoxLayout *verticalLayout_5;
    QHBoxLayout *horizontalLayout_5;
    QSpacerItem *horizontalSpacer_6;
    objectLabel *widget_2;
    QSpacerItem *horizontalSpacer_7;
    QLineEdit *lineEdit_7;
    QHBoxLayout *horizontalLayout_3;
    QSpacerItem *horizontalSpacer_5;
    QPushButton *pushButton_3;
    QSpacerItem *horizontalSpacer_4;
    QWidget *Shaders;
    QHBoxLayout *horizontalLayout_4;
    QToolButton *toolButton;
    TreeWidget *treeDock;
    QWidget *treeWid;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_7;
    QPushButton *treeHoverButt;
    QSpacerItem *horizontalSpacer;
    myButton *pushButton;
    QTreeWidget *treeWidget;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->setWindowModality(Qt::WindowModal);
        MainWindow->resize(650, 400);
        MainWindow->setMinimumSize(QSize(650, 400));
        actionNew = new QAction(MainWindow);
        actionNew->setObjectName(QString::fromUtf8("actionNew"));
        actionNew->setIconVisibleInMenu(true);
        actionOpen = new QAction(MainWindow);
        actionOpen->setObjectName(QString::fromUtf8("actionOpen"));
        actionOpen->setIconVisibleInMenu(true);
        actionSave = new QAction(MainWindow);
        actionSave->setObjectName(QString::fromUtf8("actionSave"));
        actionSave->setIconVisibleInMenu(true);
        actionExit = new QAction(MainWindow);
        actionExit->setObjectName(QString::fromUtf8("actionExit"));
        actionExit->setIconVisibleInMenu(true);
        actionScene_tree = new QAction(MainWindow);
        actionScene_tree->setObjectName(QString::fromUtf8("actionScene_tree"));
        actionScene_tree->setCheckable(true);
        actionScene_tree->setChecked(true);
        actionFunctions = new QAction(MainWindow);
        actionFunctions->setObjectName(QString::fromUtf8("actionFunctions"));
        actionFunctions->setCheckable(true);
        actionFunctions->setChecked(true);
        actionTextures = new QAction(MainWindow);
        actionTextures->setObjectName(QString::fromUtf8("actionTextures"));
        actionTextures->setCheckable(true);
        actionTextures->setChecked(false);
        actionShaders = new QAction(MainWindow);
        actionShaders->setObjectName(QString::fromUtf8("actionShaders"));
        actionShaders->setCheckable(true);
        actionShaders->setChecked(false);
        actionDepth_setting = new QAction(MainWindow);
        actionDepth_setting->setObjectName(QString::fromUtf8("actionDepth_setting"));
        actionAbout = new QAction(MainWindow);
        actionAbout->setObjectName(QString::fromUtf8("actionAbout"));
        actionShortcuts = new QAction(MainWindow);
        actionShortcuts->setObjectName(QString::fromUtf8("actionShortcuts"));
        actionUndo = new QAction(MainWindow);
        actionUndo->setObjectName(QString::fromUtf8("actionUndo"));
        actionRedo = new QAction(MainWindow);
        actionRedo->setObjectName(QString::fromUtf8("actionRedo"));
        actionObjects = new QAction(MainWindow);
        actionObjects->setObjectName(QString::fromUtf8("actionObjects"));
        actionObjects->setCheckable(true);
        actionObjects->setChecked(true);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        QSizePolicy sizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(centralwidget->sizePolicy().hasHeightForWidth());
        centralwidget->setSizePolicy(sizePolicy);
        verticalLayout_4 = new QVBoxLayout(centralwidget);
        verticalLayout_4->setSpacing(2);
        verticalLayout_4->setObjectName(QString::fromUtf8("verticalLayout_4"));
        verticalLayout_4->setContentsMargins(2, 2, 2, 9);
        widget = new osgWidget(centralwidget);
        widget->setObjectName(QString::fromUtf8("widget"));
        sizePolicy.setHeightForWidth(widget->sizePolicy().hasHeightForWidth());
        widget->setSizePolicy(sizePolicy);
        widget->setMinimumSize(QSize(100, 0));
        widget->setMouseTracking(true);
        widget->setFocusPolicy(Qt::ClickFocus);
        widget->setAcceptDrops(true);
        verticalLayout_3 = new QVBoxLayout(widget);
        verticalLayout_3->setObjectName(QString::fromUtf8("verticalLayout_3"));
        horizontalSpacer_2 = new QSpacerItem(258, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        verticalLayout_3->addItem(horizontalSpacer_2);

        verticalSpacer = new QSpacerItem(20, 40, QSizePolicy::Minimum, QSizePolicy::Expanding);

        verticalLayout_3->addItem(verticalSpacer);


        verticalLayout_4->addWidget(widget);

        objectFrame = new objectWidget(centralwidget);
        objectFrame->setObjectName(QString::fromUtf8("objectFrame"));
        objectFrame->setMaximumSize(QSize(16777215, 70));
        horizontalLayout_2 = new QHBoxLayout(objectFrame);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        cube = new objectLabel(objectFrame);
        cube->setObjectName(QString::fromUtf8("cube"));
        cube->setMaximumSize(QSize(50, 50));

        horizontalLayout_2->addWidget(cube);

        sphere = new objectLabel(objectFrame);
        sphere->setObjectName(QString::fromUtf8("sphere"));
        sphere->setMaximumSize(QSize(50, 50));

        horizontalLayout_2->addWidget(sphere);

        pyramid = new objectLabel(objectFrame);
        pyramid->setObjectName(QString::fromUtf8("pyramid"));
        pyramid->setMaximumSize(QSize(50, 50));

        horizontalLayout_2->addWidget(pyramid);

        light = new objectLabel(objectFrame);
        light->setObjectName(QString::fromUtf8("light"));
        light->setMaximumSize(QSize(50, 50));

        horizontalLayout_2->addWidget(light);

        add = new QWidget(objectFrame);
        add->setObjectName(QString::fromUtf8("add"));
        add->setMaximumSize(QSize(50, 50));
        horizontalLayout = new QHBoxLayout(add);
        horizontalLayout->setSpacing(0);
        horizontalLayout->setContentsMargins(0, 0, 0, 0);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        addButt = new QPushButton(add);
        addButt->setObjectName(QString::fromUtf8("addButt"));
        addButt->setMinimumSize(QSize(50, 50));
        addButt->setMaximumSize(QSize(50, 50));
        addButt->setIconSize(QSize(50, 50));

        horizontalLayout->addWidget(addButt);


        horizontalLayout_2->addWidget(add);

        doRender = new QWidget(objectFrame);
        doRender->setObjectName(QString::fromUtf8("doRender"));
        doRender->setMinimumSize(QSize(50, 50));
        doRender->setMaximumSize(QSize(50, 50));
        horizontalLayout_10 = new QHBoxLayout(doRender);
        horizontalLayout_10->setSpacing(0);
        horizontalLayout_10->setContentsMargins(0, 0, 0, 0);
        horizontalLayout_10->setObjectName(QString::fromUtf8("horizontalLayout_10"));
        doIt = new QPushButton(doRender);
        doIt->setObjectName(QString::fromUtf8("doIt"));
        doIt->setMinimumSize(QSize(50, 50));
        doIt->setMaximumSize(QSize(50, 50));

        horizontalLayout_10->addWidget(doIt);


        horizontalLayout_2->addWidget(doRender);


        verticalLayout_4->addWidget(objectFrame);

        MainWindow->setCentralWidget(centralwidget);
        objectFrame->raise();
        widget->raise();
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 650, 23));
        menuFile = new QMenu(menubar);
        menuFile->setObjectName(QString::fromUtf8("menuFile"));
        menuView = new QMenu(menubar);
        menuView->setObjectName(QString::fromUtf8("menuView"));
        menuAdvanced = new QMenu(menubar);
        menuAdvanced->setObjectName(QString::fromUtf8("menuAdvanced"));
        menuRaytracer = new QMenu(menubar);
        menuRaytracer->setObjectName(QString::fromUtf8("menuRaytracer"));
        menuHelp = new QMenu(menubar);
        menuHelp->setObjectName(QString::fromUtf8("menuHelp"));
        menuEdit = new QMenu(menubar);
        menuEdit->setObjectName(QString::fromUtf8("menuEdit"));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        statusbar->setMaximumSize(QSize(16777215, 10));
        MainWindow->setStatusBar(statusbar);
        functionDock = new TreeWidget(MainWindow);
        functionDock->setObjectName(QString::fromUtf8("functionDock"));
        functionDock->setMinimumSize(QSize(152, 308));
        functionDock->setFeatures(QDockWidget::DockWidgetMovable);
        functionDock->setAllowedAreas(Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea);
        funcWid = new QWidget();
        funcWid->setObjectName(QString::fromUtf8("funcWid"));
        verticalLayout = new QVBoxLayout(funcWid);
        verticalLayout->setSpacing(5);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setContentsMargins(0, 0, 0, 9);
        horizontalLayout_9 = new QHBoxLayout();
        horizontalLayout_9->setObjectName(QString::fromUtf8("horizontalLayout_9"));
        pushButton_2 = new myButton(funcWid);
        pushButton_2->setObjectName(QString::fromUtf8("pushButton_2"));
        pushButton_2->setMinimumSize(QSize(16, 16));
        pushButton_2->setMaximumSize(QSize(16, 16));

        horizontalLayout_9->addWidget(pushButton_2);

        horizontalSpacer_3 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_9->addItem(horizontalSpacer_3);

        funcHoverButt = new QPushButton(funcWid);
        funcHoverButt->setObjectName(QString::fromUtf8("funcHoverButt"));
        funcHoverButt->setMaximumSize(QSize(16, 16));
        QIcon icon;
        icon.addFile(QString::fromUtf8(":/icons/point_off.png"), QSize(), QIcon::Normal, QIcon::Off);
        icon.addFile(QString::fromUtf8(":/icons/point_on.png"), QSize(), QIcon::Normal, QIcon::On);
        funcHoverButt->setIcon(icon);
        funcHoverButt->setCheckable(true);

        horizontalLayout_9->addWidget(funcHoverButt);


        verticalLayout->addLayout(horizontalLayout_9);

        toolBox = new QToolBox(funcWid);
        toolBox->setObjectName(QString::fromUtf8("toolBox"));
        Position = new QWidget();
        Position->setObjectName(QString::fromUtf8("Position"));
        Position->setGeometry(QRect(0, 0, 152, 151));
        formLayout = new QFormLayout(Position);
        formLayout->setObjectName(QString::fromUtf8("formLayout"));
        formLayout->setFieldGrowthPolicy(QFormLayout::AllNonFixedFieldsGrow);
        label = new QLabel(Position);
        label->setObjectName(QString::fromUtf8("label"));

        formLayout->setWidget(0, QFormLayout::LabelRole, label);

        spinBox_4 = new QSpinBox(Position);
        spinBox_4->setObjectName(QString::fromUtf8("spinBox_4"));
        spinBox_4->setMaximumSize(QSize(80, 16777215));

        formLayout->setWidget(0, QFormLayout::FieldRole, spinBox_4);

        label_2 = new QLabel(Position);
        label_2->setObjectName(QString::fromUtf8("label_2"));

        formLayout->setWidget(2, QFormLayout::LabelRole, label_2);

        spinBox_5 = new QSpinBox(Position);
        spinBox_5->setObjectName(QString::fromUtf8("spinBox_5"));
        spinBox_5->setMaximumSize(QSize(80, 16777215));

        formLayout->setWidget(2, QFormLayout::FieldRole, spinBox_5);

        label_3 = new QLabel(Position);
        label_3->setObjectName(QString::fromUtf8("label_3"));

        formLayout->setWidget(3, QFormLayout::LabelRole, label_3);

        spinBox_6 = new QSpinBox(Position);
        spinBox_6->setObjectName(QString::fromUtf8("spinBox_6"));
        spinBox_6->setMaximumSize(QSize(80, 16777215));

        formLayout->setWidget(3, QFormLayout::FieldRole, spinBox_6);

        toolBox->addItem(Position, QString::fromUtf8("Position"));
        Rotation = new QWidget();
        Rotation->setObjectName(QString::fromUtf8("Rotation"));
        Rotation->setGeometry(QRect(0, 0, 152, 151));
        gridLayout = new QGridLayout(Rotation);
        gridLayout->setObjectName(QString::fromUtf8("gridLayout"));
        label_5 = new QLabel(Rotation);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setAlignment(Qt::AlignCenter);

        gridLayout->addWidget(label_5, 0, 2, 1, 1);

        lineEdit_5 = new QLineEdit(Rotation);
        lineEdit_5->setObjectName(QString::fromUtf8("lineEdit_5"));

        gridLayout->addWidget(lineEdit_5, 2, 2, 1, 1);

        lineEdit_6 = new QLineEdit(Rotation);
        lineEdit_6->setObjectName(QString::fromUtf8("lineEdit_6"));

        gridLayout->addWidget(lineEdit_6, 2, 4, 1, 1);

        verticalSlider_3 = new QSlider(Rotation);
        verticalSlider_3->setObjectName(QString::fromUtf8("verticalSlider_3"));
        verticalSlider_3->setMaximum(360);
        verticalSlider_3->setPageStep(1);
        verticalSlider_3->setOrientation(Qt::Vertical);
        verticalSlider_3->setInvertedAppearance(false);
        verticalSlider_3->setInvertedControls(false);

        gridLayout->addWidget(verticalSlider_3, 1, 4, 1, 1);

        lineEdit_4 = new QLineEdit(Rotation);
        lineEdit_4->setObjectName(QString::fromUtf8("lineEdit_4"));

        gridLayout->addWidget(lineEdit_4, 2, 1, 1, 1);

        label_6 = new QLabel(Rotation);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setAlignment(Qt::AlignCenter);

        gridLayout->addWidget(label_6, 0, 4, 1, 1);

        verticalSlider_2 = new QSlider(Rotation);
        verticalSlider_2->setObjectName(QString::fromUtf8("verticalSlider_2"));
        verticalSlider_2->setMaximum(360);
        verticalSlider_2->setPageStep(1);
        verticalSlider_2->setOrientation(Qt::Vertical);

        gridLayout->addWidget(verticalSlider_2, 1, 2, 1, 1);

        label_4 = new QLabel(Rotation);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setAlignment(Qt::AlignCenter);

        gridLayout->addWidget(label_4, 0, 1, 1, 1);

        verticalSlider = new QSlider(Rotation);
        verticalSlider->setObjectName(QString::fromUtf8("verticalSlider"));
        verticalSlider->setMaximum(360);
        verticalSlider->setPageStep(1);
        verticalSlider->setOrientation(Qt::Vertical);

        gridLayout->addWidget(verticalSlider, 1, 1, 1, 1);

        toolBox->addItem(Rotation, QString::fromUtf8("Rotation"));
        Color = new QWidget();
        Color->setObjectName(QString::fromUtf8("Color"));
        Color->setGeometry(QRect(0, 0, 136, 156));
        verticalLayout_8 = new QVBoxLayout(Color);
        verticalLayout_8->setObjectName(QString::fromUtf8("verticalLayout_8"));
        horizontalLayout_8 = new QHBoxLayout();
        horizontalLayout_8->setObjectName(QString::fromUtf8("horizontalLayout_8"));
        horizontalSpacer_11 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_8->addItem(horizontalSpacer_11);

        formLayout_2 = new QFormLayout();
        formLayout_2->setObjectName(QString::fromUtf8("formLayout_2"));
        formLayout_2->setFieldGrowthPolicy(QFormLayout::AllNonFixedFieldsGrow);
        label_7 = new QLabel(Color);
        label_7->setObjectName(QString::fromUtf8("label_7"));

        formLayout_2->setWidget(0, QFormLayout::LabelRole, label_7);

        spinBox_2 = new QSpinBox(Color);
        spinBox_2->setObjectName(QString::fromUtf8("spinBox_2"));
        spinBox_2->setMaximumSize(QSize(80, 16777215));
        spinBox_2->setMaximum(255);

        formLayout_2->setWidget(0, QFormLayout::FieldRole, spinBox_2);

        label_9 = new QLabel(Color);
        label_9->setObjectName(QString::fromUtf8("label_9"));

        formLayout_2->setWidget(2, QFormLayout::LabelRole, label_9);

        spinBox_3 = new QSpinBox(Color);
        spinBox_3->setObjectName(QString::fromUtf8("spinBox_3"));
        spinBox_3->setMaximumSize(QSize(80, 16777215));
        spinBox_3->setMaximum(255);

        formLayout_2->setWidget(2, QFormLayout::FieldRole, spinBox_3);

        spinBox = new QSpinBox(Color);
        spinBox->setObjectName(QString::fromUtf8("spinBox"));
        spinBox->setMaximumSize(QSize(80, 16777215));
        spinBox->setMaximum(255);

        formLayout_2->setWidget(1, QFormLayout::FieldRole, spinBox);

        label_8 = new QLabel(Color);
        label_8->setObjectName(QString::fromUtf8("label_8"));

        formLayout_2->setWidget(1, QFormLayout::LabelRole, label_8);


        horizontalLayout_8->addLayout(formLayout_2);

        horizontalSpacer_10 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_8->addItem(horizontalSpacer_10);


        verticalLayout_8->addLayout(horizontalLayout_8);

        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setObjectName(QString::fromUtf8("horizontalLayout_6"));
        horizontalSpacer_8 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_6->addItem(horizontalSpacer_8);

        Confirm = new QPushButton(Color);
        Confirm->setObjectName(QString::fromUtf8("Confirm"));
        Confirm->setMaximumSize(QSize(100, 16777215));

        horizontalLayout_6->addWidget(Confirm);

        horizontalSpacer_9 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_6->addItem(horizontalSpacer_9);


        verticalLayout_8->addLayout(horizontalLayout_6);

        toolBox->addItem(Color, QString::fromUtf8("Color"));
        textures = new QWidget();
        textures->setObjectName(QString::fromUtf8("textures"));
        textures->setGeometry(QRect(0, 0, 152, 151));
        verticalLayout_5 = new QVBoxLayout(textures);
        verticalLayout_5->setObjectName(QString::fromUtf8("verticalLayout_5"));
        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setObjectName(QString::fromUtf8("horizontalLayout_5"));
        horizontalSpacer_6 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer_6);

        widget_2 = new objectLabel(textures);
        widget_2->setObjectName(QString::fromUtf8("widget_2"));

        horizontalLayout_5->addWidget(widget_2);

        horizontalSpacer_7 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer_7);


        verticalLayout_5->addLayout(horizontalLayout_5);

        lineEdit_7 = new QLineEdit(textures);
        lineEdit_7->setObjectName(QString::fromUtf8("lineEdit_7"));
        lineEdit_7->setReadOnly(true);

        verticalLayout_5->addWidget(lineEdit_7);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setObjectName(QString::fromUtf8("horizontalLayout_3"));
        horizontalSpacer_5 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_5);

        pushButton_3 = new QPushButton(textures);
        pushButton_3->setObjectName(QString::fromUtf8("pushButton_3"));
        pushButton_3->setMaximumSize(QSize(100, 16777215));

        horizontalLayout_3->addWidget(pushButton_3);

        horizontalSpacer_4 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_4);


        verticalLayout_5->addLayout(horizontalLayout_3);

        toolBox->addItem(textures, QString::fromUtf8("Textures"));
        Shaders = new QWidget();
        Shaders->setObjectName(QString::fromUtf8("Shaders"));
        Shaders->setGeometry(QRect(0, 0, 152, 151));
        horizontalLayout_4 = new QHBoxLayout(Shaders);
        horizontalLayout_4->setObjectName(QString::fromUtf8("horizontalLayout_4"));
        toolButton = new QToolButton(Shaders);
        toolButton->setObjectName(QString::fromUtf8("toolButton"));

        horizontalLayout_4->addWidget(toolButton);

        toolBox->addItem(Shaders, QString::fromUtf8("Shaders"));

        verticalLayout->addWidget(toolBox);

        functionDock->setWidget(funcWid);
        toolBox->raise();
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(2), functionDock);
        treeDock = new TreeWidget(MainWindow);
        treeDock->setObjectName(QString::fromUtf8("treeDock"));
        treeDock->setMinimumSize(QSize(110, 148));
        treeDock->setFeatures(QDockWidget::DockWidgetMovable);
        treeDock->setAllowedAreas(Qt::LeftDockWidgetArea|Qt::RightDockWidgetArea);
        treeWid = new QWidget();
        treeWid->setObjectName(QString::fromUtf8("treeWid"));
        verticalLayout_2 = new QVBoxLayout(treeWid);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout_2->setContentsMargins(0, 0, 0, -1);
        horizontalLayout_7 = new QHBoxLayout();
        horizontalLayout_7->setObjectName(QString::fromUtf8("horizontalLayout_7"));
        treeHoverButt = new QPushButton(treeWid);
        treeHoverButt->setObjectName(QString::fromUtf8("treeHoverButt"));
        treeHoverButt->setMaximumSize(QSize(16, 16));
        treeHoverButt->setIcon(icon);
        treeHoverButt->setCheckable(true);

        horizontalLayout_7->addWidget(treeHoverButt);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_7->addItem(horizontalSpacer);

        pushButton = new myButton(treeWid);
        pushButton->setObjectName(QString::fromUtf8("pushButton"));
        pushButton->setMinimumSize(QSize(16, 16));
        pushButton->setMaximumSize(QSize(16, 16));

        horizontalLayout_7->addWidget(pushButton);


        verticalLayout_2->addLayout(horizontalLayout_7);

        treeWidget = new QTreeWidget(treeWid);
        treeWidget->setObjectName(QString::fromUtf8("treeWidget"));
        treeWidget->setFocusPolicy(Qt::NoFocus);
        treeWidget->setFrameShape(QFrame::WinPanel);
        treeWidget->setFrameShadow(QFrame::Sunken);
        treeWidget->setLineWidth(0);
        treeWidget->setAutoScroll(true);
        treeWidget->setProperty("showDropIndicator", QVariant(true));
        treeWidget->setAutoExpandDelay(0);
        treeWidget->setIndentation(20);
        treeWidget->setRootIsDecorated(true);
        treeWidget->setItemsExpandable(true);
        treeWidget->setExpandsOnDoubleClick(true);
        treeWidget->setColumnCount(0);

        verticalLayout_2->addWidget(treeWidget);

        treeDock->setWidget(treeWid);
        MainWindow->addDockWidget(static_cast<Qt::DockWidgetArea>(1), treeDock);

        menubar->addAction(menuFile->menuAction());
        menubar->addAction(menuEdit->menuAction());
        menubar->addAction(menuView->menuAction());
        menubar->addAction(menuAdvanced->menuAction());
        menubar->addAction(menuRaytracer->menuAction());
        menubar->addAction(menuHelp->menuAction());
        menuFile->addAction(actionNew);
        menuFile->addSeparator();
        menuFile->addAction(actionOpen);
        menuFile->addAction(actionSave);
        menuFile->addAction(actionExit);
        menuView->addAction(actionScene_tree);
        menuView->addAction(actionFunctions);
        menuView->addAction(actionObjects);
        menuAdvanced->addAction(actionTextures);
        menuAdvanced->addAction(actionShaders);
        menuAdvanced->addAction(actionShortcuts);
        menuRaytracer->addAction(actionDepth_setting);
        menuHelp->addAction(actionAbout);
        menuEdit->addAction(actionUndo);
        menuEdit->addAction(actionRedo);

        retranslateUi(MainWindow);
        QObject::connect(actionObjects, SIGNAL(toggled(bool)), objectFrame, SLOT(setVisible(bool)));

        toolBox->setCurrentIndex(2);


        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "MainWindow", 0, QApplication::UnicodeUTF8));
        actionNew->setText(QApplication::translate("MainWindow", "New", 0, QApplication::UnicodeUTF8));
        actionOpen->setText(QApplication::translate("MainWindow", "Open", 0, QApplication::UnicodeUTF8));
        actionSave->setText(QApplication::translate("MainWindow", "Save", 0, QApplication::UnicodeUTF8));
        actionExit->setText(QApplication::translate("MainWindow", "Exit", 0, QApplication::UnicodeUTF8));
        actionScene_tree->setText(QApplication::translate("MainWindow", "Scene tree", 0, QApplication::UnicodeUTF8));
        actionFunctions->setText(QApplication::translate("MainWindow", "Functions", 0, QApplication::UnicodeUTF8));
        actionTextures->setText(QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
        actionShaders->setText(QApplication::translate("MainWindow", "Shaders", 0, QApplication::UnicodeUTF8));
        actionDepth_setting->setText(QApplication::translate("MainWindow", "Depth setting", 0, QApplication::UnicodeUTF8));
        actionAbout->setText(QApplication::translate("MainWindow", "About", 0, QApplication::UnicodeUTF8));
        actionShortcuts->setText(QApplication::translate("MainWindow", "Shortcuts", 0, QApplication::UnicodeUTF8));
        actionUndo->setText(QApplication::translate("MainWindow", "Undo", 0, QApplication::UnicodeUTF8));
        actionRedo->setText(QApplication::translate("MainWindow", "Redo", 0, QApplication::UnicodeUTF8));
        actionObjects->setText(QApplication::translate("MainWindow", "Objects", 0, QApplication::UnicodeUTF8));
        addButt->setText(QString());
        doIt->setText(QApplication::translate("MainWindow", "Do It", 0, QApplication::UnicodeUTF8));
        menuFile->setTitle(QApplication::translate("MainWindow", "File", 0, QApplication::UnicodeUTF8));
        menuView->setTitle(QApplication::translate("MainWindow", "View", 0, QApplication::UnicodeUTF8));
        menuAdvanced->setTitle(QApplication::translate("MainWindow", "Advanced", 0, QApplication::UnicodeUTF8));
        menuRaytracer->setTitle(QApplication::translate("MainWindow", "Raytracer", 0, QApplication::UnicodeUTF8));
        menuHelp->setTitle(QApplication::translate("MainWindow", "Help", 0, QApplication::UnicodeUTF8));
        menuEdit->setTitle(QApplication::translate("MainWindow", "Edit", 0, QApplication::UnicodeUTF8));
        pushButton_2->setText(QString());
        funcHoverButt->setText(QString());
        label->setText(QApplication::translate("MainWindow", "X", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("MainWindow", "Y", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("MainWindow", "Z", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(Position), QApplication::translate("MainWindow", "Position", 0, QApplication::UnicodeUTF8));
        label_5->setText(QApplication::translate("MainWindow", "Y", 0, QApplication::UnicodeUTF8));
        label_6->setText(QApplication::translate("MainWindow", "Z", 0, QApplication::UnicodeUTF8));
        label_4->setText(QApplication::translate("MainWindow", "X", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(Rotation), QApplication::translate("MainWindow", "Rotation", 0, QApplication::UnicodeUTF8));
        label_7->setText(QApplication::translate("MainWindow", "Red", 0, QApplication::UnicodeUTF8));
        label_9->setText(QApplication::translate("MainWindow", "Blue", 0, QApplication::UnicodeUTF8));
        label_8->setText(QApplication::translate("MainWindow", "Green", 0, QApplication::UnicodeUTF8));
        Confirm->setText(QApplication::translate("MainWindow", "Confirm", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(Color), QApplication::translate("MainWindow", "Color", 0, QApplication::UnicodeUTF8));
        pushButton_3->setText(QApplication::translate("MainWindow", "Browse", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(textures), QApplication::translate("MainWindow", "Textures", 0, QApplication::UnicodeUTF8));
        toolButton->setText(QApplication::translate("MainWindow", "...", 0, QApplication::UnicodeUTF8));
        toolBox->setItemText(toolBox->indexOf(Shaders), QApplication::translate("MainWindow", "Shaders", 0, QApplication::UnicodeUTF8));
        treeHoverButt->setText(QString());
        pushButton->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MENU_H
