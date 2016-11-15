#ifndef OBJECTWIDGET_H
#define OBJECTWIDGET_H

#include <QWidget>
#include <QLabel>
#include <QFrame>

QT_BEGIN_NAMESPACE
class QDragEnterEvent;
class QDropEvent;
QT_END_NAMESPACE

class objectWidget : public QFrame
{
    Q_OBJECT
public:
    explicit objectWidget(QWidget *parent = 0);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
  //  void dropEvent(QDropEvent *event);
    void mousePressEvent(QMouseEvent *event);

signals:
    
public slots:
    
};

#endif // OBJECTWIDGET_H
