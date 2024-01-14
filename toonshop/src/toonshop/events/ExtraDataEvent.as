package toonshop.events
{
	import flash.events.Event;
	
	public class ExtraDataEvent extends Event
	{
		
		public static const UPDATE:String = "update";
		public static const PITCH_UPDATE:String = "pitch_update";
		public static const PROCESSING:String = "processing";
		private var _data:Object;
		private var _eventCreator:Object;
		
		public function ExtraDataEvent(param1:String, param2:Object, param3:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(param1, bubbles, cancelable);
			this.setData(param3);
			this.setEventCreator(param2);
		}
		
		public function getEventCreator() : Object
		{
			return this._eventCreator;
		}
		
		private function setEventCreator(param1:Object) : void
		{
			this._eventCreator = param1;
		}
		
		public function getData() : Object
		{
			return this._data;
		}
		
		private function setData(param1:Object) : void
		{
			this._data = param1;
		}
		
		override public function clone() : Event
		{
			return new ExtraDataEvent(this.type, this.getEventCreator(), this.getData(), this.bubbles, this.cancelable);
		}
	}
}
