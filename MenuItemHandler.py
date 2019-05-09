#Copyright (C) 2018 Aleksei Sasin
#Copyright (C) 2019 Ghostkeeper
#This plug-in is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#This plug-in is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for details.
#You should have received a copy of the GNU Affero General Public License along with this plug-in. If not, see <https://gnu.org/licenses/>.

class MenuItemHandler:
	def __init__(self, plugin_controller) -> None:
		self._plugin_controller = plugin_controller

	def sidebarMenuItemOnClickHandler(self, kwargs) -> None:
		if "key" in kwargs:
			setting_key = kwargs["key"]
			self._plugin_controller.startWelcomeGuideAndSelectSetting(setting_key)