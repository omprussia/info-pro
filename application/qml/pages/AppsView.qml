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

Item {
    property alias title: header.title
    property alias model: view.model
    property alias delegate: view.delegate
    property int contentHeight: view.contentHeight + header.height + Theme.paddingLarge * 2

    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(palette.primaryColor, 0.07)
    }

    PageHeader {
        id: header
        _titleItem.font.pixelSize: Theme.fontSizeSmall
    }

    SilicaListView {
        id: view
        anchors {
            fill: parent
            topMargin: header.height + Theme.paddingLarge
            bottomMargin: Theme.paddingLarge
        }
        clip: true
        spacing: Theme.paddingMedium
    }
}
