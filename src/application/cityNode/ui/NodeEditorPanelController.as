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
		//旗子拖拽
		private var flagMoveGesture:DragGestures;
		//按钮
		private var menuMoveGesture:DragGestures;
		
		public function NodeEditorPanelController() {
			super();
			smartClose = false;
			gcDelayTime = -1;
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
			
			ui.checkFlag.addEventListener(Event.CHANGE,visualFlagHandler);
			ui.checkFree.addEventListener(Event.CHANGE,visualFreeHandler);
			ui.checkMenu.addEventListener(Event.CHANGE,visualMenHandler);
			
			Starling.current.stage.addEventListener(Event.RESIZE,onResizeHandler);
			layoutUpdate();
			
			labelMoveGesture = new DragGestures(ui.txtName,labelDragOver);
			freeMoveGesture = new DragGestures(ui.free,freeDragOver);
			flagMoveGesture = new DragGestures(ui.nationFlag,falgDragOver);
			menuMoveGesture = new DragGestures(ui.menuImg,menuDragOver);
		}
		
		private function visualFlagHandler(event:Event):void {
			ui.nationFlag.visible = ui.checkFlag.isSelected;
		}
		
		private function visualFreeHandler(event:Event):void {
			ui.free.visible = ui.checkFree.isSelected;
		}
		
		private function visualMenHandler(event:Event):void {
			ui.menuImg.visible = ui.checkMenu.isSelected;
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
			appData.editorCityNode.labelX = Math.round(ui.txtName.x);
			appData.editorCityNode.labelY = Math.round(ui.txtName.y);
		}
		
		/**
		 * 火拖拽处理  
		 */		
		private function freeDragOver():void {
			appData.editorCityNode.freeX = Math.round(ui.free.x);
			appData.editorCityNode.freeY = Math.round(ui.free.y);
		}
		
		private function falgDragOver():void {
			appData.editorCityNode.flagX = Math.round(ui.nationFlag.x);
			appData.editorCityNode.flagY = Math.round(ui.nationFlag.y);
		}
		
		private function menuDragOver():void {
			appData.editorCityNode.menuX = Math.round(ui.menuImg.x);
			appData.editorCityNode.menuY = Math.round(ui.menuImg.y);
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
			
			ui.nationFlag.x = appData.editorCityNode.flagX;
			ui.nationFlag.y = appData.editorCityNode.flagY;
			
			ui.menuImg.x = appData.editorCityNode.menuX;
			ui.menuImg.y = appData.editorCityNode.menuY;
			
			if(uiSize) {
				ui.btnClose.x = uiSize.width - ui.btnClose.width - 5;
				ui.btnClose.y = 5;
				
				ui.checkFlag.x = ui.btnClose.x - 30;
				ui.checkFlag.y = ui.btnClose.y + 30;
				
				ui.checkFree.x = ui.btnClose.x - 30;
				ui.checkFree.y = ui.checkFlag.y + 30;
				
				ui.checkMenu.x = ui.btnClose.x - 30;
				ui.checkMenu.y = ui.checkFree.y + 30;
			}
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