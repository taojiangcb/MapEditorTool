package application
{
	import com.frameWork.uiControls.UIMoudle;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import application.appui.CityNodeLibaryPanel;
	import application.appui.CityNodeLibaryPanelController;
	import application.appui.CityPropertieController;
	import application.appui.CityPropertiePanel;
	import application.appui.CityRoadPanel;
	import application.appui.CityRoadPanelController;
	import application.appui.CreateNewMapPanel;
	import application.appui.CreateNewMapPanelController;
	import application.appui.RoadTestPanel;
	import application.appui.RoadTestPanelController;
	import application.appui.TopUIPanel;
	import application.appui.TopUIPanelControler;
	import application.cityNode.ui.NodeEditorPanel;
	import application.cityNode.ui.NodeEditorPanelController;
	import application.mapEditor.ui.MapEditorPanel;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.proxy.AppDataProxy;
	import application.proxy.RoadDataProxy;
	import application.roadPathTest.TestPointInLineController;
	import application.roadPathTest.TestPointInLinePanel;
	import application.utils.appData;
	
	import gframeWork.uiController.UserInterfaceManager;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class AppReg
	{
		
		/**
		 * 菜单栏 
		 */		
		public static const TOP_UI_PANEL:int = 1;
		
		/**
		 * 城市模板库
		 */		
		public static const CITY_NODE_TEMP_PANEL:int = 2;
		
		/**
		 * 城市节点编辑
		 */		
		public static const CITY_EDIT_PROPERTIES:int = 3;
		
		/**
		 * 创建地图面版 
		 */		
		public static const CREATE_NEW_MAP:int = 201;
		
		/**
		 * 道路数据输出 
		 */		
		public static const ROAD_OUTPUT:int = 202;
		
		/**
		 * 编辑城市节点的面板 
		 */		
		public static const EDITOR_CITY_NODE_PANEL:int = 301;
		
		/**
		 * 编辑大地图 
		 */		
		public static const EDITOR_MAP_PANEL:int = 302;
		
		/**
		 * 测试寻路 
		 */		
		public static const ROAD_SEARCH:int = 303;
		
		/**
		 * 测试路径 
		 */		
		public static const PATH_TEST:int = 304;
		
		public function AppReg() {
			installDataProxy();
			installUIMoudle(); 
			installDataMediator();
		}
		
		private function installDataProxy():void {
			Facade.getInstance().registerProxy(new AppDataProxy(AppDataProxy.NAME));
			Facade.getInstance().registerProxy(new RoadDataProxy(RoadDataProxy.NAME));
		}
		
		private function installUIMoudle():void {
			UserInterfaceManager.registerGUI(TOP_UI_PANEL,TopUIPanel,TopUIPanelControler);
			UserInterfaceManager.registerGUI(CREATE_NEW_MAP,CreateNewMapPanel,CreateNewMapPanelController);
			UserInterfaceManager.registerGUI(CITY_NODE_TEMP_PANEL,CityNodeLibaryPanel,CityNodeLibaryPanelController);
			UserInterfaceManager.registerGUI(CITY_EDIT_PROPERTIES,CityPropertiePanel,CityPropertieController);
			UserInterfaceManager.registerGUI(ROAD_OUTPUT,CityRoadPanel,CityRoadPanelController);
			UserInterfaceManager.registerGUI(ROAD_SEARCH,RoadTestPanel,RoadTestPanelController);
			UserInterfaceManager.registerGUI(PATH_TEST,TestPointInLinePanel,TestPointInLineController);
			
			UIMoudleManager.registerUIMoudle(EDITOR_CITY_NODE_PANEL,NodeEditorPanelController,NodeEditorPanel);
			UIMoudleManager.registerUIMoudle(EDITOR_MAP_PANEL,MapEditorPanelConstroller,MapEditorPanel);
		}
		
		private function installDataMediator():void {
			Facade.getInstance().registerMediator(new ApplicationMediator());
		}
	}
}