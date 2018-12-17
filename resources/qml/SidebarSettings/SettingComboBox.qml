// Copyright (c) 2018 Ultimaker B.V.
// Uranium is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0

import UM 1.2 as UM
import GuideTheme 1.0 as GuideThemeNS

SettingItem
{
    id: base
    property var focusItem: control

    contents: MouseArea
    {
        id: control
        anchors.fill: parent
        hoverEnabled: true

        property bool checked: false


        Rectangle
        {
            anchors
            {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            width: height

            color:
            {
                if(!enabled)
                {
                    return GuideThemeNS.Theme.getColor("setting_control_disabled")
                }
                if(control.containsMouse || control.activeFocus)
                {
                    return GuideThemeNS.Theme.getColor("setting_control_highlight")
                }
                return GuideThemeNS.Theme.getColor("setting_control")
            }

            border.width: GuideThemeNS.Theme.getSize("default_lining").width
            border.color:
            {
                if(!enabled)
                {
                    return GuideThemeNS.Theme.getColor("setting_control_disabled_border")
                }
                if(control.containsMouse || control.activeFocus)
                {
                    return GuideThemeNS.Theme.getColor("setting_control_border_highlight")
                }
                return GuideThemeNS.Theme.getColor("setting_control_border")
            }
        }
    }
}
