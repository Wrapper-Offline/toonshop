package toonshop.theme
{	
	public class CharThumb extends Thumb
	{
		public static const XML_NODE_NAME:String = "char";
		public var copyable:Boolean = true;
		private var isCCChar:Boolean;
		
		public function CharThumb()
		{
			super();
		}

		public function deserialize(xml:XML) : void
		{
			this._id = xml.@id;
			this.name = xml.@name;
			this.copyable = xml.@copyable == "Y";
			if (xml.@cc_theme_id != null) {
				this.isCCChar = true;
			}
		}
	}
}
