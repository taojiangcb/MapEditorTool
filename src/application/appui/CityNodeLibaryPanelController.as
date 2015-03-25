package application.appui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
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
			ui.btnRefreshLibyary.addEventListener(MouseEvent.CLICK,updateCityLib,false,0,true);
			ui.btnRefreshMap.addEventListener(MouseEvent.CLICK,updateMap,false,0,true);
			updateDataProvider();
		}
		
		private function updateCityLib(event:MouseEvent):void {
			appDataProxy.refreshCityLibary();
		}
		
		private function updateMap(event:MouseEvent):void {
			var chrooseFile:File = new File();
			var chrooseHandler:Function = function(event:Event):void {
				appDataProxy.updateMapFile(chrooseFile);
			}
			chrooseFile.addEventListener(Event.SELECT,chrooseHandler,false,0,true);
			chrooseFile.browseForOpen("选择背景图片",[new FileFilter(".jpg","*.jpg")]);
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
			ui.btnRefreshLibyary.removeEventListener(MouseEvent.CLICK,updateCityLib);
			ui.btnRefreshMap.removeEventListener(MouseEvent.CLICK,updateMap);
			super.dispose();
		}
		
		public function get ui():CityNodeLibaryPanel {
			return mGUI as CityNodeLibaryPanel;
		}
	}
}