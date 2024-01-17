package toonshop.creator.interfaces
{
	import flash.events.IEventDispatcher;
	
	import spark.components.Button;
	import spark.effects.Resize;
	
	import toonshop.creator.components.browser.CharListPanel;
	import toonshop.creator.components.browser.CharacterInfoColumn;
	
	public interface IBrowseUIContainer extends IEventDispatcher
	{
		function get ui_charInfoCol() : CharacterInfoColumn;
		function get ui_stockChars() : CharListPanel;
		function get ui_customChars() : CharListPanel;
		function get ui_panelHeightDragger() : Button;
		function get tr_infoBlockIn() : Resize;
		function get tr_infoBlockOut() : Resize;
	}
}
