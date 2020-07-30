#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "cpp/radialbar.h"
#include "cpp/qmlinterface.h"

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QmlInterface * qmlInterface = new QmlInterface(&app, &engine);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));

    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");

    engine.rootContext()->setContextProperty(QStringLiteral("QmlInterface"),qmlInterface);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
