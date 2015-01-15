package application.mapEditor.comps
{
	import flash.geom.Rectangle;
	
	import application.mapEditor.utils.MapUtils;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * 世界大地图的地皮 
	 * @author JiangTao
	 */	
	public class MapFloorComp extends Sprite
	{
		private var gridImages:Vector.<Image>;
		public function MapFloorComp() {
			super();
			gridImages = new Vector.<Image>();
			createGrids();
		}
		
		/**
		 * 创建地图 
		 */		
		private function createGrids():void {
			var bitGrids:Array = MapUtils.getBitGrids();
			var gridSize:Rectangle = MapUtils.getMapGridSize();
			var i:int = 0;
			var j:int = 0;
			for(i = 0; i != bitGrids.length; i++) {
				for(j = 0; j != bitGrids[i].length; j++) {
					var gridTexture:Texture = Texture.fromBitmapData(bitGrids[i][j]);
					var img:Image = new Image(gridTexture);
					addChild(img);
					
					img.x = i * gridSize.width;
					img.y = j * gridSize.height;
					
					gridImages.push(img);
				}
			}
		}
		
		public override function dispose():void{
			if(gridImages) {
				var len:int = gridImages.length;
				while(--len > -1) {
					gridImages[len].removeFromParent(true);
					gridImages[len].texture.dispose();
				}
			}
			super.dispose();
		}
	}
}