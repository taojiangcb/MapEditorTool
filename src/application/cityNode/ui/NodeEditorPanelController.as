package application.cityNode.ui
{
	import com.frameWork.uiControls.UIMoudle;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.FlexGlobals;
	
	import application.AppReg;
	
	import gframeWork.uiController.UserInterfaceManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class NodeEditorPanelController extends UIMoudle
	{
		private var pt:Point = new Point(150,200);
		private var uiSize:Rectangle = null;
		public function NodeEditorPanelController() {
			super();
			smartClose = false;
		}
		
		protected override function uiCreateComplete(event:Event):void {
			super.uiCreateComplete(event);
			uiContent.x = left;
			uiContent.y = top;
			uiSize = getSize();
			ui.setSize(uiSize.width,uiSize.height);
			ui.drawBackground(uiSize,pt);
			ui.btnClose.addEventListener(Event.TRIGGERED,closeClickHandler);
			Starling.current.stage.addEventListener(Event.RESIZE,onResizeHandler);
			layoutUpdate();
		}
		
		private function closeClickHandler(event:Event):void {
			UIMoudleManager.closeUIById(AppReg.EDITOR_CITY_NODE_PANEL);
		}
		
		private function onResizeHandler(event:Event):void {
			ui.drawBackground(getSize(),pt);
			trace(Starling.current.stage.stageWidth,Starling.current.stage.stageHeight);
		}
		
		public override function dispose():void {
			Starling.current.stage.removeEventListener(Event.RESIZE,onResizeHandler);
			super.dispose();
		}
		
		private function get ui():NodeEditorPanel {
			return uiContent as NodeEditorPanel;
		}
		
		private function getSize():Rectangle {
			var w:int = Starling.current.stage.stageWidth - left - right;
			var h:int = Starling.current.stage.stageHeight - top - bottom;
			return new Rectangle(left,top,w,h);
		}
		
		private function layoutUpdate():void {
			ui.image.x = pt.x;
			ui.image.y = pt.y;
			
			ui.btnClose.x = uiSize.width - ui.btnClose.width - 5;
			ui.btnClose.y = 5;
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