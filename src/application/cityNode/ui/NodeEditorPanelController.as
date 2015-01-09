package application.cityNode.ui
{
	import com.frameWork.gestures.DragGestures;
	import com.frameWork.gestures.MovedGestures;
	import com.frameWork.uiControls.UIMoudle;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.FlexGlobals;
	
	import application.AppReg;
	import application.ApplicationMediator;
	import application.utils.appData;
	
	import gframeWork.uiController.UserInterfaceManager;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	
	/**
	 * 城市节点编辑控制逻辑 
	 * @author JiangTao
	 * 
	 */	
	public class NodeEditorPanelController extends UIMoudle
	{
		//中心线原点
		private var pt:Point = new Point(150,200);
		private var uiSize:Rectangle = null;
		
		//label拖拽
		private var labelMoveGesture:DragGestures;
		//火拖拽
		private var freeMoveGesture:DragGestures;
		
		public function NodeEditorPanelController() {
			super();
			smartClose = false;
			gcDelayTime = 0.01;
		}
		
		protected override function uiCreateComplete(event:Event):void {
			super.uiCreateComplete(event);
			uiContent.x = left;
			uiContent.y = top;
			uiSize = getSize();
			ui.setSize(uiSize.width,uiSize.height);
			ui.drawBackground(uiSize,pt);
			ui.drawImage();
			ui.btnClose.addEventListener(Event.TRIGGERED,closeClickHandler);
			Starling.current.stage.addEventListener(Event.RESIZE,onResizeHandler);
			layoutUpdate();
			labelMoveGesture = new DragGestures(ui.txtName,labelDragOver);
			freeMoveGesture = new DragGestures(ui.free,freeDragOver);
		}
		
		//刷新显示
		public function refhresh():void {
			layoutUpdate();
			ui.drawImage();
		}
		
		/**
		 * label标签拖拽处理 
		 */		
		private function labelDragOver():void {
			appData.editorCityNode.labelX = ui.txtName.x;
			appData.editorCityNode.labelY = ui.txtName.y;
		}
		
		/**
		 * 火拖拽处理  
		 */		
		private function freeDragOver():void {
			appData.editorCityNode.freeX = ui.free.x;
			appData.editorCityNode.freeY = ui.free.y;
		}
		
		private function closeClickHandler(event:Event):void {
			UIMoudleManager.closeUIById(AppReg.EDITOR_CITY_NODE_PANEL);
		}
		
		private function onResizeHandler(event:Event):void {
			ui.drawBackground(getSize(),pt);
		}
		
		public override function dispose():void {
			Starling.current.stage.removeEventListener(Event.RESIZE,onResizeHandler);
			if(labelMoveGesture) labelMoveGesture.dispose();
			if(freeMoveGesture) freeMoveGesture.dispose();
			super.dispose();
		}
		
		private function getSize():Rectangle {
			var w:int = Starling.current.stage.stageWidth - left - right;
			var h:int = Starling.current.stage.stageHeight - top - bottom;
			return new Rectangle(left,top,w,h);
		}
		
		private function layoutUpdate():void {
			ui.contentSprite.x = pt.x;
			ui.contentSprite.y = pt.y;
			
			ui.free.x = appData.editorCityNode.freeX;
			ui.free.y = appData.editorCityNode.freeY;
			
			ui.txtName.x = appData.editorCityNode.labelX;
			ui.txtName.y = appData.editorCityNode.labelY;
			
			ui.btnClose.x = uiSize.width - ui.btnClose.width - 5;
			ui.btnClose.y = 5;
		}
		
		public override function close():void {
			super.close();
			Facade.getInstance().sendNotification(ApplicationMediator.UPDATE_MAP_ALL_CITY);
		}
		
		private function get ui():NodeEditorPanel {
			return uiContent as NodeEditorPanel;
		}
		
		private function get right():int {
			return 200;
		}
		
		private function get bottom():int {
			return 0;
		}
		
		private function get left():int {
			return UserInterfaceManager.getUIByID(AppReg.CITY_NODE_TEMP_PANEL).getGui().width;
		}
		
		private function get top():int {
			return UserInterfaceManager.getUIByID(AppReg.TOP_UI_PANEL).getGui().height;
		}
	}
}