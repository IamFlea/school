#ifndef OBJECTLABEL_H
#define OBJECTLABEL_H

#include <QWidget>
#include <QLabel>


class objectLabel : public QLabel
{
    Q_OBJECT
public:
    explicit objectLabel(QWidget *parent = 0);
    void setObject(QString file);
    
signals:
    
public slots:
    void setFile(QString);
};

#endif // OBJECTLABEL_H
