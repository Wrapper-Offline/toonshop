package toonshop.core.cc_theme
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import toonshop.core.CCChar;
	import toonshop.core.XMLParser;
	import toonshop.events.CoreEvent;
	import toonshop.utils.UtilConsole;
	import toonshop.utils.UtilHashArray;

	public class Bodyshape extends XMLParser
	{
		protected var _whatTheFuckAreYou:String;
		public var defaultAction:String;
		public var defaultMotion:String;
		public var thumbAction:String;
		public var thumbFacial:String;
		public var defaultChars:Vector.<CCChar>;
		private var _actions:UtilHashArray;
		public var components:Object;

		public function Bodyshape()
		{
			this.acceptsNodes = {
				"action": this.actionHandler,
				"component": this.componentHandler,
				"default_char": this.defaultCharHandler
			};
			this.extractAttrs = {
				"default_action": "defaultAction",
				"default_motion": "defaultMotion",
				"action_thumb": "thumbAction",
				"facial_thumb": "thumbFacial"
			};
			this._actions = new UtilHashArray();
			this.defaultChars = new Vector.<CCChar>();
			this.components = {};
		}

		protected function actionHandler(node:XML) : void
		{
			var selector:ComponentSelector = new ComponentSelector();
			selector.deSerialize(node);
			selector.bodyshape = this.id;
			this._actions.push(selector.id, selector);
		}

		protected function componentHandler(node:XML) : void
		{
			var comp:ComponentThumb = new ComponentThumb();
			comp.deSerialize(node);
			comp.bodyshape = this.id;
			if (this.components[comp.type] == null) {
				this.components[comp.type] = new UtilHashArray();
			}
			this.components[comp.type].push(comp.id, comp);
		}

		protected function defaultCharHandler(node:XML) : void
		{
			var char:CCChar = new CCChar();
			char.deSerialize(node);
			this.defaultChars.push(char);
		}
	}
}
