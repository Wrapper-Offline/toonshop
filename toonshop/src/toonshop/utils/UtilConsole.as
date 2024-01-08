package toonshop.utils
{
	import flash.external.ExternalInterface;

	public class UtilConsole
	{
		private static var _instance:UtilConsole;

		public function UtilConsole()
		{
			this.log("UtilConsole: Console set up.");
		}

		public static function get instance() : UtilConsole
		{
			if (!_instance) {
				_instance = new UtilConsole();
			}
			return _instance;
		}

		/**
		 * coverts the text argument to a string and calls the console method indicated by the method argument
		 */
		private function callJsConsole(method:String, text:*) : void
		{
			if (ExternalInterface.available)
			{
				var newText:String;
				if (text is String) {
					newText = text;
				} else if (text is Array) {
					newText = text.join(" ");
				} else if (text["toString"] != null) {
					newText = text.toString();
				} else {
					throw new TypeError("Expected argument 'text' to be a String, Array, or have a 'toString' method.");
				}
				ExternalInterface.call("console."+method, newText);
			}
		}

		/**
		 * calls console.log
		 */
		public function log(text:*) : void
		{
			this.callJsConsole("log", text);
		}

		/**
		 * calls console.error
		 */
		public function error(text:*) : void
		{
			this.callJsConsole("error", text);
		}

		/**
		 * calls console.warn
		 */
		public function warn(text:*) : void
		{
			this.callJsConsole("warn", text);
		}
	}
}