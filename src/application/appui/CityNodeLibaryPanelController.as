package application.appui
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.IItemRenderer;
	
	import application.appui.itemRenderer.CityNodeLibaryItemRenderer;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	public class CityNodeLibaryPanelController extends MainUIControllerBase
	{
		public function CityNodeLibaryPanelController()
		{
			super();
			mDieTime = -1;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			mGUI.top = 50;
			mGUI.left = 0;
			ui.btnRefreshLibyary.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			updateDataProvider();
		}
		
		private function clickHandler(event:MouseEvent):void {
			appDataProxy.refreshCityLibary();
		}
		
		/**
		 * 更新模板数据显示 
		 */		
		public function updateDataProvider():void {
			if(ui.initialized) {
				var dbList:ArrayCollection = new ArrayCollection(appData.cityNodeTemps);
				ui.nodeList.dataProvider = dbList;
			}
		}
		
		public override function dispose():void {
			ui.btnRefreshLibyary.removeEventListener(MouseEvent.CLICK,clickHandler);
			super.dispose();
		}
		
		public function get ui():CityNodeLibaryPanel {
			return mGUI as CityNodeLibaryPanel;
		}
	}
}