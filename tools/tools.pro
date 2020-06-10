TEMPLATE = app

TARGET = save-reference
TARGETPATH = /usr/bin
CONFIG += link_pkgconfig c++14
QT += qml quick
QT -= gui

SOURCES += save-reference.cpp \
           referencefile.cpp

HEADERS += referencefile.h \
           ../application/checkstatus.h

target.path = $$TARGETPATH

INSTALLS += target
