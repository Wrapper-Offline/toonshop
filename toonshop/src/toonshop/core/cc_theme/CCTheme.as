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
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	/**
	 * designed to be extreeemely similar to Theme
	 * could probably merge the two but i wanna see where this ends up
	 */
	public class CCTheme extends XMLParser
	{
		public function CCTheme()
		{
			super();
			this.acceptsNodes = {
				"color": this.colorHandler,
				"facial": this.compSelectorHandler
			};
			this._colors = new UtilHashArray();
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

		public function get colors() : UtilHashArray
		{
			return this._colors;
		}
	}
}