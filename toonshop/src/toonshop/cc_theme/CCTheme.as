package toonshop.cc_theme
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	public class CCTheme extends EventDispatcher
	{
		protected var _bodyshapes:UtilHashArray;
		protected var _colors:UtilHashArray;
		protected var _components:Object;
		protected var _facials:UtilHashArray;
		private var _id:String;
		private var _isV2:Boolean = false;

		public function CCTheme()
		{
			super();
			this._bodyshapes = new UtilHashArray();
			this._colors = new UtilHashArray();
			this._components = {};
			this._facials = new UtilHashArray();
		}

		/**
		 * retrieves a theme zip from the api and deserializes the xml inside 
		 * @param themeId
		 */		
		public function loadTheme(themeId:String) : void
		{
			var loader:URLLoader = new URLLoader();
			var data:URLVariables = new URLVariables();
			data.themeId = themeId;
			var req:URLRequest = new URLRequest("/tsapi/v3/cc_theme/get_xml");
			req.method = "GET";
			req.data = data;
			loader.addEventListener(Event.COMPLETE, this.onLoadThemeSuccess);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadThemeFail);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(req);
		}

		private function onLoadThemeSuccess(e:Event) : void
		{
			var loader:URLLoader = e.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, this.onLoadThemeSuccess);
			this.deSerialize(new XML(loader.data as ByteArray));
		}

		private function onLoadThemeFail(e:Event) : void
		{
			UtilConsole.instance.error(new Error("An error has occured retrieving the CCTheme XML."));
		}

		public function deSerialize(xml:XML) : void
		{
			this._id = xml.@id;
			if (xml.@version == "2.0") {
				this._isV2 = true;
			}

			var node:XML;
			for each (node in xml.elements("color")) {
				var color:Color = new Color();
				color.deSerialize(node);
				this._colors.push(color.id, color);
			}
			for each (node in xml.elements(Component.XML_NODE_NAME)) {
				var comp:ComponentThumb = new ComponentThumb();
				comp.deSerialize(node);
				if (this._components[comp.type] == null) {
					this._components[comp.type] = new UtilHashArray();
				}
				this._components[comp.type].push(comp.id, comp);
			}
			for each (node in xml.elements(Bodyshape.XML_NODE_NAME)) {
				var bodyshape:Bodyshape = new Bodyshape();
				bodyshape.addEventListener(Event.COMPLETE, this.onBodyshapeComplete);
				bodyshape.deSerialize(node);
			}
			for each (node in xml.elements("facial")) {
				var selector:ComponentSelector = new ComponentSelector();
				selector.deSerialize(node);
				this._facials.push(selector.id, selector);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onBodyshapeComplete(e:Event) : void
		{
			var bodyshape:Bodyshape = e.target as Bodyshape;
			bodyshape.removeEventListener(Event.COMPLETE, this.onBodyshapeComplete);
			for (var type:String in bodyshape.components) {
				if (this._components[type] == null) {
					this._components[type] = new UtilHashArray();
				}
				this._components[type].insert(this._components[type].length, bodyshape.components[type]);
			}
			bodyshape.clearComponents();
			this._bodyshapes.push(bodyshape.id, bodyshape);
		}

		public function get id() : String
		{
			return this._id;
		}

		public function get isV2() : Boolean
		{
			return this._isV2;
		}

		public function get colors() : UtilHashArray
		{
			return this._colors;
		}
	}
}