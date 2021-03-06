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
import info.pro 1.0

SilicaGridView {
    id: root

    function load() {
        globalStatus.clear()
        DevInfoModel.reload()
    }

    clip: true
    property int _div: isPhone ? 1 : 2
    property int _indexMaxHeight: -1
    cellWidth: isPortrait ? root.width / _div : root.width / _div / 2

    NumberAnimation { id: animScroll; target: root; property: "contentY"; duration: 300; easing.type: Easing.OutExpo }

    delegate: CheckItemDelegate {

        width: cellWidth
        itemPath: model.itemPath
        targetValue: model.targetValue
        value: model.value

        onHeightChanged: {
            if (index === _indexMaxHeight || height > cellHeight) {
                _indexMaxHeight = index
                cellHeight = height
            }
        }

        onCheckStatusChanged: {
            globalStatus.update(model.name, checkStatus, value, targetValue)
        }
        onValueChanged: {
            globalStatus.update(model.name, checkStatus, value, targetValue)
        }
    }
    footer: Item {
        height: Theme.paddingLarge * 2
    }

    model: DevInfoModel
}
