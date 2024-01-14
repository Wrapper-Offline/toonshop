package toonshop.creator.controllers
{	
	import mx.collections.ArrayCollection;
	
	import spark.components.Label;
	
	import toonshop.core.CharThumb;
	import toonshop.core.Theme;
	import toonshop.creator.components.browser.CharThumbnail;
	import toonshop.creator.interfaces.IBrowseUIContainer;
	import toonshop.managers.ThemeManager;
	
	public class BrowseUIController
	{
		private var ui:IBrowseUIContainer;
		private var charElements:Array;
		
		public function BrowseUIController(ui:IBrowseUIContainer)
		{
			super();
			this.ui = ui;
			this.charElements = new Array;
		}

		public function init() : void
		{
			var currentTheme:Theme = ThemeManager.instance.currentTheme;
			for each (var char:CharThumb in currentTheme.charThumbs.getArray()) {
				var elem:CharThumbnail = new CharThumbnail();
				elem.init(char);
				this.charElements.push(elem);
			}
			ui.ui_stockChars.charDataGroup.dataProvider = new ArrayCollection(this.charElements as Array);
		}
	}
}
