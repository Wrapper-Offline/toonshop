package toonshop.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	import toonshop.core.cc_theme.Color;
	import toonshop.core.cc_theme.ComponentSelector;
	import toonshop.events.CoreEvent;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	public class XMLParser extends EventDispatcher
	{
		public var id:String;
		protected var _colors:UtilHashArray;
		protected var _facials:UtilHashArray;
		protected var _actions:UtilHashArray;
		protected var acceptsNodes:Object;
		private var _nodeIndex:int;
		private var _totalNodes:int;
		private var _nodes:XMLList;

		public function XMLParser()
		{
		}

		/**
		 * parses a theme xml 
		 * @param xml theme xml
		 */		
		public function deSerialize(xml:XML) : void
		{
			// extract the main data
			this.id = xml.@id;
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
				this.passNodeToHandler(this._nodes[this._nodeIndex]);
				++this._nodeIndex;
			}
			setTimeout(this.doNextPrepare, 5);
		}
		
		/**
		 * This is a heavily cut down version of the studio's deserializeThumb function.
		 * This one is only capable of deserializing character thumbs.
		 */
		private function passNodeToHandler(node:XML) : void
		{
			var tagName:String = String(node.name().localName);
			if (this.acceptsNodes[tagName] != null) {
				this.acceptsNodes[tagName](node);
			}
		}

		protected function colorHandler(node:XML) : void
		{
			var color:Color = new Color();
			color.deSerialize(node);
			this._colors.push(color.id, color);
		}

		protected function compSelectorHandler(node:XML) : void
		{
			var tagName:String = String(node.name().localName);
			var selector:ComponentSelector = new ComponentSelector();
			selector.deSerialize(node);
			if (tagName == "facial") {
				this._facials.push(selector.id, selector);
			} else if (tagName == "action") {
				this._actions.push(selector.id, selector);
			}
		}
		
		/**
		 * Dispatches an Event.COMPLETE Event.
		 * @param event
		 */		
		private function onDeserializeComplete(event:CoreEvent) : void
		{
			removeEventListener(CoreEvent.DESERIALIZE_THEME_COMPLETE, this.onDeserializeComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
