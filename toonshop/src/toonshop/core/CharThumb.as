package toonshop.core
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class CharThumb extends Thumb
	{
		public static const XML_NODE_NAME:String = "char";
		public var copyable:Boolean = true;
		private var isCCChar:Boolean;
		
		public function CharThumb()
		{
			super();
		}

		public function get id() : String
		{
			return this._id;
		}

		public function deserialize(xml:XML) : void
		{
			this._id = xml.@id;
			this.name = xml.@name;
			this.copyable = xml.@copyable == "Y";
			if (xml.@cc_theme_id != null) {
				this.isCCChar = true;
			}
		}
	}
}
