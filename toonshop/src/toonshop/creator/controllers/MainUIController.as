package toonshop.creator.controllers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import toonshop.theme.Theme;
	import toonshop.cc_theme.Color;
	import toonshop.creator.controllers.BrowseUIController;
	import toonshop.creator.interfaces.IBrowseUIContainer;
	import toonshop.creator.interfaces.IMainUIContainer;
	import toonshop.managers.AppConfigManager;
	import toonshop.managers.ThemeManager;
	import toonshop.utils.UtilConsole;

	public class MainUIController extends EventDispatcher
	{
		private static var _instance:MainUIController;
		private static var _configManager:AppConfigManager = AppConfigManager.instance;
		
		private var mainUI:IMainUIContainer;
		private var browseUI:IBrowseUIContainer;
		//private var editUI:Group;
		//private var previewUI:Group;
		
		private var browserController:BrowseUIController;
		
		public function MainUIController(mainUI:IMainUIContainer)
		{
			super();
			this.mainUI = mainUI;
			this.browseUI = mainUI.ui_browseUIContainer;
			//this.editUI = mainUI.editor;
			//this.previewUI = mainUI.previewer;
			
			var themevar:String = _configManager.getValue(AppConfigManager.THEME_ID_PARAM);
			if (themevar == null || themevar.length <= 0) {
				themevar = "family";
			}
			
			// and now we can get things rolling
			this.loadTheme(themevar);
			this.browserController = new BrowseUIController(this.browseUI);
		}
		
		/**
		 * creates a cc browser instance if it hasn't been already 
		 * @param cc main ui container
		 * @param browser browser container
		 * @param editor editor container
		 * @param previewer previewer container
		 */		
		public static function init(mainUI:IMainUIContainer) : void
		{
			if (_instance == null) {
				_instance = new MainUIController(mainUI);
			}
		}
		
		public static function get instance() : MainUIController
		{
			return _instance;
		}
		
		/**
		 * 1st step: get the studio theme so we can access its stock chars
		 * @param themeId user-specified theme id
		 */		
		private function loadTheme(themeId:String) : void
		{
			var theme:Theme = new Theme();
			theme.addEventListener(Event.COMPLETE, this.onLoadThemeComplete);
			theme.loadTheme(themeId);
		}
		
		/**
		 * 2nd step: get the cc theme (duh)
		 * @param event
		 */		
		private function onLoadThemeComplete(event:Event) : void
		{
			var theme:Theme = event.target as Theme;
			ThemeManager.instance.pushTheme(theme);
			ThemeManager.instance.currentThemeId = theme.id;
			this.browserController.init();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}