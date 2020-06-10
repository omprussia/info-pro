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
import "private"

BaseCheck {
    //% "OS version"
    name: qsTrId("info_pro-la-name_osversion")
    order: 10

    property var _baseOperatingSystemName: value.toString().match(/^(?:\s?[^\W\d]+)*/g)
    property var _localizedOperatingSystemName: _baseOperatingSystemName
    property var _version: value.toString().match(/\d+.\d+.\d+/g)
    property var _majorVersion: _version.toString().match(/^\d+/g)
    property var _osNameVersion: _baseOperatingSystemName + " " + _majorVersion

    property var _targetBaseOperatingSystemName: targetValue.toString().match(/^(?:\s?[^\W\d]+)*/g)
    property var _targetVersion: targetValue.toString().match(/\d+.\d+.\d+/g)
    property var _targetMajorVersion: _targetVersion.toString().match(/^\d+/g)
    property var _targetOsNameVersion: _targetBaseOperatingSystemName + " " + _targetMajorVersion

    // Types do not match
    property bool _isEqualName: aboutSettings.baseOperatingSystemName == _targetBaseOperatingSystemName
    status: _osNameVersion == _targetOsNameVersion ? CheckStatus.Successful : CheckStatus.Error

    displayedValue: _isEqualName
                    ? _localizedOperatingSystemName + " " + _majorVersion
                    : _osNameVersion

    displayedTargetValue: _isEqualName ? displayedValue : _targetOsNameVersion
}

