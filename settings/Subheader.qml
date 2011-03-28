/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1

Item {
    property alias text: label.text
    anchors.left: parent.left
    anchors.right: parent.right
    height: 60
    Text {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pixelSize: theme_fontPixelSizeLarge
        color: theme_fontColorNormal
        height: parent.height
        width: parent.width
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
