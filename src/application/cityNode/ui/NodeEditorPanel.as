package application.cityNode.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import application.utils.appData;
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	
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
		//旗子
		public var nationFlag:Image;
		//按钮
		public var menuImg:Image;
		//内容
		public var contentSprite:Sprite;
		//纹理更新
		public var textureInput:TextInput;
		//纹理更新
		public var textureUpdateBtn:Button;
		
		//===========================================================================
		
		public var checkFree:Check;			//火
		public var	checkFlag:Check;			//旗子
		public var checkMenu:Check;			//菜单
		
		public function NodeEditorPanel() {
			super();
		}
		
		protected override function initialize():void {
			super.initialize();
			
			btnClose = new Button();
			btnClose.width = 30;
			btnClose.label = "退出";
			addChild(btnClose);
			
			checkFree =new Check();
			checkFree.label = "火";
			addChild(checkFree);
			
			checkFlag = new Check();
			checkFlag.label = "旗子";
			addChild(checkFlag);
			
			checkMenu = new Check();
			checkMenu.label = "菜单";
			addChild(checkMenu);
			
			textureInput = new TextInput();
			textureInput.width = 200;
			addChild(textureInput);
			
			textureUpdateBtn = new Button();
			textureUpdateBtn.label = "更新";
			addChild(textureUpdateBtn);
			
			contentSprite = new Sprite();
			addChild(contentSprite);
			
			nationFlag = new Image(appData.textureManager.getTexture("FlagMap_han_9"));
			nationFlag.visible = false;
			contentSprite.addChild(nationFlag);
			
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
			free.visible = false;
			contentSprite.addChild(free);
			Starling.juggler.add(free);
			
			
			menuImg = new Image(appData.textureManager.getTexture("img_city_move"));
			menuImg.readjustSize();
			menuImg.pivotX = menuImg.width >> 1;
			menuImg.pivotY = menuImg.height >> 1;
			menuImg.scaleX = menuImg.scaleY = 0.3;
			menuImg.visible = false;
			contentSprite.addChild(menuImg);
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
			graphics.beginFill(0x999999,1);
			graphics.drawRect(0,0,sizeRect.width,sizeRect.height);
			graphics.lineStyle(1,0xFFFFFF,1);
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