package toonshop.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import nochump.util.zip.ZipFile;
	
	import toonshop.events.CoreEvent;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;
	import toonshop.core.cc_theme.CCTheme;
	
	public class Theme extends XMLParser
	{
		public var ccThemeId:String = "";
		public var name:String;
		public var ccTheme:CCTheme;
		private var _backgroundThumbs:UtilHashArray;
		private var _charThumbs:UtilHashArray;
		private var _bubbleThumbs:UtilHashArray;
		private var _propThumbs:UtilHashArray;
		private var _soundThumbs:UtilHashArray;
		private var _effectThumbs:UtilHashArray;
		
		public function Theme()
		{
			this.acceptsNodes = {
				"char": this.charThumbHandler
			};
			this.extractAttrs = {
				"name": "name",
				"cc_theme_id": "ccThemeId"
			};
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

		public function get isCCTheme() : Boolean
		{
			return this.ccThemeId != "";
		}

		public function get charThumbs() : UtilHashArray
		{
			return this._charThumbs;
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

		/**
		 * This is a heavily cut down version of the studio's deserializeThumb function.
		 * This one is only capable of deserializing character thumbs.
		 */
		private function charThumbHandler(node:XML) : void
		{
			var thumb:CharThumb = new CharThumb();
			thumb.deserialize(node);
			this._charThumbs.push(thumb.id, thumb);
		}

		/**
		 * Called when the studio theme has finished deserialization.
		 * If there's a CC theme attached, it parses that.
		 * When all required deserializations are done, it dispatches an Event.COMPLETE Event.
		 * @param event
		 */		
		override protected function onDeserializeComplete(event:CoreEvent) : void
		{
			removeEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			// nvm we're not done we still have to parse the cctheme
			if (this.ccThemeId)
			{
				this.ccTheme = new CCTheme();
				this.ccTheme.addEventListener(Event.COMPLETE, this.onLoadCCThemeComplete);
				this.ccTheme.loadTheme(this.ccThemeId);
				return;
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onLoadCCThemeComplete(e:Event) : void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Adds a Thumb to its respective UtilHashThumb if it doesn't exist.
		 */
		public function addThumb(thumb:Thumb) : void
		{
			var charThumb:CharThumb = null;
			if (thumb is CharThumb)
			{
				/*charThumb = this._charThumbs.getValueByKey(thumb.id) as CharThumb;
				if (!charThumb)
				{
				this._charThumbs.push(thumb.id, thumb);
				}*/
			}
		}
	}
}