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
	
	import application.ApplicationMediator;
	import application.utils.appData;
	
	import gframeWork.url.URLFileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AppDataProxy extends Proxy
	{
		//默认的城市节点
		private var defaultCityNodeFile:URLFileReference;
		private var defaultCityNodeLoad:Loader;
		
		/**
		 * 当前节点的装载 
		 */		
		private var nowNodeLoadCount:int = 0;
		
		public function AppDataProxy(proxyName:String=null, data:Object=null){
			super(proxyName, data);
			internalInit();
		}
		
		private function internalInit():void {
			
			//装载默认的城市节点图片
			var loadBitmapSucceed:Function = function(event:Event):void {
				defaultCityNodeLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadBitmapSucceed);
				appData.defaultNodeBitdata = Bitmap(defaultCityNodeLoad.content).bitmapData;
			};
				
			//打开默认的城市节点文件
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
		 * 新建一个数据文件 
		 * @param cityNodesPath
		 * @param mapPath
		 * @return 
		 * 
		 */		
		public function createNewMapData(cityNodesPath:String,mapPath:String):Boolean {
			if(!cityNodesPath) return false;
			if(!mapPath) return false;
			clearAppData();
			
			var fileStream:FileStream;
			var fileBytes:ByteArray = new ByteArray();
			
			var ansyslizerCityNode:Function = function(rootFile:File):void {
				var nodeFiles:Array = rootFile.getDirectoryListing();
				var nf:File = null;
				for each(nf in nodeFiles) {
					if(nf.isDirectory) {
						ansyslizerCityNode(nf);
					} else {
						fileBytes.clear();
						fileBytes.position = 0;
						if(!fileStream) fileStream = new FileStream();
						fileStream.open(nf,FileMode.READ);
						fileStream.readBytes(fileBytes);
						appData.cityNodeFiles.push({textureName:nf.name,stream:fileBytes});
					}
				}
			};
			
			var nodesRoot:File = new File(cityNodesPath);		
			ansyslizerCityNode(nodesRoot);
			nowNodeLoadCount = 0;
			loadNode();
			
			return false;
		}
		
		private function loadNode():void {
			
			if(nowNodeLoadCount < appData.cityNodeFiles.length) {
				clearNodeLoad();
				defaultCityNodeLoad = new Loader();
				defaultCityNodeLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,nodeLoadComplete);
				var node_fs:ByteArray = appData.cityNodeFiles[nowNodeLoadCount].stream;
				defaultCityNodeLoad.loadBytes(node_fs);
			} else {
				clearNodeLoad();
				//新建一个数据文件完成
				sendNotification(ApplicationMediator.NEW_MAP_DATA_INIT);
			}
		}
		
		private function nodeLoadComplete(event:Event):void {
			//缓存位图数据
			var fileData:Object = appData.cityNodeFiles[nowNodeLoadCount];
			appData.cityNodeBitmapdatas.push({textureName:fileData.textureName,bitmapData:Bitmap(defaultCityNodeLoad.contentLoaderInfo.content).bitmapData});
			
			nowNodeLoadCount++;
			loadNode();
		}
		
		private function clearNodeLoad():void {
			if(defaultCityNodeLoad) {
				defaultCityNodeLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,nodeLoadComplete);
				defaultCityNodeLoad.unloadAndStop(false);
				defaultCityNodeLoad = null;
			}
		}
		
		/**
		 * 清理数据 
		 */		
		private function clearAppData():void {
			
			appData.cityImagesUrl = "";
			appData.cityNodeBitmapdatas = [];
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