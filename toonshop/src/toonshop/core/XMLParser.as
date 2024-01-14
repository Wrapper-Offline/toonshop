package toonshop.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import toonshop.core.cc_theme.Bodyshape;
	import toonshop.core.cc_theme.ColorThumb;
	import toonshop.core.cc_theme.ComponentSelector;
	import toonshop.events.CoreEvent;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	public class XMLParser extends EventDispatcher
	{
		public var id:String;
		protected var acceptsNodes:Object;
		protected var extractAttrs:Object;
		private var _nodeIndex:int;
		private var _totalNodes:int;
		private var _nodes:XMLList;

		public function XMLParser()
		{
			super();
		}

		/**
		 * begins extracting information from the xml
		 * @param xml
		 */		
		public function deSerialize(xml:XML) : void
		{
			// extract the main data
			this.id = xml.@id;
			for (var attr:String in this.extractAttrs) {
				var value:String = xml.attribute(attr);
				if (value != null) {
					this[this.extractAttrs[attr]] = value;
				}
			}

			this._nodes = xml.children();
			this._totalNodes = this._nodes.length();
			this._nodeIndex = 0;
			UtilConsole.instance.log("Deserialize "+getQualifiedClassName(this)+" XML nodes: " + this._totalNodes);
			addEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			// start actually going through the assets
			this.doNextPrepare();
		}
		
		/**
		 * loops through 32 XML nodes, waits 5ms, and repeats itself
		 */
		protected function doNextPrepare() : void
		{
			// check if we've gone through the entire xml
			if (this._nodeIndex >= this._totalNodes) {
				dispatchEvent(new CoreEvent(CoreEvent.DESERIALIZE_THEME_COMPLETE, this));
				return;
			}
			var stopAt:int = this._nodeIndex + 32;
			while (this._nodeIndex < stopAt && this._nodeIndex < this._totalNodes) {
				this.passNodeToHandler(this._nodes[this._nodeIndex]);
				++this._nodeIndex;
			}
			setTimeout(this.doNextPrepare, 5);
		}
		
		/**
		 * Because this class isn't meant to be used on its own,
		 * we'll just pass every XML node along to our subclass if it accepts it.
		 */
		private function passNodeToHandler(node:XML) : void
		{
			var tagName:String = String(node.name().localName);
			if (this.acceptsNodes[tagName] != null) {
				this.acceptsNodes[tagName](node);
			}
		}
		
		/**
		 * Dispatches an Event.COMPLETE Event.
		 * @param event
		 */		
		protected function onDeserializeComplete(event:CoreEvent) : void
		{
			removeEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
