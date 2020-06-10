TEMPLATE = app

TARGET = omp-info-pro
TARGETPATH = /usr/bin
CONFIG += link_pkgconfig c++14
PKGCONFIG += mlite5
QT += qml quick dbus

SOURCES += main.cpp \
           devinfomodel.cpp \
           globalstatus.cpp \
           appspecmodel.cpp \
           appdocmodel.cpp \
           reporter.cpp \
           emmconfig.cpp \
           checkinternet.cpp

HEADERS = $$files(*.h)

OTHER_FILES += main.qml

target.path = $$TARGETPATH

desktop.path = /usr/share/applications
desktop.files = $$TARGET".desktop"

DEPLOYMENT_PATH = /usr/share/$$TARGET
DEFINES *= DEPLOYMENT_PATH=\"\\\"\"$${DEPLOYMENT_PATH}/\"\\\"\"
qml.path = $$DEPLOYMENT_PATH
qml.files = qml/*.qml qml/pages qml/cover

graphics.path = $$DEPLOYMENT_PATH
graphics.files = graphics

INSTALLS += target desktop qml graphics

CONFIG += link_pkgconfig


packagesExist(qdeclarative5-boostable) {
    message("Building with qdeclarative-boostable support")
    DEFINES += HAS_BOOSTER
    PKGCONFIG += qdeclarative5-boostable
} else {
    warning("qdeclarative-boostable not available; startup times will be slower")
}

appicon.sizes = \
    86 \
    108 \
    128 \
    256

for(iconsize, appicon.sizes) {
    profile = $${iconsize}x$${iconsize}
    system(mkdir -p $${OUT_PWD}/$${profile})

    appicon.commands += /usr/bin/sailfish_svg2png \
        -s 1 1 1 1 1 1 $${iconsize} \
        $${_PRO_FILE_PWD_}/appicon \
        $${profile}/apps/ &&

    appicon.files += $${profile}
}
appicon.commands += true
appicon.path = /usr/share/icons/hicolor/

INSTALLS += appicon
