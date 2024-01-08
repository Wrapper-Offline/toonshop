package toonshop.core.cc_theme
{
	import flash.xml.XMLNode;
	
	public class Component
	{
		public static var XML_NODE_NAME:String = "component";
		public var id:String;
		public var type:String;
		public var path:String;
		public var name:String;
		public var thumb:String;
		public var enabled:Boolean;
		public var states:Object = {};
		
		public function Component()
		{
			super();
		}
		
		public function deSerialize(xml:XML) : void
		{
			this.id = xml.@id;
			this.type = xml.@type;
			this.path = xml.@path;
			this.name = xml.@name;
			this.thumb = xml.@thumb;
			this.enabled = xml.@enable != "N";
			
			var states:XMLList = xml.state;
			for each (var elem:XML in states) {
				this.states[elem.@id] = elem.@filename;
			}
		}
	}
}
