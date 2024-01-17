package toonshop.theme
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

		public function get id() : String
		{
			return this._id;
		}
	}
}
