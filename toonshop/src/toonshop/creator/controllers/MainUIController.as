package toonshop.creator.controllers
{
	import toonshop.core.Theme;
	import toonshop.core.cc_theme.Color;
	import toonshop.creator.controllers.BrowseUIController;
	import toonshop.creator.interfaces.IBrowseUIContainer;
	import toonshop.creator.interfaces.IMainUIContainer;
	import toonshop.managers.AppConfigManager;
	import toonshop.utils.UtilConsole;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public class MainUIController extends EventDispatcher
	{
		private static var _instance:MainUIController;
		private static var _configManager:AppConfigManager = AppConfigManager.instance;
		
		private var themeId:String;
		//private var ccTheme:CcTheme;
		private var theme:Theme;
		
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
			this.themeId = themevar;
			
			// and now we can get things rolling
			this.loadTheme(this.themeId);
			
			
			/*var _loc4_:String = _configManager.getValue(ServerConstants.PARAM_THEME_ID);
			if (_loc4_ == null || _loc4_.length <= 0) {
			_loc4_ = "family";
			}
			_themeId = _loc4_;
			// are we copying an existing character?
			this.originalAssetId = _configManager.getValue("original_asset_id") as String;
			if (this.originalAssetId == null || this.originalAssetId.length <= 0) {
			this.originalAssetId = null;
			}
			this.addCallBacks();
			// check if the user is an admin
			var _loc7_:String = _configManager.getValue(ServerConstants.FLASHVAR_IS_ADMIN) as String;
			if (_loc7_ == "1") {
			this._userLevel = CcLibConstant.USER_LEVEL_SUPER;
			} else {
			this._userLevel = CcLibConstant.USER_LEVEL_NORMAL;
			}
			this._ccCharEditorController = new anifire.creator.core.CcCharEditorController();
			this.ccCharEditorController.configuration = _cfg;
			this.ccCharEditorController.initUi(param2);
			this.ccCharEditorController.addEventListener(CcCoreEvent.USER_WANT_TO_PREVIEW,this.switchToPreviewPage);
			this.ccCharEditorController.addEventListener(CcCoreEvent.USER_WANT_TO_MODIFY,this.switchToModifyPage);
			this.ccCharEditorController.addEventListener(CcCoreEvent.USER_WANT_TO_SAVE,this.onUserWantToSave);
			this._ccPreviewAndSaveController = new anifire.creator.core.CcPreviewAndSaveController();
			this._ccPreviewAndSaveController.configuration = _cfg;
			this.ccPreviewAndSaveController.initUi(param3);
			this.ccPreviewAndSaveController.addEventListener(CcCoreEvent.USER_WANT_TO_MODIFY,this.switchToModifyPage);
			this.ccPreviewAndSaveController.addEventListener(CcCoreEvent.USER_WANT_TO_SAVE,this.onUserWantToSave);
			this.loadTheme();*/
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
			this.theme = new Theme();
			this.theme.addEventListener(Event.COMPLETE, this.onLoadThemeComplete);
			this.theme.loadTheme(themeId);
		}
		
		/**
		 * 2nd step: get the cc theme (duh)
		 * @param event
		 */		
		private function onLoadThemeComplete(event:Event) : void
		{
			
		}
		
		/**
		 * 3rd step: request all of the custom characters
		 * @param event
		 */		
		private function onLoadCcThemeComplete() : void
		{
			/*(event.target as IEventDispatcher).removeEventListener(event.type, this.onLoadCcThemeComplete);
			var _loc1_:URLVariables = new URLVariables();
			_configManager.appendURLVariables(_loc1_);
			var _loc2_:UtilURLStream = new UtilURLStream();
			_loc2_.addEventListener(Event.COMPLETE,this.onLoadUserCharsComplete);
			//_loc2_.addEventListener(UtilURLStream.TIME_OUT,this.onLoadCharacterError);
			//_loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadCharacterError);
			//_loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadCharacterError);
			_loc1_["count"] = 1000;
			_loc1_["page"] = 0;
			_loc1_["type"] = "char";
			_loc1_["themeId"] = this.themeId;
			var _loc3_:URLRequest = new URLRequest(ServerConstants.ACTION_GET_USER_ASSETS_XML);
			_loc3_.data = _loc1_;
			_loc3_.method = URLRequestMethod.POST;
			_loc2_.load(_loc3_);*/
		}
		
		/**
		 * called when the cc theme is loaded, begins to load all the browser stuff
		 * @param event
		 */		
		private function onLoadUserCharsComplete(event:Event) : void
		{
			/*(event.target as IEventDispatcher).removeEventListener(event.type, this.onLoadUserCharsComplete);
			// pass everything along to the browser controller
			this.browserController = new BrowseUIController(this.theme, this.ccTheme, this.browseUI);
			this.eventDispatcher.dispatchEvent(new CcCoreEvent(CcCoreEvent.LOAD_EVERYTHING_COMPLETE, this));*/
		}
	}
}