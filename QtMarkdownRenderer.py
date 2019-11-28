#Copyright (C) 2019 Ghostkeeper
#This plug-in is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#This plug-in is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for details.
#You should have received a copy of the GNU Affero General Public License along with this plug-in. If not, see <https://gnu.org/licenses/>.

from .Mistune import mistune #Extending from this library's renderer.
import os.path #To fix the source paths for images.
import PyQt5.QtCore #To fix the source paths for images using QUrl.
import UM.Qt.Bindings.Theme #To get the correct hyperlink colour from the theme.

class QtMarkdownRenderer(mistune.Renderer):
	"""
	Specialises the Mistune renderer in order to be better compatible with Qt's
	rich text.

	Mistune converts Markdown into HTML. However its choice for the HTML
	elements to use is not always supported by the limited HTML subset that Qt
	can display with its "rich text" rendering. This class makes sure that the
	supported subset of HTML is used.
	"""

	def link(self, link, title, text):
		"""
		Renders a given link with content and title.

		This gives the link the correct colour, since Qt's linkColor property
		seems to be completely broken. This wraps the link text with a <font>
		tag that adjusts its colour.
		:param link: The URL to link towards.
		:param title: The description text for the link. This is not shown by Qt
		though, so in the end the argument will not be used.
		:param text: The text to display (in the correct colour).
		:return: HTML for Qt's Rich Text to display the link.
		"""
		link = mistune.escape_link(link)
		link_colour = UM.Qt.Bindings.Theme.Theme.getInstance().getColor("text_link").name()
		if not title:
			return "<a href=\"{link}\"><font color=\"{colour}\">{text}</font></a>".format(colour=link_colour, link=link, text=text)
		title = mistune.escape(title, quote=True)
		return "<a href=\"{link}\" title=\"{title}\"><font color=\"{colour}\">{text}</font></a>".format(colour=link_colour, title=title, link=link, text=text)

	def emphasis(self, text: str) -> str:
		"""
		Rendering *emphasis* text.

		By default, Mistune emphasises text using the <em> tag. Even though the
		QML documentation claims that <em> behaves the same as <i>,
		experimentally it seems that <em> doesn't work while <i> does.
		:param text: The emphasised text.
		:return: That text in italics.
		"""
		return "<i>{text}</i>".format(text=text)

	def image(self, src, title, alt_text):
		"""
		Renders an image with a title (normally displayed on hover) and an alt-
		text that gets displayed if the image is not available.
		:param src: The path to the image, relative to the "articles" directory.
		:param title: A text to display with the image. This gets ignored
		because Qt's Rich Text doesn't support it.
		:param alt_text: A text to display in case the image can't get loaded.
		This gets ignored because Qt's Rich Text doesn't support it.
		:return: HTML for Qt's Rich Text to display the image.
		"""
		image_full_path = os.path.join(os.path.dirname(__file__), "resources", "articles", src)
		image_url = PyQt5.QtCore.QUrl.fromLocalFile(image_full_path).url()
		margin = UM.Qt.Bindings.Theme.Theme.getInstance().getSize("default_margin").width()
		width = (UM.Qt.Bindings.Theme.Theme.getInstance().getSize("tooltip").width() - margin * 2) * 2.5 / 3  # Fit 3 images in the width. The width was multiplied by 2.5 from the theme.
		return "<img src=\"{image_url}\" width=\"{width}\" />".format(image_url=image_url, width=width)