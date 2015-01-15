package application.mapEditor.comps
{
	import com.frameWork.gestures.DoubleTapGestures;
	import com.frameWork.gestures.DragGestures;
	import com.frameWork.gestures.TapGestures;
	import com.frameWork.uiControls.UIMoudleManager;
	
	import mx.utils.StringUtil;
	
	import application.AppReg;
	import application.ApplicationMediator;
	import application.db.CityNodeTempVO;
	import application.db.MapCityNodeVO;
	import application.mapEditor.ui.DragCityGestures;
	import application.mapEditor.ui.MapEditorPanel;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import feathers.core.IFocusDisplayObject;
	import feathers.events.FeathersEventType;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import source.feathers.themes.BaseMetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.extensions.CustomFeathersControls;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class MapCityNodeComp extends CustomFeathersControls implements IFocusDisplayObject
	{
		/*城市的图片，在MapCitySpaceComp中添加到显示层，添加到同一个QuadBatch*/
		public var ctImage:Image;
		
		private var free:MovieClip;
		private var txtName:TextField;
		
		private var mapNodeInfo:MapCityNodeVO;
		
		/**
		 * 拖拽处理 
		 */		
		private var dragGuester:DragCityGestures;
		
		/**
		 * 双击 
		 */		
		private var doubleGuester:DoubleTapGestures;
		
		/**
		 * 单击 
		 */		
		private var tapGuester:TapGestures;
		
		public function MapCityNodeComp(cityNode:MapCityNodeVO) {
			super(true);
			mapNodeInfo = cityNode;
		}
		
		protected override function createCompleteHandler(event:Event):void {
			super.createCompleteHandler(event);
			var imageTexture:Texture = appData.textureManager.getTexture(mapNodeInfo.textureName);
			ctImage = new Image(imageTexture);
			addChild(ctImage);
			
			var textureFrames:Vector.<Texture> = appData.textureManager.getTextures("war_firee_");
			if(textureFrames) {
				free = new MovieClip(textureFrames);
				Starling.juggler.add(free);
			}
			addChild(free);
			
			var cityName:String = StringUtil.trim(mapNodeInfo.cityName).length ? mapNodeInfo.cityName : "名称标签";
			txtName = new TextField(150,20,cityName,BaseMetalWorksMobileTheme.FONT_NAME,12,0xFFFFFF,true);
			txtName.fontName = BaseMetalWorksMobileTheme.FONT_NAME;
			txtName.hAlign = HAlign.CENTER;
			txtName.vAlign = VAlign.CENTER;
			txtName.nativeFilters = [appData.GLOW_BLACK];
			addChild(txtName);
			
			ctImage.readjustSize();
			setSize(ctImage.width,ctImage.height);
			
			free.visible = mapNodeInfo.visualFiree;
			
			dragGuester = new DragCityGestures(this,dragOverHandler);
			doubleGuester = new DoubleTapGestures(this,doubleTabHandler);
			tapGuester = new TapGestures(this,tapGuesterHandler);
			invalidateUpdateList();
		}
		
		private function tapGuesterHandler(touch:Touch):void {
			Facade.getInstance().sendNotification(ApplicationMediator.CHROOSE_MAP_CITY,this);
		}
		
		private function doubleTabHandler(event:Touch):void {
			Facade.getInstance().sendNotification(ApplicationMediator.EDIT_CITY_TEMP,nodeTemp);
		}
		
		private function dragOverHandler():void {
			updateNodeInfo();
			x = Math.round(x);
			y = Math.round(y);
		}
		
		protected override function layout():void {
			super.layout();
			if(nodeTemp) 
			{
				if(free) {
					free.x = nodeTemp.freeX;
					free.y = nodeTemp.freeY;
				}
				if(txtName) {
					txtName.x = nodeTemp.labelX;
					txtName.y = nodeTemp.labelY;
				}
			}
		}
		
		/**
		 * 更新地图上的城市节点信息 
		 */		
		public function updateNodeInfo():void {
			mapNodeInfo.worldX = Math.round(x);
			mapNodeInfo.worldY = Math.round(y);
		}
		
		public override function dispose():void {
			if(free) {
				Starling.juggler.remove(free);
				free.removeFromParent(true);
			}
			
			if(dragGuester) {
				dragGuester.dispose();
				dragGuester = null;
			}
			
			if(doubleGuester) {
				doubleGuester.dispose();
				doubleGuester = null;
			}
			
			if(tapGuester) {
				tapGuester.dispose();
				tapGuester = null;
			}
			
			super.dispose();
		}
		
		//==============================================================
		//城市名称
		public function set cityName(val:String):void {
			mapNodeInfo.cityName = val;
			if(txtName) {
				txtName.text = mapNodeInfo.cityName;
			}
		}
		
		public function get cityName():String {
			return mapNodeInfo.cityName;
		}
		
		//城市模板
		public function set templateId(id:int):void {
			mapNodeInfo.templateId = id;
		}
		
		public function get templateId():int {
			return mapNodeInfo.templateId;
		}
		
		public function set freeVisible(val:Boolean):void {
			mapNodeInfo.visualFiree = val;
			if(free) {
				free.visible = val;
			}
		}
		
		public function get freeVisible():Boolean {
			return mapNodeInfo.visualFiree;
		}
		
		public function get nodeTemp():CityNodeTempVO {
			return appDataProxy.getCityNodeTempByName(mapNodeInfo.textureName);
		}
		
		public function get cityQuadSapce():QuadBatch{
			return MapEditorPanel(UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL).gui).cityQuadSapce;
		}
		
		//===========================================================================
	}
}