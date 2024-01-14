package toonshop.core.cc_theme
{
	import flash.xml.XMLNode;

	public class ColorThumb
	{
		public static var XML_NODE_NAME:String = "color";
		public var id:String;
		/**
		 * assets with shaders seem to color things by replacing a specific color
		 * :(
		 */
		public var replaceHex:String;
		public var resetsTo:String;
		public var enabled:Boolean;
		public var presets:Vector.<String> = new Vector.<String>;

		public function ColorThumb()
		{
			super();
		}

		public function deSerialize(xml:XML) : void
		{
			this.id = xml.@r;
			this.replaceHex = xml.@oc;
			this.resetsTo = xml.@parent_color_r;
			this.enabled = xml.@enable != "N";

			var choices:XMLList = xml.choice;
			for each (var elem:XML in choices) {
				this.presets.push(elem.text()[0]);
			}
		}
	}
}
