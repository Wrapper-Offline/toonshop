package toonshop.creator.interfaces
{
	import flash.events.IEventDispatcher;
	import toonshop.creator.components.browser.CharListBox;
	
	public interface IBrowseUIContainer extends IEventDispatcher
	{
		function get ui_stockChars() : CharListBox;
		function get ui_customChars() : CharListBox;
	}
}
