/********************************************************************************
** Form generated from reading UI file 'shotcuts.ui'
**
** Created: Wed Dec 5 18:32:01 2012
**      by: Qt User Interface Compiler version 4.6.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_SHOTCUTS_H
#define UI_SHOTCUTS_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QHBoxLayout>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QPushButton>
#include <QtGui/QScrollArea>
#include <QtGui/QVBoxLayout>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_shorcuts
{
public:
    QVBoxLayout *verticalLayout_2;
    QScrollArea *scrollArea;
    QWidget *scrollAreaWidgetContents;
    QHBoxLayout *horizontalLayout;
    QVBoxLayout *verticalLayout;
    QLabel *label;
    QLabel *label_2;
    QLabel *label_3;
    QLabel *label_4;
    QLabel *label_5;
    QLabel *label_6;
    QLabel *label_7;
    QLabel *label_8;
    QLabel *label_9;
    QVBoxLayout *verticalLayout_4;
    QLineEdit *newLine;
    QLineEdit *openLine;
    QLineEdit *saveLine;
    QLineEdit *exitLine;
    QLineEdit *cubeLine;
    QLineEdit *sphereLine;
    QLineEdit *pyramidLine;
    QLineEdit *lightLine;
    QLineEdit *addLine;
    QHBoxLayout *horizontalLayout_2;
    QPushButton *OkButt;
    QPushButton *CancelButt;

    void setupUi(QWidget *shorcuts)
    {
        if (shorcuts->objectName().isEmpty())
            shorcuts->setObjectName(QString::fromUtf8("shorcuts"));
        shorcuts->resize(300, 311);
        shorcuts->setMinimumSize(QSize(300, 311));
        shorcuts->setMaximumSize(QSize(300, 311));
        verticalLayout_2 = new QVBoxLayout(shorcuts);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        scrollArea = new QScrollArea(shorcuts);
        scrollArea->setObjectName(QString::fromUtf8("scrollArea"));
        scrollArea->setMinimumSize(QSize(280, 250));
        scrollArea->setMaximumSize(QSize(280, 250));
        scrollArea->setFrameShadow(QFrame::Sunken);
        scrollArea->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        scrollArea->setWidgetResizable(true);
        scrollAreaWidgetContents = new QWidget();
        scrollAreaWidgetContents->setObjectName(QString::fromUtf8("scrollAreaWidgetContents"));
        scrollAreaWidgetContents->setGeometry(QRect(0, 0, 262, 280));
        scrollAreaWidgetContents->setMinimumSize(QSize(253, 280));
        scrollAreaWidgetContents->setMaximumSize(QSize(265, 280));
        horizontalLayout = new QHBoxLayout(scrollAreaWidgetContents);
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setSpacing(0);
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        verticalLayout->setSizeConstraint(QLayout::SetDefaultConstraint);
        label = new QLabel(scrollAreaWidgetContents);
        label->setObjectName(QString::fromUtf8("label"));
        label->setMinimumSize(QSize(0, 0));
        label->setMaximumSize(QSize(16777215, 30));
        label->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label);

        label_2 = new QLabel(scrollAreaWidgetContents);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setMaximumSize(QSize(16777215, 30));
        label_2->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_2);

        label_3 = new QLabel(scrollAreaWidgetContents);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setMaximumSize(QSize(16777215, 30));
        label_3->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_3);

        label_4 = new QLabel(scrollAreaWidgetContents);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setMaximumSize(QSize(16777215, 30));
        label_4->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_4);

        label_5 = new QLabel(scrollAreaWidgetContents);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setMaximumSize(QSize(16777215, 30));
        label_5->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_5);

        label_6 = new QLabel(scrollAreaWidgetContents);
        label_6->setObjectName(QString::fromUtf8("label_6"));
        label_6->setMaximumSize(QSize(16777215, 30));
        label_6->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_6);

        label_7 = new QLabel(scrollAreaWidgetContents);
        label_7->setObjectName(QString::fromUtf8("label_7"));
        label_7->setMaximumSize(QSize(16777215, 30));
        label_7->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_7);

        label_8 = new QLabel(scrollAreaWidgetContents);
        label_8->setObjectName(QString::fromUtf8("label_8"));
        label_8->setMaximumSize(QSize(16777215, 30));
        label_8->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_8);

        label_9 = new QLabel(scrollAreaWidgetContents);
        label_9->setObjectName(QString::fromUtf8("label_9"));
        label_9->setMaximumSize(QSize(16777215, 30));
        label_9->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        verticalLayout->addWidget(label_9);


        horizontalLayout->addLayout(verticalLayout);

        verticalLayout_4 = new QVBoxLayout();
        verticalLayout_4->setSpacing(0);
        verticalLayout_4->setObjectName(QString::fromUtf8("verticalLayout_4"));
        newLine = new QLineEdit(scrollAreaWidgetContents);
        newLine->setObjectName(QString::fromUtf8("newLine"));
        newLine->setMinimumSize(QSize(150, 30));
        newLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(newLine);

        openLine = new QLineEdit(scrollAreaWidgetContents);
        openLine->setObjectName(QString::fromUtf8("openLine"));
        openLine->setMinimumSize(QSize(150, 30));
        openLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(openLine);

        saveLine = new QLineEdit(scrollAreaWidgetContents);
        saveLine->setObjectName(QString::fromUtf8("saveLine"));
        saveLine->setMinimumSize(QSize(150, 30));
        saveLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(saveLine);

        exitLine = new QLineEdit(scrollAreaWidgetContents);
        exitLine->setObjectName(QString::fromUtf8("exitLine"));
        exitLine->setMinimumSize(QSize(150, 30));
        exitLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(exitLine);

        cubeLine = new QLineEdit(scrollAreaWidgetContents);
        cubeLine->setObjectName(QString::fromUtf8("cubeLine"));
        cubeLine->setMinimumSize(QSize(150, 30));
        cubeLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(cubeLine);

        sphereLine = new QLineEdit(scrollAreaWidgetContents);
        sphereLine->setObjectName(QString::fromUtf8("sphereLine"));
        sphereLine->setMinimumSize(QSize(150, 30));
        sphereLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(sphereLine);

        pyramidLine = new QLineEdit(scrollAreaWidgetContents);
        pyramidLine->setObjectName(QString::fromUtf8("pyramidLine"));
        pyramidLine->setMinimumSize(QSize(150, 30));
        pyramidLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(pyramidLine);

        lightLine = new QLineEdit(scrollAreaWidgetContents);
        lightLine->setObjectName(QString::fromUtf8("lightLine"));
        lightLine->setMinimumSize(QSize(150, 30));
        lightLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(lightLine);

        addLine = new QLineEdit(scrollAreaWidgetContents);
        addLine->setObjectName(QString::fromUtf8("addLine"));
        addLine->setMinimumSize(QSize(150, 30));
        addLine->setMaximumSize(QSize(150, 30));

        verticalLayout_4->addWidget(addLine);


        horizontalLayout->addLayout(verticalLayout_4);

        scrollArea->setWidget(scrollAreaWidgetContents);

        verticalLayout_2->addWidget(scrollArea);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setSpacing(0);
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        horizontalLayout_2->setContentsMargins(-1, 9, -1, -1);
        OkButt = new QPushButton(shorcuts);
        OkButt->setObjectName(QString::fromUtf8("OkButt"));

        horizontalLayout_2->addWidget(OkButt);

        CancelButt = new QPushButton(shorcuts);
        CancelButt->setObjectName(QString::fromUtf8("CancelButt"));

        horizontalLayout_2->addWidget(CancelButt);


        verticalLayout_2->addLayout(horizontalLayout_2);


        retranslateUi(shorcuts);

        QMetaObject::connectSlotsByName(shorcuts);
    } // setupUi

    void retranslateUi(QWidget *shorcuts)
    {
        shorcuts->setWindowTitle(QApplication::translate("shorcuts", "Form", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("shorcuts", "New", 0, QApplication::UnicodeUTF8));
        label_2->setText(QApplication::translate("shorcuts", "Open", 0, QApplication::UnicodeUTF8));
        label_3->setText(QApplication::translate("shorcuts", "Save", 0, QApplication::UnicodeUTF8));
        label_4->setText(QApplication::translate("shorcuts", "Exit", 0, QApplication::UnicodeUTF8));
        label_5->setText(QApplication::translate("shorcuts", "Add cube", 0, QApplication::UnicodeUTF8));
        label_6->setText(QApplication::translate("shorcuts", "Add sphere", 0, QApplication::UnicodeUTF8));
        label_7->setText(QApplication::translate("shorcuts", "Add pyramid", 0, QApplication::UnicodeUTF8));
        label_8->setText(QApplication::translate("shorcuts", "Add light", 0, QApplication::UnicodeUTF8));
        label_9->setText(QApplication::translate("shorcuts", "Add new", 0, QApplication::UnicodeUTF8));
        newLine->setText(QApplication::translate("shorcuts", "CTRL+N", 0, QApplication::UnicodeUTF8));
        openLine->setText(QApplication::translate("shorcuts", "CTRL+O", 0, QApplication::UnicodeUTF8));
        saveLine->setText(QApplication::translate("shorcuts", "CTRL+S", 0, QApplication::UnicodeUTF8));
        exitLine->setText(QApplication::translate("shorcuts", "CTRL+Q", 0, QApplication::UnicodeUTF8));
        cubeLine->setText(QApplication::translate("shorcuts", "CTRL+SHIFT+C", 0, QApplication::UnicodeUTF8));
        sphereLine->setText(QApplication::translate("shorcuts", "CTRL+SHIFT+C", 0, QApplication::UnicodeUTF8));
        pyramidLine->setText(QApplication::translate("shorcuts", "CTRL+SHIFT+P", 0, QApplication::UnicodeUTF8));
        lightLine->setText(QApplication::translate("shorcuts", "CTRL+SHIFT+L", 0, QApplication::UnicodeUTF8));
        addLine->setText(QApplication::translate("shorcuts", "CTRL+SHIFT+N", 0, QApplication::UnicodeUTF8));
        OkButt->setText(QApplication::translate("shorcuts", "Ok", 0, QApplication::UnicodeUTF8));
        CancelButt->setText(QApplication::translate("shorcuts", "Cancel", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class shorcuts: public Ui_shorcuts {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_SHOTCUTS_H
