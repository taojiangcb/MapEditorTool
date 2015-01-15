package application.utils
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import application.proxy.AppDataProxy;

	/**
	 * 地图的纹理工具导出 
	 * @author JiangTao
	 * 
	 */	
	public class ExportTexturesUtils
	{
		public function ExportTexturesUtils() {
		}
		
		/**
		 * 导出地图的纹理集
		 * @param toPath
		 * @param chrooseMap
		 * @return 
		 */		
		public static function exportTextures(savePath:String,mergerMap:Boolean = false,mergerDefaultNode:Boolean = false):Boolean {
			var textureData:Object = appData.texturepack;
			if(textureData) {
				saveTextures(savePath + "/mapTexture.png",textureData.bitData);
				saveData(savePath + "/mapTexture.xml",textureData.atls.toXMLString());
				return true;
			}
			return false;
		}
		
		/**
		 * 获取纹理数据 
		 * @param chrooseDefaultNode
		 * @return 
		 */		
		public static function getTextureAtls(chrooseDefaultNode:Boolean):Object {
			var rectMap:Object = {};
			var i:int = 0;
			var len:int = appData.cityNodeBitmapdatas.length;
			//收集默认的城市节点纹理
			if(chrooseDefaultNode) {
				rectMap["default_city_node"] = new Rectangle(0,0,appData.defaultNodeBitdata.width,appData.defaultNodeBitdata.height);
			}
			//收集城市节点纹理
			var tempBitdata:Object;
			var textureName:String = "";
			var textureBit:BitmapData = null;
			for(i = 0; i != len; i++) {
				tempBitdata = appData.cityNodeBitmapdatas[i];
				textureName = tempBitdata[AppDataProxy.TEXTURE_NAME_FIELD];
				textureBit = tempBitdata[AppDataProxy.BITMAP_DATE_FIELD];
				rectMap[textureName] = new Rectangle(0,0,textureBit.width,textureBit.height);
			}
			
			var textureRect:Rectangle = TextureUtil.packTextures(0,4,rectMap);
			var elementBit:BitmapData;
			var elementRect:Rectangle = new Rectangle();
			var offsetPoint:Point = new Point();
			var tempRect:Rectangle = new Rectangle();
			var textureBitmapdata:BitmapData;
			
			var xml:XML = <TextureAtlas />;
			var childXml:XML;
			
			if(textureRect) {
				textureBitmapdata = new BitmapData(textureRect.width,textureRect.height);
				//合并默认的城市节点纹理
				if(chrooseDefaultNode) {
					elementRect = rectMap["default_city_node"];
					elementBit = appData.defaultNodeBitdata;
					tempRect.width = elementBit.width;
					tempRect.height = elementBit.height;
					offsetPoint.x = elementRect.x;
					offsetPoint.y = elementRect.y;
					
					childXml = <SubTexture />;
					childXml.@name = "default_city_node";
					childXml.@x = offsetPoint.x;
					childXml.@y = offsetPoint.y;
					childXml.@width = tempRect.width;
					childXml.@height = tempRect.height;
					xml.appendChild(childXml);
					textureBitmapdata.copyPixels(elementBit,tempRect,offsetPoint);
				}
				for(i = 0; i != len; i++ ) {
					tempBitdata = appData.cityNodeBitmapdatas[i];
					textureName = tempBitdata[AppDataProxy.TEXTURE_NAME_FIELD];
					elementBit = tempBitdata[AppDataProxy.BITMAP_DATE_FIELD];
					elementRect = rectMap[textureName];
					tempRect.width = elementBit.width;
					tempRect.height = elementBit.height;
					offsetPoint.x = elementRect.x;
					offsetPoint.y = elementRect.y;
					
					childXml = <SubTexture />;
					childXml.@name = textureName;
					childXml.@x = offsetPoint.x;
					childXml.@y = offsetPoint.y;
					childXml.@width = tempRect.width;
					childXml.@height = tempRect.height;
					xml.appendChild(childXml);
					textureBitmapdata.copyPixels(elementBit,tempRect,offsetPoint);
				}
				xml.@imagePath = "mapTexture.png";
			}
			return {bitData:textureBitmapdata,atls:xml};
		}
		
		private static function saveTextures(path:String,bitData:BitmapData):void {
			var fileStream:FileStream = new FileStream();
			var pngCode:PNGEncoder = new PNGEncoder();
			var fileBytes:ByteArray = pngCode.encode(bitData);
			var file:File = new File(path);
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeBytes(fileBytes);
			fileStream.close();
		}
		
		private static function saveData(path:String,xmlData:String):void {
			var fileStream:FileStream = new FileStream();
			var file:File = new File(path);
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeUTFBytes('<?xml version="1.0" encoding="UTF-16"?>' + xmlData);
			fileStream.close();
		}
		
		/**
		 * 检查城市切图块的高宽能不能被2整除，如果不能则需要重新计算一个bitmapdata
		 * @param bitmapData
		 * @return 
		 * 
		 */		
		public static function checkMinpBitmapData(bitmapData:BitmapData):BitmapData {
			var wFlag:Boolean = bitmapData.width % 2 > 0 ;
			var hFlag:Boolean = bitmapData.height % 2 > 0;
			if(wFlag && hFlag) return bitmapData;
			var nw:int = !wFlag ? bitmapData.width + 1 : bitmapData.width;
			var nh:int = !hFlag ? bitmapData.height + 1 : bitmapData.height;
			var nBitData:BitmapData = new BitmapData(nw,nh,true,0);
			nBitData.copyPixels(bitmapData,new Rectangle(0,0,bitmapData.width,bitmapData.height),new Point(0,0));
			return nBitData;
		}
	}
}