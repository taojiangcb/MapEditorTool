package application.mapEditor.comps
{
	
	
	import com.frameWork.uiControls.UIMoudleManager;
	
	import application.AppReg;
	import application.ApplicationMediator;
	import application.db.RoadPathNodeVO;
	import application.mapEditor.ui.DragCityGestures;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.utils.appData;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class MapRoadNodeComp extends Sprite
	{
		/**
		 * 节点图片 
		 */		
		private var img:Image;
		
		/**
		 * 节点信息 
		 */		
		private var roadNodeInfo:RoadPathNodeVO;
		
		/**
		 * 拖拽 
		 */		
		private var drag:DragCityGestures;
		
		public function MapRoadNodeComp(roadNodeData:RoadPathNodeVO) {
			super();
			roadNodeInfo = roadNodeData;
			internalInit();
		}
		
		private function internalInit():void {
			img = new Image(appData.textureManager.getTexture("page-indicator-selected-skin"));
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;
			addChild(img);
			drag = new DragCityGestures(this,dragHandler);
		}
		
		private function dragHandler():void {
			if(roadNodeInfo) {
				roadNodeInfo.x = x;
				roadNodeInfo.y = y;
				
				Facade.getInstance().sendNotification(ApplicationMediator.DRAW_ROAD);
			}
		}
		
		public override function dispose():void {
			if(drag) drag.dispose();
			if(img) img.removeFromParent(true);
			super.dispose();
		}
		
		public function get roadPathNodeInfo():RoadPathNodeVO {
			return roadNodeInfo;
		}
		
		public function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
		}
	}
}