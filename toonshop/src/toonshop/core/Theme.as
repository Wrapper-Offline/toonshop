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
	
	public class Theme extends EventDispatcher
	{
		public var ccTheme:CCTheme;
		private var _id:String;
		private var _ccThemeId:String = "";
		private var _name:String;
		private var _backgroundThumbs:UtilHashArray;
		private var _charThumbs:UtilHashArray;
		private var _bubbleThumbs:UtilHashArray;
		private var _propThumbs:UtilHashArray;
		private var _soundThumbs:UtilHashArray;
		private var _effectThumbs:UtilHashArray;
		private var _nodeIndex:int;
		private var _totalNodes:int;
		private var _nodes:XMLList;
		
		public function Theme()
		{
			super();
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
			return this._ccThemeId != "";
		}

		public function get ccThemeId() : String
		{
			return this._ccThemeId;
		}

		public function set id(id:String) : void
		{
			this._id = id;
		}

		public function get id() : String
		{
			return this._id;
		}

		public function get name() : String
		{
			return this._name;
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
		 * parses a theme xml 
		 * @param xml theme xml
		 */		
		public function deSerialize(xml:XML) : void
		{
			// extract the main data
			this.id = xml.@id;
			this._ccThemeId = xml.@cc_theme_id;
			this._nodes = xml.children();
			this._totalNodes = this._nodes.length();
			this._nodeIndex = 0;
			UtilConsole.instance.log("Deserialize Theme XML nodes: " + this._totalNodes);
			addEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			// start actually going through the assets
			this.doNextPrepare();
		}
		
		/**
		 * loops through 32 XML nodes, waits 5ms, and repeats itself
		 */
		private function doNextPrepare() : void
		{
			// check if we've gone through the entire xml
			if (this._nodeIndex >= this._totalNodes) {
				dispatchEvent(new CoreEvent(CoreEvent.DESERIALIZE_THEME_COMPLETE, this));
				return;
			}
			var stopAt:int = this._nodeIndex + 32;
			while (this._nodeIndex < stopAt && this._nodeIndex < this._totalNodes) {
				this.deserializeThumb(this._nodes[this._nodeIndex]);
				++this._nodeIndex;
			}
			setTimeout(this.doNextPrepare, 5);
		}

		/**
		 * This is a heavily cut down version of the studio's deserializeThumb function.
		 * This one is only capable of deserializing character thumbs.
		 */
		private function deserializeThumb(node:XML) : void
		{
			var tagName:String = String(node.name().localName);
			switch (tagName) {
				case CharThumb.XML_NODE_NAME: {
					var thumb:CharThumb = new CharThumb();
					thumb.deserialize(node);
					this._charThumbs.push(thumb.id, thumb);
					break;
				}
			}
		}

		/**
		 * Called when the studio theme has finished deserialization.
		 * If there's a CC theme attached, it parses that.
		 * When all required deserializations are done, it dispatches an Event.COMPLETE Event.
		 * @param event
		 */		
		private function onDeserializeComplete(event:CoreEvent) : void
		{
			removeEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			// nvm we're not done we still have to parse the cctheme
			if (this._ccThemeId)
			{
				this.ccTheme = new CCTheme();
				this.ccTheme.addEventListener(Event.COMPLETE, this.onLoadCCThemeComplete);
				this.ccTheme.loadTheme(this.ccThemeId);
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