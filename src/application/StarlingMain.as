package application
{
	import com.gskinner.motion.GTween;
	
	import flash.display.Stage;
	
	import application.utils.appData;
	import application.utils.appDataProxy;
	
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
		/*功能模块快速注册*/
		private static var app:AppReg;
		public static function init(stage:Stage,onCompleteHandler:Function):void
		{
			var startComplete:Function = onCompleteHandler;
			//starling成功启动了回调处理
			var stage3dComplete:Function = function(event:Event):void {
				GTween.staticInit();	//启动GT
				internalInit();
				if(startComplete != null) startComplete();	//回调处理
			};
			
			//启动starling
			sl = new Starling(StarlingMain,stage);
			sl.addEventListener(Event.ROOT_CREATED,stage3dComplete);
			sl.start();
		}
		
		public function StarlingMain() {
			super();
		}
		
		private static function internalInit():void {
			app = new AppReg();
			appDataProxy.internalInit();
			appData.textureManager.enqueue("assets/default_city_node.png");
			appData.textureManager.enqueue("assets/WarEffect.png");
			appData.textureManager.enqueue("assets/WarEffect.xml");
			appData.textureManager.loadQueue(function(ratio:Number):void{
				if(ratio == 1) {
					trace("load textures complete");
					trace("=============================")
				}
			});
		}
	}
}