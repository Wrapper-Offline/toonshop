package toonshop.core.cc_theme
{
	import flash.xml.XMLNode;
	
	public class Component
	{
		public static var XML_NODE_NAME:String = "component";
		public var id:String;
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var xScale:Number;
		public var yScale:Number;
		public var offset:Number;
		public var rotation:Number;
		
		public function Component()
		{
			super();
		}
		
		public function deSerialize(xml:XML) : void
		{
			this.id = xml.@component_id;
			this.type = xml.@type;
			this.x = xml.@x;
			this.y = xml.@y;
			this.xScale = xml.@xscale;
			this.yScale = xml.@yscale;
			this.offset = xml.@offset;
			this.rotation = xml.@rotation;
		}
	}
}
