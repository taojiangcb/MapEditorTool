package application.appui
{
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.IItemRenderer;
	
	import application.appui.itemRenderer.CityNodeLibaryItemRenderer;
	import application.utils.appData;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	public class CityNodeLibaryPanelController extends MainUIControllerBase
	{
		public function CityNodeLibaryPanelController()
		{
			super();
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			mGUI.top = 50;
			mGUI.left = 0;
			updateDataProvider();
		}
		
		/**
		 * 更新模板数据显示 
		 */		
		public function updateDataProvider():void {
			var dbList:ArrayCollection = new ArrayCollection(appData.cityNodeTemps);
			ui.nodeList.dataProvider = dbList;
		}
		
		public function get ui():CityNodeLibaryPanel {
			return mGUI as CityNodeLibaryPanel;
		}
	}
}