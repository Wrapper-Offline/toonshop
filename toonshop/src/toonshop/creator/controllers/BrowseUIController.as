package toonshop.creator.controllers
{	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	
	import toonshop.creator.components.browser.CharThumbnail;
	import toonshop.creator.interfaces.IBrowseUIContainer;
	import toonshop.managers.ThemeManager;
	import toonshop.theme.CharThumb;
	import toonshop.theme.Theme;
	import toonshop.utils.UtilConsole;
	
	public class BrowseUIController
	{
		private var ui:IBrowseUIContainer;
		private var charElements:Array;
		private var panelRows:Array;
		private var heightPerRow:Number = 138;
		private var selectedCharId:String = null;
		
		public function BrowseUIController(ui:IBrowseUIContainer)
		{
			super();
			this.ui = ui;
			this.charElements = new Array();
			this.panelRows = [1, 3];
		}

		public function init() : void
		{
			var currentTheme:Theme = ThemeManager.instance.currentTheme;
			for each (var char:CharThumb in currentTheme.charThumbs.getArray()) {
				var elem:CharThumbnail = new CharThumbnail();
				elem.addEventListener(MouseEvent.CLICK, this.charThumbnailClicked);
				elem.init(char);
				this.charElements.push(elem);
			}
			ui.ui_stockChars.charDataGroup.dataProvider = new ArrayCollection(this.charElements as Array);
			ui.ui_panelHeightDragger.addEventListener(MouseEvent.MOUSE_DOWN, this.panelDraggerClicked);
			this.setPanelHeights();
		}

		private function setPanelHeights() : void
		{
			ui.ui_stockChars.height = heightPerRow * panelRows[0];
			ui.ui_customChars.height = heightPerRow * panelRows[1];
			// hide panels with 0 height
			if (panelRows[0] == 0) {
				ui.ui_stockChars.visible = false;
			} else {
				ui.ui_stockChars.visible = true;
			}
			if (panelRows[1] == 0) {
				ui.ui_customChars.visible = false;
			} else {
				ui.ui_customChars.visible = true;
			}
		}

		/**
		 * switch chars if it's a different id, hide if it's the same.
		 * also play the animation if the info column is hidden atm
		 * @param event CharThumbnail, we'll be getting the id from this
		 */		
		private function charThumbnailClicked(event:MouseEvent) : void
		{
			var thumb:CharThumbnail = event.target as CharThumbnail;
			var isClosed:Boolean = this.selectedCharId == null;
			if (this.selectedCharId == thumb.data.id) {
				ui.tr_infoBlockOut.play();
				this.selectedCharId = null;
				ui.ui_charInfoCol.clear();
			} else {
				this.selectedCharId = thumb.data.id;
				ui.ui_charInfoCol.init(thumb.data);
				if (isClosed) {
					ui.tr_infoBlockIn.play();
				}
			}	
		}

		private function panelDraggerClicked(event:MouseEvent) : void
		{
			var target:Button = event.target as Button;
			ui.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveWhileDraggerClicked);
			ui.addEventListener(MouseEvent.MOUSE_UP, this.panelDraggerUp);
		}

		private function mouseMoveWhileDraggerClicked(event:MouseEvent) : void
		{
			// see how much of the screen divided into 4 sections the mouse takes up
			var stockRows:Number = Math.round((event.stageY + 20) / this.heightPerRow);
			this.panelRows[0] = stockRows;
			this.panelRows[1] = 4 - stockRows;
			this.setPanelHeights();
		}

		private function panelDraggerUp(event:MouseEvent) : void
		{
			ui.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveWhileDraggerClicked);
			ui.removeEventListener(MouseEvent.MOUSE_UP, this.panelDraggerUp);
		}
	}
}
