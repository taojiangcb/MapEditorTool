package application.proxy
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import application.utils.appData;
	
	import gframeWork.url.URLFileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AppDataProxy extends Proxy
	{
		//默认的城市节点
		private var defaultCityNodeFile:URLFileReference;
		private var defaultCityNodeLoad:Loader;
		
		public function AppDataProxy(proxyName:String=null, data:Object=null){
			super(proxyName, data);
			internalInit();
		}
		
		private function internalInit():void {
			
			//成功装载图片
			var loadBitmapSucceed:Function = function(event:Event):void {
				defaultCityNodeLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadBitmapSucceed);
				appData.defaultNodeBitdata = Bitmap(defaultCityNodeLoad.content).bitmapData;
			};
				
			//成功打开文件
			var openFileSucceedFun:Function = function(event:Event):void {
				appData.defaultNodeFileStream = defaultCityNodeFile.getFileStrem();
				if(!defaultCityNodeLoad) defaultCityNodeLoad = new Loader();
				defaultCityNodeLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,loadBitmapSucceed);
				defaultCityNodeLoad.loadBytes(appData.defaultNodeFileStream);
			};
			
			//打开默认的城市节点图片文件
			if(!defaultCityNodeFile) defaultCityNodeFile = new URLFileReference();
			defaultCityNodeFile.openFile(openFileSucceedFun,null,null,new URLRequest("assets/ManorFlag.png"));
		}
		
		/**
		 * 打开文件数据 
		 */		
		public function openFileData():void {
			
		}
		
		/**
		 * 创建一个新的文件数据 
		 * @return 
		 */		
		public function createNewMapData(cityNodesPath:String,mapPath:String):Boolean {
			if(!cityNodesPath) return;
			if(!mapPath) return;
			clearAppData();
			
			var fileStream:FileStream;
			var fileBytes:ByteArray;
			
			var ansyslizerCityNode:Function = function(rootFile:File):void {
				var nodeFiles:Array = rootFile.getDirectoryListing();
				var nf:File = File;
				for each(nf in nodeFiles) {
					if(nf.isDirectory) {
						ansyslizerCityNode(nf);
					} else {
						if(!fileStream) fileStream = new FileStream();
						fileStream.open(nf,FileMode.READ);
						fileStream.readBytes(fileBytes);
					}
				}
			};
			
			var nodesRoot:File = new File(cityNodesPath);		
			ansyslizerCityNode(nodesRoot);
		}
		
		private function nodeLoadComplete(event:Event):void {
			
		}
		/**
		 * 清理数据 
		 */		
		private function clearAppData():void {
			
			appData.cityImagesUrl = "";
			appData.cityNodeBits = [];
			appData.cityNodeFiles = [];
			appData.cityNodeTemps = [];
			
			appData.mapBit = null;
			appData.mapFileStream = null;
			appData.mapFileUrl = "";
			appData.mapCityNodes = [];
		}
		
		public static function get NAME():String{
			return getQualifiedClassName(AppDataProxy);
		}
	}
}