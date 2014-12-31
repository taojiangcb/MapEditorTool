package application.appui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.UserInterfaceManager;
	import gframeWork.uiController.WindowUIControllerBase;
	
	/**
	 * 新建地图操作面板
	 * @author JiangTao
	 * 
	 */	
	public class CreateNewMapPanelController extends WindowUIControllerBase
	{
		private var selectFile:File;
		
		public function CreateNewMapPanelController()
		{
			super();
			mDieTime = 0;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			ui.btnCancel.addEventListener(MouseEvent.CLICK,cancelHandler,false,0,true);
			ui.btnOk.addEventListener(MouseEvent.CLICK,okHandler,false,0,true);
			ui.btnMapbrowser.addEventListener(MouseEvent.CLICK,selectMapFileHandler,false,0,true);
			ui.btnNodesbrowser.addEventListener(MouseEvent.CLICK,selectNodeHandler,false,0,true);
		}
		
		private function selectMapFileHandler(event:MouseEvent):void {
			var selectFunc:Function = function(event:Event):void {
				ui.txtMapPath.text = selectFile.nativePath;	
				selectFile.removeEventListener(Event.SELECT,selectFunc);
			};
			if(!selectFile) selectFile = new File();
			selectFile.browseForOpen("选择大地图图片",[new FileFilter("image","*.jpg"),new FileFilter("image","*.jpge")]);
			selectFile.addEventListener(Event.SELECT,selectFunc);
		}
		
		private function selectNodeHandler(event:MouseEvent):void {
			var selectFunc:Function = function(event:Event):void {
				ui.txtCityIconPat.text = selectFile.nativePath;	
				selectFile.removeEventListener(Event.SELECT,selectFunc);
			};
			if(!selectFile) selectFile = new File();
			selectFile.browseForDirectory("城市图标文件夹");
			selectFile.addEventListener(Event.SELECT,selectFunc);
		}
		
		private function cancelHandler(event:MouseEvent):void {
			UserInterfaceManager.close(AppReg.CREATE_NEW_MAP);	
		}
		
		private function okHandler(event:MouseEvent):void {
			appDataProxy.createNewMapData(ui.txtCityIconPat.text,ui.txtMapPath.text);
			UserInterfaceManager.close(AppReg.CREATE_NEW_MAP);
		}
		
		public override function dispose():void {
			ui.btnCancel.removeEventListener(MouseEvent.CLICK,cancelHandler);
			ui.btnOk.removeEventListener(MouseEvent.CLICK,okHandler);
			ui.btnMapbrowser.removeEventListener(MouseEvent.CLICK,selectMapFileHandler);
			ui.btnNodesbrowser.removeEventListener(MouseEvent.CLICK,selectNodeHandler);
			super.dispose();
		}
		
		public function get ui():CreateNewMapPanel {
			return mGUI as CreateNewMapPanel;
		}
	}
}