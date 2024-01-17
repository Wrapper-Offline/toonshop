package toonshop.cc
{
	import toonshop.cc_theme.Component;

	public class CCChar
	{
		private var _colors:Object;
		private var _bodyshape:String;
		private var _components:Vector.<Component>;

		public function CCChar()
		{
			this._colors = {};
			this._components = new Vector.<Component>();
		}

		public function deSerialize(xml:XML) : void
		{
			var node:XML;
			for each (node in xml.elements("color")) {
				this._colors[node.@r] = node.text()[0];
			}
			for each (node in xml.elements(Component.XML_NODE_NAME)) {
				if (node.@type == "bodyshape") {
					this._bodyshape = node.@component_id;
				}
				var comp:Component = new Component();
				comp.deSerialize(node);
				this._components.push(comp);
			}
		}
	}
}
