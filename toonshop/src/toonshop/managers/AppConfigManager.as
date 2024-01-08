package toonshop.managers
{
	import flash.net.URLVariables;
	import mx.core.FlexGlobals;

	/**
	 * handles all of the config/flashvar stuff 
	 */	
	public class AppConfigManager
	{
		private static var __instance:AppConfigManager;
		public static var THEME_ID_PARAM:String = "themeId";
		protected var _properties:Object;

		public function AppConfigManager()
		{
			super();
			this.init();
		}

		public static function get instance() : AppConfigManager
		{
			if (!__instance)
			{
				__instance = new AppConfigManager();
			}
			return __instance;
		}

		protected function init() : void
		{
			this._properties = {};
			this.processAppParams();
		}

		/**
		 * grabs all the flashvars that were passed to the object by the html
		 */
		public function processAppParams() : void
		{
			var application:Object = FlexGlobals.topLevelApplication;
			var params:Object = application.parameters;
			for (var name:String in params)
			{
				this.setValue(name, params[name]);
			}
		}

		/**
		 * gets a parameter
		 */
		public function getValue(name:String) : String
		{
			return this._properties[name];
		}

		/**
		 * sets a parameter
		 */
		public function setValue(name:String, value:String) : void
		{
			this._properties[name] = value;
		}

		/**
		 * creates a new URLVariables object containing the config and returns it
		 * @return a URLVariables object
		 */		
		public function createURLVariables() : URLVariables
		{
			var urlVars:URLVariables = new URLVariables();
			for (var name:String in this._properties)
			{
				urlVars[name] = this._properties[name];
			}
			return urlVars;
		}

		/**
		 * appends the entire config to an existing URLVariables object 
		 * @param urlVars the URLVariables object in question:
		 */
		public function appendURLVariables(urlVars:URLVariables) : void
		{
			for (var name:String in this._properties)
			{
				urlVars[name] = this._properties[name];
			}
		}
	}
}