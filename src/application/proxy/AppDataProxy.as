package application.proxy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;
	
	import application.AppReg;
	import application.ApplicationMediator;
	import application.db.CityNodeTempVO;
	import application.db.MapCityNodeVO;
	import application.utils.ExportTexturesUtils;
	import application.utils.appData;
	
	import gframeWork.uiController.UserInterfaceManager;
	import gframeWork.url.URLFileReference;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class AppDataProxy extends Proxy
	{
		//关键字段
		public static const TEXTURE_NAME_FIELD:String = "textureName";	//纹理名称
		public static const BITMAP_DATE_FIELD:String = "bitmapData";		//位图数据
		public static const FILE_STREAM_FIELD:String = "stream";			//文件数据

		//保存文件
		private var saveFile:File;		

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
			var openFunc:Function = function(event:Event):void {
				UserInterfaceManager.close(AppReg.CITY_NODE_TEMP_PANEL);
				UserInterfaceManager.close(AppReg.EDITOR_MAP_PANEL);
				clearAppData();
				
				var mapFileByte:ByteArray = new ByteArray();
				var fileStream:FileStream = new FileStream();
				fileStream.open(openFile,FileMode.READ);
				fileStream.readBytes(mapFileByte);
				fileStream.close();
				
				//解城市节点模板数据
				var nodeObjTemps:Array = mapFileByte.readObject() as Array;
				var i:int = 0;
				var len:int = nodeObjTemps.length;
				var nodeTemps:Array = [];
				for(i; i != len; i++) {
					var nodeTemp:CityNodeTempVO = new CityNodeTempVO();
					nodeTemp.labelX = nodeObjTemps[i][0];
					nodeTemp.labelY = nodeObjTemps[i][1];
					nodeTemp.freeX = nodeObjTemps[i][2];
					nodeTemp.freeY = nodeObjTemps[i][3];
					nodeTemp.textureName = nodeObjTemps[i][4];
					nodeTemps.push(nodeTemp);
				}
				appData.cityNodeTemps = nodeTemps;
				
				//解地图上的城市实例数据
				var mapNodeObjs:Array = mapFileByte.readObject() as Array;
				var mapCityNodeData:Array = null;
				var mapCityNodes:Array = [];
				len = mapNodeObjs.length;
				for(i = 0; i != len; i++) {
					mapCityNodeData = mapNodeObjs[i];
					var mapCityNode:MapCityNodeVO = new MapCityNodeVO();
					mapCityNode.worldX = mapCityNodeData[0];
					mapCityNode.worldY = mapCityNodeData[1];
//					mapCityNode.faction = mapCityNodeData[2];
//					mapCityNode.labelX = mapCityNodeData[3];
//					mapCityNode.labelY = mapCityNodeData[4];
//					mapCityNode.freeX = mapCityNodeData[5];
//					mapCityNode.freeY = mapCityNodeData[6];
					mapCityNode.textureName = mapCityNodeData[2];
					mapCityNode.cityId = mapCityNodeData[3];
					mapCityNodes.push(mapCityNode);
				}
				appData.mapCityNodes = mapCityNodes;
				
				//城市节点纹理文件
				var nodeTempFileCount:int = mapFileByte.readDouble();
				len = nodeTempFileCount;
				var nodeFiles:Array = [];
				for(i = 0; i != len; i++) {
					var nodeFileObj:Object = new Object();
					var fileBytes:ByteArray = new ByteArray();
					var fileName:String = mapFileByte.readUTF();
					var fileLen:int = mapFileByte.readInt();
					mapFileByte.readBytes(fileBytes,0,fileLen);
					nodeFileObj[TEXTURE_NAME_FIELD] = fileName;
					nodeFileObj[FILE_STREAM_FIELD] = fileBytes;
					nodeFiles.push(nodeFileObj);
				}
				appData.cityNodeFiles = nodeFiles;
				
				var mapLen:Number = mapFileByte.readDouble();
				var mapFile:ByteArray = new ByteArray();
				mapFileByte.readBytes(mapFile,mapFileByte.position,mapLen);
				appData.mapFileStream = mapFile;
				appData.cityImagesUrl = mapFileByte.readUTF();
				appData.mapFileUrl = mapFileByte.readUTF();
				
				//当前装载的城市节点图片
				nowNodeLoadCount = 0;
				loadNode();
				
				//保存文件的句柄引用
				saveFile = openFile;
			};
			
			var openFile:File = new File();
			openFile.addEventListener(Event.SELECT,openFunc);
			openFile.browseForOpen("打开地图编辑文件",[new FileFilter(".bzTmx","*.bzTmx")]);
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
			appData.mapFileUrl = mapPath;
			
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
				//装载大地图数据
				installMapFile();
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
		
		/**
		 * 初始化纹理集上传给gpu
		 */		
		public function updateTextureToGPU():void {
			appData.textureManager.removeTexture("mapTexture");
			appData.textureManager.removeTextureAtlas("mapTexture");
			appData.texturepack = ExportTexturesUtils.getTextureAtls(true);
			
			var texture:Texture = Texture.fromBitmapData(appData.texturepack.bitData);
			var textureAtls:TextureAtlas = new TextureAtlas(texture,appData.texturepack.atls);
			appData.textureManager.addTextureAtlas("mapTexture",textureAtls);
		}
		
		/**
		 * 保存地图编辑文件 
		 */		
		public function saveMapEditorFile(quickSave:Boolean = false):void {
			var saveFunc:Function = function(event:Event):void {
				saveData();
			};
			
			var cancelFunc:Function = function(event:Event):void {
				saveFile = null;
			};
			
			if(quickSave) {
				saveData();
			} else {
				if(!saveFile) saveFile = new File();
				saveFile.addEventListener(Event.SELECT,saveFunc,false,0,true);
				saveFile.addEventListener(Event.CANCEL,cancelFunc,false,0,true);
				saveFile.browseForSave("保存编辑文件");
			}
		}
		
		/**
		 * 装载大地图文件数据 
		 */		
		private function installMapFile():void {
			//大地图的文件数据
			var mapFile:File = new File(appData.mapFileUrl);
			var mapBytes:ByteArray = new ByteArray();
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(mapFile,FileMode.READ);
			fileStream.readBytes(mapBytes);
			appData.mapFileStream = mapBytes;
			
			var mapLoaderFunc:Function = function(event:Event):void {
				appData.mapBit = Bitmap(mapLoad.contentLoaderInfo.content).bitmapData;
				//新建一个数据文件完成
				sendNotification(ApplicationMediator.NEW_MAP_DATA_INIT);
			};
			
			var mapLoad:Loader = new Loader();
			mapLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,mapLoaderFunc);
			mapLoad.loadBytes(mapBytes);
		}
		
		/**
		 * 保存地图数据 
		 */		
		private function saveData():void {
			if(!saveFile) return;
			if(saveFile.name == null || StringUtil.trim(saveFile.name).length == 0) return;
			if(saveFile.name.indexOf(".bzTmx") == -1) {
				saveFile.nativePath += ".bzTmx";
			}
			
			var writeBytes:ByteArray = new ByteArray();
			var writeFile:FileStream = new FileStream();
			writeFile.open(saveFile,FileMode.WRITE);
			
			//写入城市节点的模板数据
			var nodeTempList:Array = getWriteNodeTemps();
			writeBytes.writeObject(nodeTempList);
			
			//写入地图上的城市节点实例数据
			var mapNodeDatas:Array = getWriteMapNodes();
			writeBytes.writeObject(mapNodeDatas);
			
			var i:int = 0;
			var len:int = appData.cityNodeFiles.length;
			var nodeFileData:Object = null;
			
			//写入城市节点模板的文件个数
			writeBytes.writeDouble(len);
			for(i = 0; i != len; i++) {
				nodeFileData = appData.cityNodeFiles[i];
				var fileName:String = nodeFileData[TEXTURE_NAME_FIELD];
				var fileLen:int = ByteArray(nodeFileData[FILE_STREAM_FIELD]).bytesAvailable;
				writeBytes.writeUTF(nodeFileData[TEXTURE_NAME_FIELD]);						//写入文理名称
				writeBytes.writeInt(fileLen);												//写入文件byteArray的长度
				writeBytes.writeBytes(nodeFileData[FILE_STREAM_FIELD]);						//写入文件
			}
			
			writeBytes.writeDouble(appData.mapFileStream.bytesAvailable);					//写入大地文件数据长度
			writeBytes.writeBytes(appData.mapFileStream);									//写入大地图文件
			
			writeBytes.writeUTF(appData.cityImagesUrl);
			writeBytes.writeUTF(appData.mapFileUrl);
			
			writeFile.writeBytes(writeBytes);												//写入文件
			writeFile.close();
		}
		
		/**
		 * 获取写入的城市节点模板列表 
		 * @return 
		 */		
		public function getWriteNodeTemps():Array {
			var i:int = 0;
			var len:int = appData.cityNodeTemps.length;
			var nodeTemp:CityNodeTempVO;
			var nodeTempList:Array = [];
			//组织城市模板节点的数据
			for(i = 0; i != len; i++) {
				//数据格式  [0 labelX 1 labelY 2 freeX 3 freeY 4 textureName]
				nodeTemp = appData.cityNodeTemps[i];
				var nodeData:Array = [nodeTemp.labelX,nodeTemp.labelY,nodeTemp.freeX,nodeTemp.freeY,nodeTemp.textureName];
				nodeTempList.push(nodeData);
			}
			return nodeTempList;
		}
		
		/**
		 * 获取地图城市节点数据 
		 * @return 
		 */		
		public function getWriteMapNodes():Array {
			var i:int = 0
			var len:int = appData.mapCityNodes.length;
			var mapCityNode:MapCityNodeVO;
			var mapNodeDatas:Array = [];
			for(i = 0; i != len; i++) {
				mapCityNode = appData.mapCityNodes[i];
				//数据格式 [0 worldX 1 worldY 2 textureName 3 cityId]
				var mapCityNodeData:Array = [mapCityNode.worldX,
					mapCityNode.worldY,
					mapCityNode.textureName,
					mapCityNode.cityId];
				mapNodeDatas.push(mapCityNodeData);
			}
			return mapNodeDatas;
		}
		
		/**
		 * @param textureName
		 * @return 
		 */		
		public function getCityNodeTempByName(textureName:String):CityNodeTempVO {
			var i:int = 0;
			var len:int = appData.cityNodeTemps.length;
			for(i = 0; i != len; i++) {
				if(CityNodeTempVO(appData.cityNodeTemps[i]).textureName == textureName) {
					return appData.cityNodeTemps[i];
				}
			}
			return null;
		}
		
		public static function get NAME():String{
			return getQualifiedClassName(AppDataProxy);
		}
	}
}