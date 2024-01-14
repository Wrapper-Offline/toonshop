package toonshop.managers
{
	import toonshop.core.Theme;
	import toonshop.utils.UtilHashArray;

	public class ThemeManager
	{
		private static var __instance:ThemeManager;
		private var _themes:UtilHashArray;
		private var _currentThemeId:String;

		public function ThemeManager()
		{
			this._themes = new UtilHashArray();
		}

		public static function get instance() : ThemeManager
		{
			if (!__instance)
			{
				__instance = new ThemeManager();
			}
			return __instance;
		}

		/**
		 * adds a theme to the theme list
		 * @param theme
		 */
		public function push(theme:Theme) : void
		{
			if (theme.id == null)
			{
				throw new Error("Expected theme to have an ID.");
			}
			this._themes.push(theme.id, theme);
		}

		/**
		 * returns a single theme from the theme list
		 * @param id the theme id
		 */
		public function get(id:String) : Theme
		{
			return this._themes.getValueByKey(id);
		}

		public function set currentThemeId(id:String) : void
		{
			if (!this.themes.containsKey(id))
			{
				throw new Error("Specified theme ID doesn't exist in ThemeManager.");
			}
			this._currentThemeId = id;
		}

		public function get currentThemeId() : String
		{
			return this._currentThemeId;
		}

		public function get currentTheme() : Theme
		{
			if (this._currentThemeId != null)
			{
				return this.themes.getValueByKey(this.currentThemeId);
			}
			return null;
		}

		public function get themes() : UtilHashArray
		{
			return this._themes;
		}
	}
}
