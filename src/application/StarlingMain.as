package application
{
	import com.gskinner.motion.GTween;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import application.utils.ExportTexturesUtils;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import source.feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * Starling启动的主类 
	 * @author JiangTao
	 */	
	public class StarlingMain extends Sprite
	{
		private static var sl:Starling;
		/*功能模块快速注册*/
		private static var app:AppReg;
		
		private static var appBeginFunc:Function;
		public static function init(stage:Stage,onCompleteHandler:Function):void
		{
			appBeginFunc = onCompleteHandler;
			//starling成功启动了回调处理
			var stage3dComplete:Function = function(event:Event):void {
				GTween.staticInit();	//启动GT
				internalInit();
			};
			
			Starling.multitouchEnabled = true;
			//启动starling
			sl = new Starling(StarlingMain,stage);
			sl.simulateMultitouch = true;
			sl.addEventListener(Event.ROOT_CREATED,stage3dComplete);
			sl.start();
			sl.showStats = true;
			sl.showStatsAt(HAlign.CENTER,VAlign.BOTTOM);
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
			appData.textureManager.enqueue("assets/FlagMap_han_9.png");
			appData.textureManager.enqueue("assets/img_city_move.png");
			appData.textureManager.loadQueue(function(ratio:Number):void{
				if(ratio == 1) {
					trace("load textures complete");
					trace("=============================")
					appData.skin = new MetalWorksMobileTheme();
					if(appBeginFunc != null) appBeginFunc();	
				}
			});
		}
	}
}