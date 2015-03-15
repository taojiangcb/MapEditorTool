package application.appui
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	import application.db.CityNodeVO;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.UserInterfaceManager;
	import gframeWork.uiController.WindowUIControllerBase;
	
	import starling.core.Starling;
	import starling.utils.formatString;
	
	public class CityRoadPanelController extends WindowUIControllerBase
	{
		
		//excel文件
		private var excel:ExcelFile;
		private var sheel:Sheet;
		private var saveFile:File;
		
		public function CityRoadPanelController() {
			super();
			mDieTime = 20;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			ui.btnClose.addEventListener(MouseEvent.CLICK,closeHandler);
			ui.btnExportExcel.addEventListener(MouseEvent.CLICK,exportExcelHandler);
			var title:String = "fromId				toId\n"
			var lineFormat:String = "{0}:({1})		{2}:({3})\n";
			var i:int = appData.mapCityNodes.length;
			var mapCityNode:CityNodeVO;
			var toCityNode:CityNodeVO;
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
		
		/**
		 * 将数据出成excel文档 
		 * @param event
		 * 
		 */		
		private function exportExcelHandler(event:MouseEvent):void {
			
			const defaultDisatnce:int = 100;
			
			excel = new ExcelFile();
			sheel = new Sheet();
			sheel.header = "mapCityRoad";
			sheel.resize(10000,3);
			excel.sheets.addItem(sheel);
			
			sheel.setCell(0,0,"fromId");
			sheel.setCell(0,1,"toId");
			sheel.setCell(0,2,"distance");
			
			var rows:int = 1;
			var columns:int = 0;
			var iLen:int = appData.mapCityNodes.length;
			var mapCityNode:CityNodeVO;
			var toCityNode:CityNodeVO;
			
			var i:int = 0;
			for(i; i != iLen; i++) {
				mapCityNode = appData.mapCityNodes[i];
				var j:int = mapCityNode.toCityIds.length;
				while(--j > -1) {
					toCityNode = appDataProxy.getCityNodeInfoByTemplateId(mapCityNode.toCityIds[j]);
					sheel.setCell(rows,0,mapCityNode.templateId);
					sheel.setCell(rows,1,mapCityNode.toCityIds[j]);
					sheel.setCell(rows,2,defaultDisatnce);
					rows++;
				}
			}
			
			var fileBytes:ByteArray = excel.saveToByteArray();
			saveFile = new File();
			saveFile.save(fileBytes,"road.xls");
			
			UserInterfaceManager.close(AppReg.ROAD_OUTPUT);
		}
		
		protected override function openRefresh():void {
			super.openRefresh();
			Starling.current.stop();
		}
		
		public override function hide():void {
			super.hide();
			Starling.current.start();
		}
		
		private function closeHandler(event:MouseEvent):void {
			UserInterfaceManager.close(AppReg.ROAD_OUTPUT);
		}
		
		private function get ui():CityRoadPanel {
			return mGUI as CityRoadPanel;
		}
	}
}