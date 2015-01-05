package application.cityNode.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import application.utils.appData;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.extensions.CustomFeathersControls;
	import starling.extensions.graphicPack.Graphics;
	import starling.extensions.graphicPack.graphicsEx.ShapeEx;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class NodeEditorPanel extends CustomFeathersControls
	{
		//原点
		private var oldPoint:Point;
		//==========================================
		private var graphics:Graphics;
		private var shape:ShapeEx;
		
		//关闭按钮
		public var btnClose:Button;
		//名字
		public var txtName:Label;
		//点
		public var free:MovieClip;
		
		public var image:Image;
		
		public function NodeEditorPanel() {
			super();
		}
		
		protected override function initialize():void {
			super.initialize();
			btnClose = new Button();
			btnClose.width = 30;
			btnClose.label = "x";
			addChild(btnClose);
			
			var textureName:String = appData.editorCityNode.textureName;
			var nodeTexture:Texture = appData.textureManager.getTexture(textureName);
			image = new Image(nodeTexture);
			addChild(image);
			
			txtName = new Label();
			txtName.text = "名称标签";
			txtName.x = 100;
			txtName.y = 15;
			addChild(txtName);
			
			var textures:Vector.<Texture> = new Vector.<Texture>();
			var atls:TextureAtlas = appData.textureManager.getTextureAtlas("WarEffect");
			textures = atls.getTextures("war_firee_");
			
			free = new MovieClip(textures,24);
			free.x = 100;
			free.y = 100;
			addChild(free);
			Starling.juggler.add(free);
		}
		
		public function drawBackground(resize:Rectangle,oldPt:Point):void {
			var sizeRect:Rectangle = resize;
			if(!shape) {
				shape = new ShapeEx();
				addChildAt(shape,0);
			}
			
			if(!graphics) {
				graphics = new Graphics(shape);
			}
			
			graphics.clear();
			graphics.beginFill(0xF9F9F9,1);
			graphics.drawRect(0,0,sizeRect.width,sizeRect.height);
			graphics.lineStyle(1,0,1);
			graphics.moveTo(0,oldPt.y);
			graphics.lineTo(sizeRect.width,oldPt.y);
			graphics.moveTo(oldPt.x,0);
			graphics.lineTo(oldPt.x,sizeRect.height);
			graphics.endFill();
		}
		
		public override function dispose():void {
			if(image) image.removeFromParent(true);
			if(free) {
				Starling.juggler.remove(free);
				free.removeFromParent(true);
			}
			super.dispose();
		}
	}
}