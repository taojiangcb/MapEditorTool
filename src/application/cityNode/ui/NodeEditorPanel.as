package application.cityNode.ui
{
	import flash.geom.Rectangle;
	
	import application.AppReg;
	import application.appui.CityNodeLibaryPanel;
	
	import gframeWork.uiController.UserInterfaceManager;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class NodeEditorPanel extends Sprite
	{
		private var bg:Quad;
		public function NodeEditorPanel() {
			super();
			listener();
			createChildren();
		}
		
		private function createChildren():void {
			
		}
		
		private function installBackground():void {
			var sizeRect:Rectangle = getSize();
			if(bg) bg.removeFromParent(true);
			bg = new Quad(sizeRect.width,sizeRect.height,0xFFF9F9F9);
			addChild(bg);
		}
		
		private function listener():void {
			Starling.current.stage.addEventListener(Event.RESIZE,onResizeHandler);
		}
		
		private function rmListeners():void{
			Starling.current.stage.removeEventListeners(Event.RESIZE);
		}
		
		private function onResizeHandler(event:Event):void {
			
		}
		
		private function getSize():Rectangle {
			var left:int = UserInterfaceManager.getUIByID(AppReg.CITY_NODE_TEMP_PANEL).getGui().width;
			var top:int = UserInterfaceManager.getUIByID(AppReg.TOP_UI_PANEL).getGui().height;
			var right:int = 200;
			var bottom:int = 0;
			var w:int = Starling.current.stage.stageWidth - left - right;
			var h:int = Starling.current.stage.stageHeight - top - bottom;
			return new Rectangle(left,top,w,h);
		}
		
		public override function dispose():void {
			rmListeners();
			super.dispose();
		}
	}
}