/****************************************************************************
**
** Copyright (C) 2020 Open Mobile Platform LLC
** Contact: https://community.omprussia.ru/open-source
**
** This file is part of the omp-info-pro.
**
** This code is licensed under the MIT License (MIT).
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
** THE SOFTWARE.
**
****************************************************************************/
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1
import info.pro 1.0

Page {
    id: page
    allowedOrientations: isPhone ? Orientation.PortraitMask : Orientation.All
    showNavigationIndicator: false
    property alias title: header.title
    property string backText

    PageHeader {
        id: header
    }

    ColumnLayout {
        anchors {
            fill: parent
            topMargin: header.height + (isPhone ? Theme.paddingSmall : Theme.paddingLarge)
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }
        Item {
            id: view
            Layout.fillHeight: true
            Layout.fillWidth: true
            property int spacing: Theme.paddingLarge
            property int heightView: Math.max(appSpecView.contentHeight, appDocView.contentHeight)
            property int heightWithoutSpace: height - spacing
            property int widthWithoutSpace: width - spacing

            Grid {
                columns: isPortrait ? 1 : 2
                spacing: view.spacing

                AppsView {
                    id: appSpecView
                    width: isPortrait ? view.width : view.widthWithoutSpace * 0.64
                    height: isLandscape
                            ? Math.min(view.heightView, view.height)
                            : Math.min(contentHeight, Math.max(view.heightWithoutSpace/2, view.heightWithoutSpace - appDocView.contentHeight))
                    //% "Special software"
                    title: qsTrId("info_pro-he-special_software")
                    delegate: AppSpecDelegate {
                        width: parent.width
                        name: model.name
                    }
                    model: AppSpecModel {}
                }
                AppsView {
                    id: appDocView
                    width: isPortrait ? view.width : view.widthWithoutSpace - appSpecView.width
                    height: isLandscape ? appSpecView.height : Math.min(contentHeight, view.heightWithoutSpace - appSpecView.height)
                    //% "Document reader"
                    title: qsTrId("info_pro-he-document_reader")
                    delegate: AppDocDelegate {
                        width: parent.width
                        name: model.name
                        icon: model.icon
                    }
                    model: AppDocModel {
                        mimeFilters: DevInfoModel.docTypes
                    }
                }
            }
        }
        NavigationBar {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            canBack: true
            canNext: true
            backText: page.backText
            //% "Exit"
            nextText: qsTrId("info_pro-bt-exit")
            nextPreferredWidth: Theme.buttonWidthSmall
            onBack: pageStack.pop()
            onNext: Qt.quit()
        }
    }
}
