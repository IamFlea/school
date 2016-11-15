#include "mainwindow.h"
#include "depthsetting.h"
#include "shorcutssetting.h"
#include "treewidget.h"
#include "mybutton.h"
#include "ui_menu.h"
#include <QFileDialog>
#include <iostream>
#include <QLabel>
#include <QPicture>
#include <QKeySequence>
#include <QPixmap>
#include <QPainter>
#include <QIcon>
#include <QMessageBox>
#include <QPushButton>

#define DEFAULT_DEPTH 10

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    init();

    connect(ui->actionNew,SIGNAL(activated()),this,SLOT(openNew()));
    connect(ui->actionOpen,SIGNAL(activated()),this,SLOT(open()));
    connect(ui->actionSave,SIGNAL(activated()),this,SLOT(save()));
    connect(ui->actionExit,SIGNAL(activated()),this,SLOT(exit()));
    connect(ui->actionScene_tree,SIGNAL(triggered(bool)),ui->treeDock,SLOT(setVisible(bool)));
    connect(ui->actionFunctions,SIGNAL(triggered(bool)),ui->functionDock,SLOT(setVisible(bool)));

    connect(ui->actionDepth_setting, SIGNAL( activated() ), this, SLOT ( openDepthSetting() ) );
    connect(ui->actionShortcuts, SIGNAL( activated() ), this, SLOT ( openShortcutsSetting() ) );
    connect(ui->actionAbout,SIGNAL(activated()),this,SLOT(openHelp()));
    connect(this,SIGNAL(render(QString)),ui->widget,SLOT(runViewer(QString)));
    connect(this,SIGNAL(toSave(QString)),ui->widget,SLOT(saveFile(QString)));
    connect(ui->widget,SIGNAL(addToTree(QString)),ui->treeDock,SLOT(addObject(QString)));

    connect(ui->pushButton, SIGNAL(clicked()), ui->treeDock, SLOT(hideMe()));
    connect(ui->treeDock, SIGNAL(hideYou()), ui->treeWidget, SLOT(hide()));
    connect(ui->treeDock, SIGNAL(showYou()), ui->treeWidget, SLOT(show()));
    connect(ui->treeDock, SIGNAL(changeArrow(QString)), ui->pushButton, SLOT(changeIcon(QString)));
    connect(ui->treeDock, SIGNAL(dockLocationChanged(Qt::DockWidgetArea)), ui->treeDock, SLOT(changeDock(Qt::DockWidgetArea)));

    connect(ui->treeHoverButt, SIGNAL(clicked()), ui->treeDock, SLOT(changeFixed()));
    connect(ui->treeDock, SIGNAL(hideYou()), ui->treeHoverButt, SLOT(hide()));	
    connect(ui->treeDock, SIGNAL(showYou()), ui->treeHoverButt, SLOT(show()));

    connect(ui->pushButton_2, SIGNAL(clicked()), ui->functionDock, SLOT(hideMe()));
    connect(ui->functionDock, SIGNAL(hideYou()), ui->toolBox, SLOT(hide()));
    connect(ui->functionDock, SIGNAL(showYou()), ui->toolBox, SLOT(show()));
    connect(ui->functionDock, SIGNAL(changeArrow(QString)), ui->pushButton_2, SLOT(changeIcon(QString)));
    connect(ui->functionDock, SIGNAL(dockLocationChanged(Qt::DockWidgetArea)), ui->functionDock, SLOT(changeDock(Qt::DockWidgetArea)));

    connect(ui->funcHoverButt, SIGNAL(clicked()), ui->functionDock, SLOT(changeFixed()));
    connect(ui->functionDock, SIGNAL(hideYou()), ui->funcHoverButt, SLOT(hide()));	
    connect(ui->functionDock, SIGNAL(showYou()), ui->funcHoverButt, SLOT(show()));

    connect(this,SIGNAL(created()),ui->treeDock,SLOT(initChildren()));
    connect(this,SIGNAL(created()),ui->functionDock,SLOT(initChildren()));
    connect(this,SIGNAL(deleteFromTree(QString)),ui->treeDock,SLOT(removeObject(QString)));
    connect(ui->widget,SIGNAL(deleteFromTree(QString)),ui->treeDock,SLOT(removeObject(QString)));
    connect(ui->treeDock,SIGNAL(deleteNode(QString)),ui->widget,SLOT(deleteNode(QString)));

    connect(ui->treeWidget,SIGNAL(itemDoubleClicked(QTreeWidgetItem*,int)),ui->treeDock,SLOT(deleteItem(QTreeWidgetItem*,int)));
    connect(ui->treeWidget,SIGNAL(itemClicked(QTreeWidgetItem*,int)),ui->functionDock,SLOT(getItemName(QTreeWidgetItem*,int)));

    connect(ui->verticalSlider,SIGNAL(sliderMoved(int)),this,SLOT(setNumber(int)));
    connect(this,SIGNAL(sendString(QString)),ui->lineEdit_4,SLOT(setText(QString)));
    connect(ui->verticalSlider_2,SIGNAL(sliderMoved(int)),this,SLOT(setNumber_2(int)));
    connect(this,SIGNAL(sendString_2(QString)),ui->lineEdit_5,SLOT(setText(QString)));
    connect(ui->verticalSlider_3,SIGNAL(sliderMoved(int)),this,SLOT(setNumber_3(int)));
    connect(this,SIGNAL(sendString_3(QString)),ui->lineEdit_6,SLOT(setText(QString)));
    connect(ui->pushButton_3,SIGNAL(clicked()),ui->treeDock,SLOT(myOpenFile()));
    connect(ui->treeDock,SIGNAL(setFileName(QString)),ui->lineEdit_7,SLOT(setText(QString)));
    connect(ui->treeDock,SIGNAL(setFileName(QString)),ui->widget_2,SLOT(setFile(QString)));

    connect(this,SIGNAL(deleteTree()),ui->treeDock,SLOT(deleteAll()));
    connect(ui->actionTextures,SIGNAL(toggled(bool)),ui->textures,SLOT(setEnabled(bool)));
    connect(ui->actionShaders,SIGNAL(toggled(bool)),ui->Shaders,SLOT(setEnabled(bool)));

    connect(ui->functionDock,SIGNAL(insertR(int)),ui->spinBox_2,SLOT(setValue(int)));
    connect(ui->functionDock,SIGNAL(insertG(int)),ui->spinBox,SLOT(setValue(int)));
    connect(ui->functionDock,SIGNAL(insertB(int)),ui->spinBox_3,SLOT(setValue(int)));

    ui->textures->setEnabled(false);
    ui->Shaders->setEnabled(false);

    connect(ui->spinBox_2,SIGNAL(valueChanged(int)),ui->functionDock,SLOT(setR(int)));
    connect(ui->spinBox,SIGNAL(valueChanged(int)),ui->functionDock,SLOT(setG(int)));
    connect(ui->spinBox_3,SIGNAL(valueChanged(int)),ui->functionDock,SLOT(setB(int)));

    connect(ui->Confirm,SIGNAL(clicked()),ui->functionDock,SLOT(getColor()));
    connect(ui->functionDock,SIGNAL(setNewColor(QString,int,int,int)),ui->widget,SLOT(setColor(QString,int,int,int)));
    connect(ui->widget,SIGNAL(deleteTree()),ui->treeDock,SLOT(deleteAll()));
    connect(this,SIGNAL(deleteTree()),ui->widget,SLOT(deleteScene()));
    connect(ui->doIt,SIGNAL(clicked()),ui->widget,SLOT(getResult()));
    connect(ui->widget,SIGNAL(openedFile(QString)),this,SLOT(setFileName(QString)));

    created();
    this->show();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::init()
{
    QIcon mainIcon,openIcon,saveIcon;
    QIcon newIcon,exitIcon,addIcon;

    depth = DEFAULT_DEPTH;

    mainIcon.addFile(QString(":/icons/mainIcon.png"));
    newIcon.addFile(QString(":/icons/newIcon.png"));
    openIcon.addFile(QString(":/icons/openIcon.png"));
    saveIcon.addFile(QString(":/icons/saveIcon.png"));
    exitIcon.addFile(QString(":/icons/exitIcon.png"));
    addIcon.addFile(QString(":/objects/add.png"));

    this->setWindowIcon(mainIcon);
    this->setWindowTitle(QString("Raytracer"));
    ui->actionSave->setEnabled(false);

    ui->actionNew->setIcon(newIcon);
    newShort = "CTRL+N";
    ui->actionNew->setShortcut(QKeySequence(newShort));
    ui->actionOpen->setIcon(openIcon);
    openShort = "CTRL+O";
    ui->actionOpen->setShortcut(QKeySequence(openShort));
    ui->actionSave->setIcon(saveIcon);
    saveShort = "CTRL+S";
    ui->actionSave->setShortcut(QKeySequence(saveShort));
    ui->actionExit->setIcon(exitIcon);
    exitShort = "CTRL+Q";
    ui->actionExit->setShortcut(QKeySequence(exitShort));
    ui->actionExit->setShortcut(QKeySequence(QString("ESC")));

    ui->cube->setObject(QString(":/objects/cube.png"));
    ui->light->setObject(QString(":/objects/light.png"));
    ui->pyramid->setObject(QString(":/objects/pyramid.png"));
    ui->sphere->setObject(QString(":/objects/sphere.png"));
    ui->addButt->setIcon(addIcon);
    ui->addButt->setIconSize(QSize(40,40));

}

void MainWindow::setFileName(QString name)
{
    fileName = name;
    ui->actionSave->setEnabled(true);
}

void MainWindow::open()
{
   if(fileName.isNull()){
       openFile();

   }else{
       QMessageBox msgBox;
       msgBox.setText("The document is opened.");
       msgBox.setInformativeText("Do you want to save your document?");
       msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Cancel);
       msgBox.setDefaultButton(QMessageBox::Save);
       int ret = msgBox.exec();

       switch (ret) {
         case QMessageBox::Save:
             saveFile();
             break;
         default:
             deleteTree();
             fileName.clear();
             break;
       }
       openFile();
   }
   this->update();
}

void MainWindow::openNew()
{
    if(!fileName.isNull()){
        QMessageBox msgBox;
        msgBox.setText("The document is opened.");
        msgBox.setInformativeText("Do you want to save your document?");
        msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Cancel);
        msgBox.setDefaultButton(QMessageBox::Save);
        int ret = msgBox.exec();

        switch (ret) {
          case QMessageBox::Save:
              saveFile();
              ui->actionSave->setEnabled(false);
              break;
          default:
              deleteTree();
              fileName.clear();
              break;
        }
    }else render(QString(NULL));
    this->update();
}

void MainWindow::save()
{
    if(!fileName.isNull()){
        ui->actionSave->setEnabled(false);
        saveFile();

    }else{
       QMessageBox::warning(this, tr("Saving file"),tr("No document to save.\n"),QMessageBox::Abort);
    }
}

void MainWindow::exit()
{
    if(!fileName.isNull()){
        QMessageBox msgBox;
        msgBox.setText("The document has been modified.");
        msgBox.setInformativeText("Do you want to save your changes?");
        msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Cancel);
        msgBox.setDefaultButton(QMessageBox::Save);
        int ret = msgBox.exec();

        switch (ret) {
          case QMessageBox::Save:
              ui->actionSave->setEnabled(false);
              saveFile();
              break;
          default:
              // Nothing to do just close window
              break;
        }
    }
    this->close();
}

void MainWindow::openHelp(){
    QMessageBox *box = new QMessageBox(this);
    box->setText(QString("Help"));
    box->setInformativeText(QString("We don't need no education.\n"));
    box->show();
}

void MainWindow::openFile()
{
    deleteTree();
    fileName = QFileDialog::getOpenFileName(this, tr("Open Raytracer File"),"",tr("File (*.osg *.osgt)"));

    if(!fileName.isNull()){
         ui->actionSave->setEnabled(true);
         render( fileName );

     }else{
        QMessageBox::warning(this, tr("Opening file"),tr("Cannot read file.\n"),QMessageBox::Abort);
    }
}

void MainWindow::saveFile()
{
    fileToSave = QFileDialog::getSaveFileName(this, tr("Save Raytracer File"),"",tr("File (*.osg)"));
    toSave(fileToSave);
}

void MainWindow::openDepthSetting()
{
    depthSetting *dialog = new depthSetting(this,depth);
    dialog->setWindowTitle(tr("Depth settings"));
    dialog->exec();
}

void MainWindow::openShortcutsSetting()
{
    shorcutssetting *dialog = new shorcutssetting(this);
    dialog->initShortcut(newAct, newShort);
    dialog->initShortcut(openAct, openShort);
    dialog->initShortcut(saveAct, saveShort);
    dialog->initShortcut(exitAct, exitShort);
    dialog->setWindowTitle(tr("Shortcuts settings"));
    dialog->exec();
}

void MainWindow::setDepth(int value)
{
    depth = value;
}

void MainWindow::setShorcut(int action, QString shortcut)
{
    switch(action)
    {
        case newAct:
            newShort = shortcut;
            ui->actionNew->setShortcut(QKeySequence(shortcut));
            break;
        case openAct:
            openShort = shortcut;
            ui->actionOpen->setShortcut(QKeySequence(shortcut));
            break;
        case saveAct:
            saveShort = shortcut;
            ui->actionSave->setShortcut(QKeySequence(shortcut));
            break;
        case exitAct:
            exitShort = shortcut;
            ui->actionExit->setShortcut(QKeySequence(shortcut));
            break;

        default:
            break;
    }
}

void MainWindow::changeEvent(QEvent *e)
{
    QMainWindow::changeEvent(e);
    switch (e->type()) {
    case QEvent::LanguageChange:
        ui->retranslateUi(this);
        break;
    default:
        break;
    }
}

void MainWindow::setNumber(int i)
{
    QString str;
    str.setNum(i);
    sendString(str);
}

void MainWindow::setNumber_2(int i)
{
    QString str;
    str.setNum(i);
    sendString_2(str);
}

void MainWindow::setNumber_3(int i)
{
    QString str;
    str.setNum(i);
    sendString_3(str);
}
