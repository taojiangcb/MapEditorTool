package application.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import application.AppGlobal;

	public class MapUtils
	{
		public function MapUtils() {
			
		}
		
		/**
		 * 获取地图被2整除之后的大小  
		 * @return 
		 */		
		public static function getMapMINP_rect():Rectangle {
			if(!appData.mapBit) return null;
			var w:int = (appData.mapBit.width % 2) > 0 ? appData.mapBit.width - 1 : appData.mapBit.width;
			var h:int = (appData.mapBit.height % 2) > 0 ? appData.mapBit.height - 1 : appData.mapBit.height;
			return new Rectangle(0,0,Math.min(AppGlobal.MAP_MAX_W,w),Math.min(AppGlobal.MAX_MAX_H,h));
		}
		
		/**
		 * 获取地图的底图格子大小 
		 * @return 
		 */		
		public static function getMapGridSize():Rectangle {
			var minpRect:Rectangle = getMapMINP_rect();
			return minpRect ? new Rectangle(0,0,minpRect.width / AppGlobal.MAP_COLUMN,minpRect.height / AppGlobal.MAP_ROW) : null;
		}
	
		/**
		 * 获取地图单元格bitmapdata阵列 
		 * @return 
		 * 
		 */		
		public static function getBitGrids():Array {
			var grids:Array = [];
			var minpRect:Rectangle = getMapMINP_rect();
			var gridSize:Rectangle = getMapGridSize();
			var cloneBit:BitmapData = new BitmapData(minpRect.width,minpRect.height);
			cloneBit.copyPixels(appData.mapBit,minpRect,new Point(0,0));
			for(var x:int = 0; x != AppGlobal.MAP_COLUMN; x++) {
				grids[x] = [];
				for(var y:int = 0; y != AppGlobal.MAP_ROW; y++) {
					var bitGrid:BitmapData = new BitmapData(gridSize.width + 8,gridSize.height + 8);
					bitGrid.copyPixels(cloneBit,new Rectangle(x * gridSize.width,y * gridSize.height,gridSize.width + 8,gridSize.height + 8),new Point(0,0));
					grids[x][y] = bitGrid; 
				}
			}
			return grids;
		}
	}
}