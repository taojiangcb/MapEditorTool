package application
{
	import application.mainUI.CreateNewMapPanel;
	import application.mainUI.CreateNewMapPanelController;
	import application.mainUI.TopUIPanel;
	import application.mainUI.TopUIPanelControler;
	import application.proxy.AppDataProxy;
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
		 * 创建地图面版 
		 */		
		public static const CREATE_NEW_MAP:int = 201;
		
		public function AppReg() {
			installDataProxy();
			installUIMoudle();
			installDataMediator();
		}
		
		private function installDataProxy():void {
			Facade.getInstance().registerProxy(new AppDataProxy(AppDataProxy.NAME));
		}
		
		private function installUIMoudle():void {
			UserInterfaceManager.registerGUI(TOP_UI_PANEL,TopUIPanel,TopUIPanelControler);
			UserInterfaceManager.registerGUI(CREATE_NEW_MAP,CreateNewMapPanel,CreateNewMapPanelController);
		}
		
		private function installDataMediator():void {
			Facade.getInstance().registerMediator(new ApplicationMediator());
		}
	}
}