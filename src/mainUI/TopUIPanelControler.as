package mainUI
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	
	import gframeWork.uiController.MainUIControllerBase;
	import gframeWork.uiController.UserInterfaceManager;
	
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
			ui.btnExport.addEventListener(MouseEvent.CLICK,exportClickHandler,false,0,true);
		}
		
		private function newClickHandler(event:Event):void {
			UserInterfaceManager.open(AppReg.CREATE_NEW_MAP);	
		}
		
		private function openClickHandler(event:Event):void {
			
		}
		
		private function exportClickHandler(event:Event):void {
			
		}
		
		public override function dispose():void {
			super.dispose();
		}
		
		public function get ui():TopUIPanel {
			return mGUI as TopUIPanel
		}
	}
}