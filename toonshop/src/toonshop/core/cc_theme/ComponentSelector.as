package toonshop.core.cc_theme
{
	import flash.xml.XMLNode;
	
	public class ComponentSelector
	{
		public static var XML_NODE_NAME:String = "facial";
		public var id:String;
		public var name:String;
		public var enabled:Boolean;
		public var loop:Boolean;
		public var totalFrames:int;
		public var category:String;
		public var selections:Object = {};
		
		public function ComponentSelector()
		{
			super();
		}

		public function deSerialize(xml:XML) : void
		{
			this.id = xml.@id;
			this.name = xml.@name;
			this.enabled = xml.@enable != "N";
			this.loop = xml.@enable != "N";
			this.totalFrames = xml.@totalframe;
			this.category = xml.@category;
			
			var selections:XMLList = xml.selection;
			for each (var elem:XML in selections) {
				var type:String = elem.@type;
				if (type == "facial") {
					this.selections[type] = elem.@facial_id;
					continue;
				}
				this.selections[type] = elem.@state_id;
			}
		}
	}
}