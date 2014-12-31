package application.proxy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import application.ApplicationMediator;
	import application.db.CityNodeTempVO;
	import application.utils.appData;
	
	import gframeWork.url.URLFileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AppDataProxy extends Proxy
	{
	
		//关键字段
		public static const TEXTURE_NAME_FIELD:String = "textureName";	//纹理名称
		public static const BITMAP_DATE_FIELD:String = "bitmapData";		//位图数据
		public static const FILE_STREAM_FIELD:String = "stream";			//文件数据
		
		//默认的城市节点
		private var defaultCityNodeFile:URLFileReference;
		private var defaultCityNodeLoad:Loader;
		
		/**
		 * 当前节点的装载 
		 */		
		private var nowNodeLoadCount:int = 0;
		
		public function AppDataProxy(proxyName:String=null, data:Object=null){
			super(proxyName, data);
		}
		
		public function internalInit():void {
			
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
			defaultCityNodeFile.openFile(openFileSucceedFun,null,null,new URLRequest("assets/default_city_node.png"));
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
			var ansyslizerCityNode:Function = function(rootFile:File):void {
				var nodeFiles:Array = rootFile.getDirectoryListing();
				var nf:File = null;
				for each(nf in nodeFiles) {
					if(nf.isDirectory) {
						ansyslizerCityNode(nf);
					} else {
						var fileBytes:ByteArray = new ByteArray();
						if		(!fileStream) fileStream = new FileStream();
						else	fileStream.close();
						fileStream.open(nf,FileMode.READ);
						fileStream.readBytes(fileBytes);
						
						trace("cityNodeFile:",nf.nativePath);
						var objData:Object = new Object();
						objData[TEXTURE_NAME_FIELD] = nf.name;
						objData[FILE_STREAM_FIELD] = fileBytes;
						appData.cityNodeFiles.push(objData);
					}
				}
			};
			
			var nodesRoot:File = new File(cityNodesPath);
			trace("begin load cityNodeImages");
			trace("===================================");
			ansyslizerCityNode(nodesRoot);
			trace("===================================");
			//当前装载的城市节点图片
			nowNodeLoadCount = 0;
			loadNode();
			
			return false;
		}
		
		/**
		 * 加载城市节点图片 
		 */		
		private function loadNode():void {
			
			if(nowNodeLoadCount < appData.cityNodeFiles.length) {
				clearNodeLoad();
				defaultCityNodeLoad = new Loader();
				defaultCityNodeLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,nodeLoadComplete);
				
				var node_fs:ByteArray = appData.cityNodeFiles[nowNodeLoadCount][FILE_STREAM_FIELD];
				defaultCityNodeLoad.loadBytes(node_fs);
			} else {
				clearNodeLoad();
				//新建一个数据文件完成
				sendNotification(ApplicationMediator.NEW_MAP_DATA_INIT);
			}
		}
		
		/**
		 * 城市节点装载完成 
		 * @param event
		 */		
		private function nodeLoadComplete(event:Event):void {
			
			defaultCityNodeLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,nodeLoadComplete);
			
			//缓存位图数据
			var fileData:Object = appData.cityNodeFiles[nowNodeLoadCount];
			var objData:Object = new Object();
			objData[TEXTURE_NAME_FIELD] = fileData[TEXTURE_NAME_FIELD];
			objData[BITMAP_DATE_FIELD] = Bitmap(defaultCityNodeLoad.contentLoaderInfo.content).bitmapData;
			appData.cityNodeBitmapdatas.push(objData);
			
			//创建节点模板数据
			var cityNodeTemp:CityNodeTempVO = new CityNodeTempVO();
			cityNodeTemp.textureName = fileData.textureName;
			appData.cityNodeTemps.push(cityNodeTemp);
			
			nowNodeLoadCount++;
			loadNode();
		}
		
		/**
		 * 清除节点装载 
		 */		
		private function clearNodeLoad():void {
			if(defaultCityNodeLoad) {
				defaultCityNodeLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,nodeLoadComplete);
				defaultCityNodeLoad.unloadAndStop(false);
				defaultCityNodeLoad = null;
			}
		}
		
		/**
		 * 根据texture纹理名获取一个BitmapData数据 
		 * @param textureName
		 * @return 
		 */		
		public function getCityNodeBitDataByName(textureName:String):BitmapData {
			var i:int = 0;
			var len:int = appData.cityNodeBitmapdatas.length;
			var crtBitmapData:Object;
			for(i = 0;  i!=len; i++) {
				crtBitmapData = appData.cityNodeBitmapdatas[i];
				if(crtBitmapData[TEXTURE_NAME_FIELD] == textureName) {
					return crtBitmapData[BITMAP_DATE_FIELD];
				}
			}
			return null;
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