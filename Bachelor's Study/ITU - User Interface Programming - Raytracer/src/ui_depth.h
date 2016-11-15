/********************************************************************************
** Form generated from reading UI file 'depth.ui'
**
** Created: Wed Dec 5 12:30:52 2012
**      by: Qt User Interface Compiler version 4.6.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DEPTH_H
#define UI_DEPTH_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLineEdit>
#include <QtGui/QPushButton>
#include <QtGui/QSlider>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_depthWindow
{
public:
    QVBoxLayout *verticalLayout_2;
    QVBoxLayout *verticalLayout;
    QSlider *horizontalSlider;
    QHBoxLayout *horizontalLayout;
    QLineEdit *lineEdit;
    QHBoxLayout *horizontalLayout_2;
    QPushButton *okButt;
    QPushButton *canceButt;

    void setupUi(QWidget *depthWindow)
    {
        if (depthWindow->objectName().isEmpty())
            depthWindow->setObjectName(QString::fromUtf8("depthWindow"));
        depthWindow->resize(301, 125);
        depthWindow->setMinimumSize(QSize(301, 125));
        depthWindow->setMaximumSize(QSize(2000, 2000));
        verticalLayout_2 = new QVBoxLayout(depthWindow);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalSlider = new QSlider(depthWindow);
        horizontalSlider->setObjectName(QString::fromUtf8("horizontalSlider"));
        horizontalSlider->setMinimumSize(QSize(0, 25));
        horizontalSlider->setMaximumSize(QSize(16777215, 20));
        horizontalSlider->setMinimum(1);
        horizontalSlider->setOrientation(Qt::Horizontal);

        verticalLayout->addWidget(horizontalSlider);

        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        lineEdit = new QLineEdit(depthWindow);
        lineEdit->setObjectName(QString::fromUtf8("lineEdit"));
        QSizePolicy sizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(lineEdit->sizePolicy().hasHeightForWidth());
        lineEdit->setSizePolicy(sizePolicy);
        lineEdit->setMinimumSize(QSize(100, 30));
        lineEdit->setMaximumSize(QSize(100, 30));
        lineEdit->setMaxLength(3);
        lineEdit->setAlignment(Qt::AlignCenter);
        lineEdit->setReadOnly(true);

        horizontalLayout->addWidget(lineEdit);


        verticalLayout->addLayout(horizontalLayout);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        okButt = new QPushButton(depthWindow);
        okButt->setObjectName(QString::fromUtf8("okButt"));
        okButt->setMinimumSize(QSize(60, 30));
        okButt->setMaximumSize(QSize(60, 30));

        horizontalLayout_2->addWidget(okButt);

        canceButt = new QPushButton(depthWindow);
        canceButt->setObjectName(QString::fromUtf8("canceButt"));
        canceButt->setMinimumSize(QSize(60, 30));
        canceButt->setMaximumSize(QSize(60, 30));

        horizontalLayout_2->addWidget(canceButt);


        verticalLayout->addLayout(horizontalLayout_2);


        verticalLayout_2->addLayout(verticalLayout);


        retranslateUi(depthWindow);

        QMetaObject::connectSlotsByName(depthWindow);
    } // setupUi

    void retranslateUi(QWidget *depthWindow)
    {
        depthWindow->setWindowTitle(QApplication::translate("depthWindow", "Form", 0, QApplication::UnicodeUTF8));
        okButt->setText(QApplication::translate("depthWindow", "OK", 0, QApplication::UnicodeUTF8));
        canceButt->setText(QApplication::translate("depthWindow", "Cancel", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class depthWindow: public Ui_depthWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DEPTH_H
