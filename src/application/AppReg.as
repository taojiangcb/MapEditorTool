package application
{
	import gframeWork.uiController.UserInterfaceManager;
	
	import mainUI.CreateNewMapPanelController;
	import mainUI.CreateNewMapPanel;
	import mainUI.TopUIPanel;
	import mainUI.TopUIPanelControler;

	public class AppReg
	{
		
		/**
		 * 菜单栏 
		 */		
		public static const TOP_UI_PANEL:int = 1;
		
		/**
		 * 创建地图面版 
		 */		
		public static const CREATE_NEW_MAP:int = 201;
		
		public function AppReg() {
			UserInterfaceManager.registerGUI(TOP_UI_PANEL,TopUIPanel,TopUIPanelControler);
			UserInterfaceManager.registerGUI(CREATE_NEW_MAP,CreateNewMapPanel,CreateNewMapPanelController);
		}
	}
}