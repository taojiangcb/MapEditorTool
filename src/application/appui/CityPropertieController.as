package application.appui
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	public class CityPropertieController extends MainUIControllerBase
	{
		public function CityPropertieController() 	{
			super();
			autoClose = false;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			ui.txtCityTempId.addEventListener(Event.CHANGE,tempIdChangeHandler,false,0,true);
			ui.txtName.addEventListener(Event.CHANGE,txtNameChangeHandler,false,0,true);
			ui.freeCheck.addEventListener(Event.CHANGE,freeChangelHandler,false,0,true);
			commitData();
		}
		
		public function commitData():void {
			if(chrooseCityComp && ui.initialized) {
				ui.txtName.text = chrooseCityComp.cityName;
				ui.txtCityTempId.text = chrooseCityComp.templateId.toString();
				ui.freeCheck.selected = chrooseCityComp.freeVisible;
			}
		}
		
		private function txtNameChangeHandler(event:Event):void {
			if(chrooseCityComp) {
				chrooseCityComp.cityName = ui.txtName.text;
			}
		}
		
		private function tempIdChangeHandler(event:Event):void {
			if(chrooseCityComp) {
				chrooseCityComp.templateId = int(ui.txtCityTempId.text);
			}
		}
		
		private function freeChangelHandler(event:Event):void {
			if(chrooseCityComp) {
				chrooseCityComp.freeVisible = !chrooseCityComp.freeVisible; 
			}
		}
	
		public function get ui():CityPropertiePanel {
			return mGUI as CityPropertiePanel;
		}
		
		/**
		 * 地图编辑 
		 * @return 
		 */		
		private function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller
		}
		
		private function get chrooseCityComp():MapCityNodeComp {
			return mapEditor.getChrroseCity();
		}
	}
}