package application.appui
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	import application.db.MapCityNodeVO;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.UserInterfaceManager;
	import gframeWork.uiController.WindowUIControllerBase;
	
	import starling.utils.formatString;
	
	public class CityRoadPanelController extends WindowUIControllerBase
	{
		public function CityRoadPanelController() {
			super();
			mDieTime = 20;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			ui.btnClose.addEventListener(MouseEvent.CLICK,closeHandler);
			var title:String = "fromId				toId\n"
			var lineFormat:String = "{0}:({1})		{2}:({3})\n";
			var i:int = appData.mapCityNodes.length;
			var mapCityNode:MapCityNodeVO;
			var toCityNode:MapCityNodeVO;
			var outputContent:String = title;
			while(--i > -1) {
				mapCityNode = appData.mapCityNodes[i];
				var j:int = mapCityNode.toCityIds.length;
				while(--j > -1) {
					toCityNode = appDataProxy.getCityNodeInfoByTemplateId(mapCityNode.toCityIds[j]);
					outputContent += formatString(lineFormat,mapCityNode.templateId,mapCityNode.cityName,toCityNode.templateId,toCityNode.cityName); 
				}
			}
			ui.txtOutput.text = outputContent;
		}
		
		private function closeHandler(event:MouseEvent):void {
			UserInterfaceManager.close(AppReg.ROAD_OUTPUT);
		}
		
		private function get ui():CityRoadPanel {
			return mGUI as CityRoadPanel;
		}
	}
}