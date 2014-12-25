package application
{
	import com.gskinner.motion.GTween;
	
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Starling启动的主类 
	 * @author JiangTao
	 */	
	public class StarlingMain extends Sprite
	{
		private static var sl:Starling;
		public static function init(stage:Stage,onCompleteHandler:Function):void
		{
			var startComplete:Function = onCompleteHandler;
			//starling成功启动了回调处理
			var stage3dComplete:Function = function(event:Event):void {
				GTween.staticInit();	//启动GT
				if(startComplete != null) startComplete();	//回调处理
			};
			
			//启动starling
			sl = new Starling(StarlingMain,stage);
			sl.addEventListener(Event.ROOT_CREATED,stage3dComplete);
			sl.start();
		}
		
		public function StarlingMain() {
			super();
			internalInit();
		}
		
		private function internalInit():void {
			//test starling
//			var quad:Quad = new Quad(200,200,0xFFFF0000);
//			addChild(quad);
		}
	}
}