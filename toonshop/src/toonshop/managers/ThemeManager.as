package toonshop.managers
{
	import toonshop.theme.Theme;
	import toonshop.cc_theme.CCTheme;
	import toonshop.utils.UtilHashArray;

	public class ThemeManager
	{
		private static var __instance:ThemeManager;
		private var _themes:UtilHashArray;
		private var _ccThemes:UtilHashArray;
		private var _currentThemeId:String;

		public function ThemeManager()
		{
			this._themes = new UtilHashArray();
		}

		public static function get instance() : ThemeManager
		{
			if (!__instance) {
				__instance = new ThemeManager();
			}
			return __instance;
		}

		/**
		 * adds a theme to the theme list
		 * @param theme
		 */
		public function pushTheme(theme:Theme) : void
		{
			if (theme.id == null) {
				throw new Error("Expected theme to have an ID.");
			}
			this._themes.push(theme.id, theme);
		}

		/**
		 * returns a single theme from the theme list
		 * @param id the theme id
		 */
		public function getTheme(id:String) : Theme
		{
			return this._themes.getValueByKey(id);
		}

		/**
		 * returns the currently selected theme
		 */
		public function get currentTheme() : Theme
		{
			if (this._currentThemeId != null) {
				return this.themes.getValueByKey(this.currentThemeId);
			}
			return null;
		}

		/**
		 * adds a cc theme
		 * @param theme
		 */
		public function pushCCTheme(ccTheme:CCTheme) : void
		{
			if (ccTheme.id == null) {
				throw new Error("Expected ccTheme to have an ID.");
			}
			this._themes.push(ccTheme.id, ccTheme);
		}

		/**
		 * returns a cc theme
		 * @param id the cc theme id
		 */
		public function getCCTheme(id:String) : Theme
		{
			return this._themes.getValueByKey(id);
		}

		/**
		 * returns the currently selected theme's cc theme
		 */
		public function get currentCCTheme() : Theme
		{
			if (this._currentThemeId != null) {
				return this.ccThemes.getValueByKey(this.currentTheme.ccThemeId);
			}
			return null;
		}

		public function set currentThemeId(id:String) : void
		{
			if (!this.themes.containsKey(id)) {
				throw new Error("Specified theme ID doesn't exist in ThemeManager.");
			}
			this._currentThemeId = id;
		}

		public function get currentThemeId() : String
		{
			return this._currentThemeId;
		}

		public function get themes() : UtilHashArray
		{
			return this._themes;
		}

		public function get ccThemes() : UtilHashArray
		{
			return this._ccThemes;
		}
	}
}
