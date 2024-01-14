package toonshop.core.cc_theme
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import toonshop.core.XMLParser;
	import toonshop.events.CoreEvent;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	public class CCTheme extends XMLParser
	{
		protected var _bodyshapes:UtilHashArray;
		protected var _colors:UtilHashArray;
		protected var _components:Object;
		protected var _facials:UtilHashArray;

		public function CCTheme()
		{
			super();
			this.acceptsNodes = {
				"bodyshape": this.bodyshapeHandler,
				"color": this.colorHandler,
				"component": this.componentHandler,
				"facial": this.facialHandler
			};
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

		protected function bodyshapeHandler(node:XML) : void
		{
			var bodyshape:Bodyshape = new Bodyshape();
			bodyshape.addEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onBodyshapeComplete);
			bodyshape.deSerialize(node);
		}

		private function onBodyshapeComplete(e:CoreEvent) : void
		{
			var bodyshape:Bodyshape = e.target as Bodyshape;
			bodyshape.removeEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onBodyshapeComplete);
			for (var type:String in bodyshape.components) {
				if (this._components[type] == null) {
					this._components[type] = new UtilHashArray();
				}
				this._components[type].insert(this._components[type].length, bodyshape.components[type]);
			}
			bodyshape.components = null;
			this._bodyshapes.push(bodyshape.id, bodyshape);
		}

		protected function colorHandler(node:XML) : void
		{
			var color:ColorThumb = new ColorThumb();
			color.deSerialize(node);
			this._colors.push(color.id, color);
		}

		protected function componentHandler(node:XML) : void
		{
			var comp:ComponentThumb = new ComponentThumb();
			comp.deSerialize(node);
			if (this._components[comp.type] == null) {
				this._components[comp.type] = new UtilHashArray();
			}
			this._components[comp.type].push(comp.id, comp);
		}

		protected function facialHandler(node:XML) : void
		{
			var selector:ComponentSelector = new ComponentSelector();
			selector.deSerialize(node);
			this._facials.push(selector.id, selector);
		}

		public function get colors() : UtilHashArray
		{
			return this._colors;
		}
	}
}