package toonshop.creator.interfaces
{
	import flash.events.IEventDispatcher;
	import spark.components.DataGroup;
	
	public interface IBrowseUIContainer extends IEventDispatcher
	{
		function get ui_stockChars() : DataGroup;
	}
}
