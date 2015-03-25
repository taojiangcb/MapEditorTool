package application.appui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.utils.appData;
	
	import gframeWork.uiController.WindowUIControllerBase;
	
	public class TestPointInLineController extends WindowUIControllerBase
	{
		public function TestPointInLineController() {
			super();
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			
			addEventListener(MouseEvent.MOUSE_MOVE,moveHandler,false,0,true);
			addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,0,true);
		}
		
		private function moveHandler(event:MouseEvent):void {
			
		}
		
		private function enterFrameHandler(event:Event):void {
			
		}
	}
}