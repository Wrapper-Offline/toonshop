package toonshop.cc_theme
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import toonshop.cc.CCChar;
	import toonshop.utils.UtilHashArray;

	public class Bodyshape extends EventDispatcher
	{
		public static var XML_NODE_NAME:String = "bodyshape";
		private var _whatTheFuckAreYou:String;
		private var _id:String;
		private var _defaultAction:String;
		private var _defaultMotion:String;
		private var _thumbAction:String;
		private var _thumbFacial:String;
		private var _defaultChars:Vector.<CCChar>;
		private var _actions:UtilHashArray;
		private var _components:Object;

		public function Bodyshape()
		{
			this._actions = new UtilHashArray();
			this._defaultChars = new Vector.<CCChar>();
			this._components = {};
		}

		public function deSerialize(xml:XML) : void
		{
			this._defaultAction = xml.@default_action;
			this._defaultMotion = xml.@default_motion;
			this._thumbAction = xml.@action_thumb;
			this._thumbAction = xml.@facial_thumb;
			var node:XML;
			for each (node in xml.elements("action")) {
				var selector:ComponentSelector = new ComponentSelector();
				selector.deSerialize(node);
				selector.bodyshape = this.id;
				this._actions.push(selector.id, selector);
			}
			for each (node in xml.elements("component")) {
				var comp:ComponentThumb = new ComponentThumb();
				comp.deSerialize(node);
				comp.bodyshape = this.id;
				if (this._components[comp.type] == null) {
					this._components[comp.type] = new UtilHashArray();
				}
				this._components[comp.type].push(comp.id, comp);
			}
			for each (node in xml.elements("default_char")) {
				var char:CCChar = new CCChar();
				char.deSerialize(node);
				this._defaultChars.push(char);
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function clearComponents() : void
		{
			this._components = null;
		}

		public function get id() : String
		{
			return this._id;
		}
		
		public function get defaultAction() : String
		{
			return this._defaultAction;
		}
		
		public function get defaultMotion() : String
		{
			return this._defaultMotion;
		}
		
		public function get thumbAction() : String
		{
			return this._thumbAction;
		}
		
		public function get thumbFacial() : String
		{
			return this._thumbFacial;
		}

		public function get components() : Object
		{
			return this._components;
		}
	}
}
