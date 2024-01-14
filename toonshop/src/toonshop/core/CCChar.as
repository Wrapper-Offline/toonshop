package toonshop.core
{
	import toonshop.core.cc_theme.Color;
	import toonshop.core.cc_theme.Component;
	import toonshop.utils.UtilHashArray;

	public class CCChar extends XMLParser
	{
		public var colors:UtilHashArray;
		public var components:Vector.<Component>;

		public function CCChar()
		{
			this.acceptsNodes = {
				"color": this.colorHandler,
				"component": this.componentHandler
			};
			this.colors = new UtilHashArray();
			this.components = new Vector.<Component>();
		}

		protected function colorHandler(node:XML) : void
		{
			var color:Color = new Color();
			color.deSerialize(node);
			this.colors.push(color.id, color);
		}
		
		protected function componentHandler(node:XML) : void
		{
			var comp:Component = new Component();
			comp.deSerialize(node);
			this.components.push(comp);
		}
	}
}