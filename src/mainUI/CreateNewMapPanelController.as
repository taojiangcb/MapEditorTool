package mainUI
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	
	import gframeWork.uiController.UserInterfaceManager;
	import gframeWork.uiController.WindowUIControllerBase;
	
	/**
	 * 新建地图操作面板
	 * @author JiangTao
	 * 
	 */	
	public class CreateNewMapPanelController extends WindowUIControllerBase
	{
		public function CreateNewMapPanelController()
		{
			super();
			mDieTime = 0;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			ui.btnCancel.addEventListener(MouseEvent.CLICK,cancelHandler,false,0,true);
		}
		
		private function cancelHandler(event:MouseEvent):void {
			UserInterfaceManager.close(AppReg.CREATE_NEW_MAP);	
		}
		
		public override function dispose():void {
			super.dispose();
		}
		
		public function get ui():CreateNewMapPanel {
			return mGUI as CreateNewMapPanel;
		}
	}
}