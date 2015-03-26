package application.appui
{
	import com.frameWork.uiComponent.Alert;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.events.FlexEvent;
	import mx.graphics.codec.PNGEncoder;
	
	import application.AppReg;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.proxy.AppDataProxy;
	import application.utils.ExportTexturesUtils;
	import application.utils.MapUtils;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.MainUIControllerBase;
	import gframeWork.uiController.UserInterfaceManager;
	
	import starling.utils.formatString;
	
	/**
	 * 主界面上的菜单处理栏 
	 * @author JiangTao
	 */	
	public class TopUIPanelControler extends MainUIControllerBase
	{
		public function TopUIPanelControler() {
			super();
			autoClose = false;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			ui.btnNew.addEventListener(MouseEvent.CLICK,newClickHandler,false,0,true);
			ui.btnOpen.addEventListener(MouseEvent.CLICK,openClickHandler,false,0,true);
			ui.exportFile.addEventListener(MouseEvent.CLICK,exportClickHandler,false,0,true);
			ui.btnExportTextures.addEventListener(MouseEvent.CLICK,exportTexturesHandler,false,0,true);
			ui.saveFile.addEventListener(MouseEvent.CLICK,saveClickHandler,false,0,true);
			ui.QuickSaveFile.addEventListener(MouseEvent.CLICK,quickSaveClickHandler,false,0,true);
			ui.outputRoad.addEventListener(MouseEvent.CLICK,outputRoadHandler,false,0,true);
			ui.checkVisualAllRoad.addEventListener(Event.CHANGE,visualAllRoad,false,0,true);
			ui.btnTestRoad.addEventListener(MouseEvent.CLICK,roadTestHandler,false,0,true);
			ui.btnTestPathNode.addEventListener(MouseEvent.CLICK,pathNodeTestHandler,false,0,true);
		}
		
		//是否显示全部路径
		private function visualAllRoad(event:Event):void {
			appData.IS_DRAW_ALL_ROAD = ui.checkVisualAllRoad.selected;
			if(mapEditor && mapEditor.ui) {
				mapEditor.smartDrawroad();
			}
		}
		
		private function pathNodeTestHandler(event:MouseEvent):void {
			UserInterfaceManager.open(AppReg.PATH_TEST);
		}
		
		private function roadTestHandler(event:MouseEvent):void {
			UserInterfaceManager.open(AppReg.ROAD_SEARCH);
		}
		
		private function outputRoadHandler(event:MouseEvent):void {
			UserInterfaceManager.open(AppReg.ROAD_OUTPUT);
		}
		
		private function saveClickHandler(event:MouseEvent):void {
			appDataProxy.saveMapEditorFile(AppDataProxy.SAVE);
		}
		
		private function quickSaveClickHandler(event:MouseEvent):void {
			appDataProxy.saveMapEditorFile(AppDataProxy.SAVE_QUICK);
		}
		
		private function newClickHandler(event:Event):void {
			UserInterfaceManager.open(AppReg.CREATE_NEW_MAP);	
		}
		
		private function openClickHandler(event:Event):void {
			appDataProxy.openFileData();
		}
		
		private function exportClickHandler(event:Event):void {
			ExportTexturesUtils.exportToGameFile();
		}
		
		private function exportTexturesHandler(event:Event):void {
			var chrooseFolder:Function = function(event:Event):void {
				fileSelect.removeEventListener(Event.SELECT,chrooseFolder);
				if(ExportTexturesUtils.exportTextures(fileSelect.nativePath)) {
					var mapsDirector:File = new File(fileSelect.nativePath + "\\maps");
					if(!mapsDirector.exists) {
						mapsDirector.createDirectory();
					}
					
					var EW:int = appData.mapBit.width >> 1;
					var EH:int = appData.mapBit.height >> 1;
					for(var i:int = 0; i != 2; i++) {
						for(var j:int = 0; j != 2; j++) {
							var cellBit:BitmapData = new BitmapData(EW,EH);
							cellBit.copyPixels(appData.mapBit,new Rectangle(j * EW,i * EH,EW,EH),new Point());
							
							var fileStream:FileStream = new FileStream();
							var pngCode:PNGEncoder = new PNGEncoder();
							var fileBytes:ByteArray = pngCode.encode(cellBit);
							var file:File = new File(mapsDirector.nativePath + formatString("\\map_{0}_{1}.png",j,i));
							fileStream.open(file,FileMode.WRITE);
							fileStream.writeBytes(fileBytes);
							fileStream.close();
						}
					}
					
					trace("export succeed");
				}
			};
			var fileSelect:File = new File();
			fileSelect.addEventListener(Event.SELECT,chrooseFolder);
			fileSelect.browseForDirectory("选择要导出的纹理目录");
		}
		
		private function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
		}
		
		public override function dispose():void {
			super.dispose();
		}
		
		public function get ui():TopUIPanel {
			return mGUI as TopUIPanel
		}
	}
}