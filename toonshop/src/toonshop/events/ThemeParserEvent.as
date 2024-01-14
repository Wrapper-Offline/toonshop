package toonshop.events
{
	public class ThemeParserEvent extends ExtraDataEvent
	{
		public static const XML_ATTR_FOUND:String = "attrFound";

		public function ThemeParserEvent(type:String, creator:Object, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, creator, data, bubbles, cancelable);
		}
	}
}
