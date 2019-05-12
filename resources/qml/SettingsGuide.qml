//Copyright (C) 2018 Ultimaker B.V.
//Copyright (C) 2019 Ghostkeeper
//This plug-in is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//This plug-in is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for details.
//You should have received a copy of the GNU Affero General Public License along with this plug-in. If not, see <https://gnu.org/licenses/>.

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import UM 1.2 as UM
import Cura 1.0 as Cura

Window {
	id: settingsGuideBase
	title: catalog.i18nc("@title", "Cura Settings Guide") + " (" + manager.getPluginpluginVersion() + ")"
	modality: Qt.ApplicationModal
	flags: Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

	width: 1200 * screenScaleFactor
	height: 640 * screenScaleFactor
	minimumWidth: width
	maximumWidth: minimumWidth
	minimumHeight: height
	maximumHeight: minimumHeight

	color: UM.Theme.getColor("main_background")

	UM.I18nCatalog {
		id: catalog
		name: "cura"
	}

	//Display icon in the middle of the window
	Item {
		id: icon_item
		width: parent.width - rightSideItem.width
		height: parent.height
		visible: manager.selectedSettingId === ""

		anchors {
			leftMargin: 20 * screenScaleFactor
			rightMargin: 20 * screenScaleFactor
		}

		Image {
			id: welcome_icon
			source: Qt.resolvedUrl("../icons/icon.svg")
			width: 300 * screenScaleFactor
			height: 300 * screenScaleFactor

			anchors.horizontalCenter: icon_item.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			opacity: 0.5
		}

		Label {
			id: versionLabel
			anchors.top : welcome_icon.bottom
			anchors.topMargin: -60 * screenScaleFactor
			anchors.left: welcome_icon.right
			font.pixelSize: 22 * screenScaleFactor
			font.italic: true
			color: UM.Theme.getColor("text")

			text: "v" + manager.getPluginpluginVersion()
		}
	}

	Item {
		id: globalItem
		anchors.fill: parent
		focus: true

		Rectangle {
			id: rightSideItem
			width: UM.Theme.getSize("print_setup_widget").width
			border.color: UM.Theme.getColor("lining")
			border.width: 1
			color: "transparent"

			anchors {
				top: globalItem.top
				right: parent.right
				bottom: globalItem.bottom
				topMargin: 0
				bottomMargin: 0
				rightMargin: 0
				leftMargin: 0
			}

			SettingsSidebar {
				id: settingsSidebar
				anchors.fill: parent
				anchors.leftMargin: 1 * screenScaleFactor
			}
		}


		// Here we show our help images with hints and descriptions, and etc..
		Loader {
			id: pageLoader

			property var loaderData: manager.selectedSettingData //The object which holds all information for the Loader Item.
			anchors {
				left: parent.left
				right: rightSideItem.left
				top: parent.top
				bottom: parent.bottom
			}
		}
	}

	function callSettingItemChanged() {
		var data = manager.selectedSettingData;

		var setting_template = undefined;
		if(data["details"] != undefined && data["details"]["general"] != undefined) {
			var setting_template = data["details"]["general"]["template"];
		}

		var isCreatedBy = false
		if (manager.selectedSettingId != "" && manager.selectedSettingId.toLowerCase() == "createdby") {
			isCreatedBy = true;
		}

		// Selected setting uses general template
		var template_path = "";
		if (manager.selectedSettingId != "" && setting_template == undefined) {
			template_path = Qt.resolvedUrl("SidebarSettingTemplates/GeneralTemplate.qml");
		}
		// Selected setting has a different template
		else if (manager.selectedSettingId != "" && !isCreatedBy && setting_template != undefined) {
			template_path = Qt.resolvedUrl("SidebarSettingTemplates/" + setting_template);
		}
		// Special view which shows created by Template
		else if (isCreatedBy == true) {
			template_path = Qt.resolvedUrl("CreatedBy.qml");
		}

		if (template_path != "") {
			pageLoader.source = ""; // for some reason if don't do this then QT will not unload the previous source properly
			pageLoader.source = template_path;
		}
		else {
			pageLoader.source = "";
		}

		// Call Timer to trigger call back function
		loaderSourceChangeTimer.restart();
	}

	// After selecting the setting show proper template of the setting's guide
	Connections {
		target: manager
		onSettingItemChanged: {
			callSettingItemChanged();
		}
	}
}
