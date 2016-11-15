#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();
    void init();
    void saveFile();
    void openFile();

    QString fileName,fileToSave;
    QString newShort,openShort,saveShort,exitShort;

    int depth;

protected:
    void changeEvent(QEvent *e);

private:
    Ui::MainWindow *ui;

private slots:
    void openNew();
    void open();
    void save();
    void exit();
    void openHelp();
    void setDepth(int value);
    void openDepthSetting();
    void openShortcutsSetting();
    void setShorcut(int action, QString shortcut);
    void setNumber(int);
    void setNumber_2(int);
    void setNumber_3(int);
    void setFileName(QString name);


signals:
    void render(QString fileToRender);
    void toSave(QString fileToSave);
    void created();
    void deleteTree();
    void deleteFromTree(QString);
    void sendString(QString);
    void sendString_2(QString);
    void sendString_3(QString);
};

#endif // MAINWINDOW_H
