package toonshop.events
{
	public class XMLParserEvent extends ExtraDataEvent
	{
		public static const ATTR:String = "onattr";

		public function XMLParserEvent(type:String, creator:Object, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, creator, data, bubbles, cancelable);
		}
	}
}
