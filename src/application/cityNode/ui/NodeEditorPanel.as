package application.cityNode.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import application.utils.appData;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import source.feathers.themes.BaseMetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.CustomFeathersControls;
	import starling.extensions.graphicPack.Graphics;
	import starling.extensions.graphicPack.graphicsEx.ShapeEx;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 城市节点编辑面板 
	 * @author JiangTao
	 */	
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
		public var txtName:TextField;
		//火
		public var free:MovieClip;
		//城市节点图片
		public var nodeImage:Image;
		//内容
		public var contentSprite:Sprite;
		
		public function NodeEditorPanel() {
			super();
		}
		
		protected override function initialize():void {
			super.initialize();
			
			btnClose = new Button();
			btnClose.width = 30;
			btnClose.label = "退出";
			addChild(btnClose);
			
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			txtName = new TextField(150,20,"名称标签",BaseMetalWorksMobileTheme.FONT_NAME,12,0xFFFFFF,true);
			txtName.fontName = BaseMetalWorksMobileTheme.FONT_NAME;
			txtName.hAlign = HAlign.CENTER;
			txtName.vAlign = VAlign.CENTER;
			txtName.nativeFilters = [appData.GLOW_BLACK];
			contentSprite.addChild(txtName);
			
			var textures:Vector.<Texture> = new Vector.<Texture>();
			var atls:TextureAtlas = appData.textureManager.getTextureAtlas("WarEffect");
			textures = atls.getTextures("war_firee_");
			
			free = new MovieClip(textures,24);
			contentSprite.addChild(free);
			Starling.juggler.add(free);
		}
		
		public function drawImage():void {
			var textureName:String = appData.editorCityNode.textureName;
			var nodeTexture:Texture = appData.textureManager.getTexture(textureName);
			if(nodeImage) nodeImage.removeFromParent(true);
			nodeImage = new Image(nodeTexture);
			contentSprite.addChildAt(nodeImage,0);
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
			if(nodeImage) nodeImage.removeFromParent(true);
			if(free) {
				Starling.juggler.remove(free);
				free.removeFromParent(true);
			}
			super.dispose();
		}
	}
}