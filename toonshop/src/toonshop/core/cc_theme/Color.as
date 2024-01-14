package toonshop.core.cc_theme
{
	import flash.xml.XMLNode;
	
	public class Color
	{
		public static var XML_NODE_NAME:String = "color";
		public var id:String;
		/**
		 * assets with shaders seem to color things by replacing a specific color
		 * :(
		 */
		public var replaceHex:String;
		public var value:String;
		
		public function Color()
		{
			super();
		}
		
		public function deSerialize(xml:XML) : void
		{
			this.id = xml.@r;
			this.replaceHex = xml.@oc;
			this.value = xml.text()[0];
		}
	}
}
