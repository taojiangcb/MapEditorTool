package application.cfg
{
	
	import flash.ui.Keyboard;
	
	import application.mapEditor.ui.DragScrollGestures;
	
	import gframeWork.cfg.Shortcut;
	
	import starling.core.Starling;
	import starling.events.KeyboardEvent;

	/**
	 * 快捷开发时的功能测试 
	 * @author JiangTao
	 */	
	public class CfgKeyTest
	{
		public function CfgKeyTest()
		{
			if(Starling.current != null)
			{
				ShortuctKey.init(Starling.current.stage);
				ShortuctKey.start();
				listener();
			}
		}
		
		private function listener():void {
			ShortuctKey.register(Keyboard.SPACE,spaceDown,KeyboardEvent.KEY_DOWN);
			ShortuctKey.register(Keyboard.SPACE,spaceUp,KeyboardEvent.KEY_UP);
			
			
			ShortuctKey.register(Keyboard.CONTROL,controlDown,KeyboardEvent.KEY_DOWN);
			ShortuctKey.register(Keyboard.CONTROL,controlUp,KeyboardEvent.KEY_UP);
			
			ShortuctKey.register(Keyboard.SHIFT,shiftDown,KeyboardEvent.KEY_DOWN);
			ShortuctKey.register(Keyboard.SHIFT,shiftUp,KeyboardEvent.KEY_UP);
		}
		
		private function controlDown(event:KeyboardEvent):void {
			DragScrollGestures.ADD_PATH_JOIN = true;
		}
		
		private function controlUp(event:KeyboardEvent):void {
			DragScrollGestures.ADD_PATH_JOIN = false;
		}
		
		private function shiftDown(event:KeyboardEvent):void {
			DragScrollGestures.DEL_PATH_JOIN = true;
		}
		
		private function shiftUp(event:KeyboardEvent):void {
			DragScrollGestures.DEL_PATH_JOIN = false;
		}
		
		private function spaceDown(event:KeyboardEvent):void {
			DragScrollGestures.CAN_DRAG = true;
		}
		
		private function spaceUp(event:KeyboardEvent):void {
			DragScrollGestures.CAN_DRAG = false;
		}
	}
}