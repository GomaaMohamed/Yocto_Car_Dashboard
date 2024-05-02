#ifndef UPDATER_
#define UPDATER_

#include <QtCore>
#include <QtGui>
#include <QtQml>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <chrono>
#include <thread>
#include <mutex>

class Updater : public QObject
{
    Q_OBJECT
public:
    Updater(QQmlContext *context, QObject *parent = nullptr);
    void updateSpeed();
    
signals:
    void speedUpdated(int value);
    void temperatureUpdated(int value);
    void fuelUpdated(int value);
    void finished();

private:
    QQmlContext *m_context;
};

#endif