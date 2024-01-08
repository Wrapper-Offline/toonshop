package toonshop.creator.controllers
{
	/*import toonshop.browser.core.CharThumb;
	import toonshop.browser.models.ThumbModel;
	import toonshop.browser.core.Theme;
	import toonshop.browser.models.CharacterExplorerCollection;
	
	import toonshop.creator.models.CcTheme;*/
	
	import toonshop.creator.interfaces.IBrowseUIContainer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Label;
	
	public class BrowseUIController
	{
		/*private var _themeCharacterCollection:CharacterExplorerCollection;
		private var ui:ICcBrowserContainer;
		private var studioTheme:Theme;
		private var ccTheme:CcTheme;*/
		
		public function CcBrowserController(
			//studioTheme:Theme,
			//ccTheme:CcTheme,
			ui:IBrowseUIContainer
		)
		{
			/*// store the character list
			this._themeCharacterCollection = new CharacterExplorerCollection(studioTheme);
			// add all the character thumbnails
			var totalChars:int = studioTheme.charThumbs.length;
			var index:int = 0;
			while (index < totalChars)
			{
			var character:CharThumb = studioTheme.charThumbs.getValueByIndex(index) as CharThumb;
			if (character.enable)
			{
			var thumbnail:ThumbModel = new ThumbModel(character, character.firstColorSetId);
			thumbnail.isStoreCharacter = true;
			this._themeCharacterCollection.addProduct(thumbnail);
			}
			index++;
			}
			this._themeCharacterCollection.sortByCategoryName();
			if (Boolean(studioTheme.ccThemeId) && this._themeCharacterCollection.nextUserCharacterPage == 0)
			{
			this._themeCharacterCollection.addEventListener(ProductGroupCollectionEvent.THEME_CHAR_COMPLETE, this.onUserCCLoaded);
			this._themeCharacterCollection.loadNextPage();
			return;
			}
			
			ui.ui_stockChars.dataProvider = new ArrayCollection([label1, label2]);*/
			
		}
	}
}
