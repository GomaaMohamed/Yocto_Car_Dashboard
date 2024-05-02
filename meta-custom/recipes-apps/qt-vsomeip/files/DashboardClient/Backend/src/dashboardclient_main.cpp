#include <QtCore>
#include <QtGui>
#include <QtQml>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <chrono>
#include <thread>
#include <mutex>
#include "Updater.hpp"
#include <vsomeip/vsomeip.hpp>
#include "DashboardClient.hpp"



int main(int argc, char **argv)
{
    // Launch someip client thread
    DashboardClient hw_srv;
    if (hw_srv.initClient())
    {
        // Create thread to initialize client
        std::thread t(&DashboardClient::startClient, &hw_srv);
        t.detach();
    }

    // Create GUI application
    QGuiApplication app(argc, argv);

    // Create QML engine
    QQmlApplicationEngine engine;

    // Get root context
    QQmlContext *context = engine.rootContext();

    // Create speed updater object
    Updater propertyUpdater(context);

    // Connect speed updater signals to QML engine slots
    engine.rootContext()->setContextProperty("SpeedCppSide", 0);
    engine.rootContext()->setContextProperty("TemperatureCppSide", 0);
    engine.rootContext()->setContextProperty("FuelCppSide", 0);
    QObject::connect(&propertyUpdater, &Updater::speedUpdated, context, [context](int value)
                     { context->setContextProperty("SpeedCppSide", value); });
    QObject::connect(&propertyUpdater, &Updater::temperatureUpdated, context, [context](int value)
                     { context->setContextProperty("TemperatureCppSide", value); });
    QObject::connect(&propertyUpdater, &Updater::fuelUpdated, context, [context](int value)
                     { context->setContextProperty("FuelCppSide", value); });
    QObject::connect(&propertyUpdater, &Updater::finished, &app, &QCoreApplication::quit);

    // Load QML file
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // Start property update thread
    std::thread thread([&propertyUpdater]()
                       { propertyUpdater.updateSpeed(); });
    thread.detach();

    // Start event loop
    return app.exec();
}