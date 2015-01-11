package application
{
	import com.frameWork.uiControls.UIConstant;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Application;
	
	import application.cityNode.ui.NodeEditorPanelController;
	import application.db.CityNodeTempVO;
	import application.extendsCore.MediatorExpert;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.utils.appData;
	
	import gframeWork.uiController.UserInterfaceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends MediatorExpert
	{
		
		/**
		 * 新建一个地图数据文件 
		 */		
		public static const NEW_MAP_DATA_INIT:String = "newMapDataInit";
		
		/**
		 * 刷新当前地图上所有城市的节点显示 
		 */		
		public static const UPDATE_MAP_ALL_CITY:String = "updateMapAllCity";
		
		/**
		 * 编辑一个城市的模板 
		 */		
		public static const EDIT_CITY_TEMP:String = "editCityTemp";
		
		/**
		 * 选中地图上的一个城市 
		 */		
		public static const CHROOSE_MAP_CITY:String = "chrooseMapCity";
		
		public function ApplicationMediator(mediatorName:String=null, viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		protected override function installNoficationHandler():void {
			super.installNoficationHandler();
			putNotification(NEW_MAP_DATA_INIT,appNewDataInitComplete);
			putNotification(UPDATE_MAP_ALL_CITY,updateMapAllCity);
			putNotification(EDIT_CITY_TEMP,editorCityTemp);
			putNotification(CHROOSE_MAP_CITY,chrooseMapCity);
		}
		
		private function appNewDataInitComplete(notification:INotification):void {
			MapEditor(FlexGlobals.topLevelApplication).appStart();
		}
		
		private function updateMapAllCity(notification:INotification):void {
			var mapEditor:MapEditorPanelConstroller = UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
			if(mapEditor) {
				mapEditor.refreshAllCity();
			}
		}
		
		private function editorCityTemp(notification:INotification):void {
			appData.editorCityNode = notification.getBody() as CityNodeTempVO;
			var nodeEditorUI:NodeEditorPanelController = UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_CITY_NODE_PANEL) as NodeEditorPanelController;
			if(nodeEditorUI) {
				if(nodeEditorUI.uiState == UIConstant.OPEN) {
					nodeEditorUI.refhresh();
					return;
				}
			}
			UIMoudleManager.openUIByid(AppReg.EDITOR_CITY_NODE_PANEL);
		}
		
		private function chrooseMapCity(notification:INotification):void {
			var cityComp:MapCityNodeComp = notification.getBody() as MapCityNodeComp;
			var mapEditor:MapEditorPanelConstroller = UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
			if(mapEditor) {
				mapEditor.setChrooseCity(cityComp);
			}
			UserInterfaceManager.open(AppReg.CITY_EDIT_PROPERTIES);
		}
		
		public static function get NAME():String {
			return getQualifiedClassName(ApplicationMediator);
		}
	}
}