package toonshop.core
{
	import toonshop.utils.UtilHashArray;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Thumb extends EventDispatcher
	{	
		public static const DRAG_DATA_FORMAT:String = "thumb";
		public var name:String = "";
		protected var _id:String;
		
		public function Thumb()
		{
			super();
		}
	}
}
