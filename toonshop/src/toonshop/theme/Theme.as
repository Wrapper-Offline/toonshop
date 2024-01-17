package toonshop.theme
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipFile;
	
	import toonshop.cc_theme.CCTheme;
	import toonshop.managers.ThemeManager;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;
	
	public class Theme extends EventDispatcher
	{
		private var _id:String;
		private var _ccThemeId:String = "";
		private var _name:String;
		private var _backgroundThumbs:UtilHashArray;
		private var _charThumbs:UtilHashArray;
		private var _bubbleThumbs:UtilHashArray;
		private var _propThumbs:UtilHashArray;
		private var _soundThumbs:UtilHashArray;
		private var _effectThumbs:UtilHashArray;
		
		public function Theme()
		{
			this._backgroundThumbs = new UtilHashArray();
			this._charThumbs = new UtilHashArray();
			this._bubbleThumbs = new UtilHashArray();
			this._propThumbs = new UtilHashArray();
			this._soundThumbs = new UtilHashArray();
			this._effectThumbs = new UtilHashArray();
		}
		
		/**
		 * clear all the thumb arrays
		 */
		public function clearAllThumbs() : void
		{
			this._charThumbs.removeAll();
			this._backgroundThumbs.removeAll();
			this._propThumbs.removeAll();
			this._effectThumbs.removeAll();
			this._soundThumbs.removeAll();
			this._bubbleThumbs.removeAll();
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
			var req:URLRequest = new URLRequest("/tsapi/v3/theme/get_zip");
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
			var zip:ZipFile = new ZipFile(loader.data as ByteArray);
			this.deSerialize(new XML(zip.getInput(zip.getEntry("theme.xml"))));
		}

		private function onLoadThemeFail(e:Event) : void
		{
			UtilConsole.instance.error(new Error("An error has occured retrieving the Theme ZIP."));
		}

		public function deSerialize(xml:XML) : void
		{
			this._id = xml.@id;
			this._name = xml.@name;
			this._ccThemeId = xml.@cc_theme_id;
			var node:XML;
			for each (node in xml.elements("char")) {
				var charThumb:CharThumb = new CharThumb();
				charThumb.deserialize(node);
				this.addThumb(charThumb);
			}
			this.onDeserializeComplete();
		}

		/**
		 * Called when the studio theme has finished deserialization.
		 * If there's a CC theme attached, it parses that.
		 * When all required deserializations are done, it dispatches an Event.COMPLETE Event.
		 * @param event
		 */		
		protected function onDeserializeComplete() : void
		{
			// nvm we're not done we still have to parse the cctheme
			if (this.ccThemeId) {
				var ccTheme:CCTheme = new CCTheme();
				ccTheme.addEventListener(Event.COMPLETE, this.onLoadCCThemeComplete);
				ccTheme.loadTheme(this.ccThemeId);
				return;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onLoadCCThemeComplete(e:Event) : void
		{
			var ccTheme:CCTheme = e.target as CCTheme;
			ThemeManager.instance.pushCCTheme(ccTheme);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Adds a Thumb to its respective UtilHashThumb if it doesn't exist.
		 */
		public function addThumb(thumb:Thumb) : void
		{
			if (thumb is CharThumb) {
				var charThumb:CharThumb = this._charThumbs.getValueByKey(thumb.id) as CharThumb;
				if (!charThumb) {
					this._charThumbs.push(thumb.id, thumb);
				}
			}
		}

		public function get id() : String
		{
			return this._id;
		}
		
		public function get ccThemeId() : String
		{
			return this._ccThemeId;
		}
		
		public function get name() : String
		{
			return this._name;
		}
		
		public function get hasCCTheme() : Boolean
		{
			return this.ccThemeId != "";
		}
		
		public function get charThumbs() : UtilHashArray
		{
			return this._charThumbs;
		}
	}
}