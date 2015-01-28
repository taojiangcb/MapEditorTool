package application.mapEditor.ui
{
	import com.frameWork.gestures.DragGestures;
	import com.frameWork.uiControls.UIMoudle;
	import com.gskinner.motion.GTweener;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import application.AppReg;
	import application.appui.CityPropertieController;
	import application.db.CityNodeTempVO;
	import application.db.MapCityNodeVO;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.utils.appData;
	
	import gframeWork.appDrag.AppDragEvent;
	import gframeWork.appDrag.AppDragMgr;
	import gframeWork.uiController.UserInterfaceManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class MapEditorPanelConstroller extends UIMoudle
	{
		private var sizeRect:Rectangle;
		/**
		 * 大地图城市节点信息 
		 */		
		private var mapCitys:Vector.<MapCityNodeComp>;
		
		/**
		 * 当前选中的城市节点 
		 */		
		private var crtSelectCity:MapCityNodeComp;
		
		/**
		 * 地图拖拽功能 
		 */		
		private var mapMove:DragScrollGestures;
		
		public function MapEditorPanelConstroller() {
			super();
			gcDelayTime = -1;
			smartClose = false;
			mapCitys = new Vector.<MapCityNodeComp>();
		}
		
		protected override function uiCreateComplete(event:Event):void {
			super.uiCreateComplete(event);
			sizeRect = getSize();
			ui.x = left;
			ui.y = top;
			ui.setSize(sizeRect.width,sizeRect.height);
			ui.clipRect = new Rectangle(0,0,sizeRect.width,sizeRect.height);
			mapMove = new DragScrollGestures(ui.uiContent,mapDragHandler);
			mapMove.setDragRectangle(ui.clipRect,ui.uiContent.width,ui.uiContent.height);
			AppDragMgr.addEventListener(AppDragEvent.DRAG,onDragHandler);
			
			var len:int = appData.mapCityNodes.length;
			while(--len > -1) {
				var mapCityInfo:MapCityNodeVO = appData.mapCityNodes[len];
				var city:MapCityNodeComp = createMapNode(mapCityInfo);
				mapCitys.push(city);
			}
		}
		
		//拖拽
		private function onDragHandler(event:AppDragEvent):void {
			var localPt:Point = new Point();
			ui.mapFloor.globalToLocal(event.hitPoint,localPt);
			if(ui.mapFloor.hitTest(localPt)) {
				//添加cityInfo
				var cityInfo:MapCityNodeVO = new MapCityNodeVO();
				cityInfo.textureName = CityNodeTempVO(event.itemData).textureName;
				cityInfo.worldX = localPt.x - event.offPoint.x;
				cityInfo.worldY = localPt.y - event.offPoint.y;
			
				var city:MapCityNodeComp = createMapNode(cityInfo);
				appData.mapCityNodes.push(cityInfo);
				
				mapCitys.push(city);
				setChrooseCity(city);
			}
		}
		
		/**
		 * 创建地图上的城市节点 
		 * @param mapNodeInfo
		 * @return 
		 */		
		public function createMapNode(mapNodeInfo:MapCityNodeVO):MapCityNodeComp {
			var city:MapCityNodeComp = new MapCityNodeComp(mapNodeInfo);
			ui.citySpace.addChild(city);
			city.x = Math.round(mapNodeInfo.worldX);
			city.y = Math.round(mapNodeInfo.worldY);
			return city;
		}
		
		/**
		 * 大地图拖拽回调 
		 */		
		private function mapDragHandler():void {}
		
		/**
		 * 刷地图上所有城市的显示 
		 */		
		public function refreshAllCity():void {
			var i:int = mapCitys.length;
			while(--i > -1) mapCitys[i].invalidateUpdateList();
		}
		
		/**
		 * 当前选中的城市 
		 * @param cityComp
		 */		
		public function setChrooseCity(cityComp:MapCityNodeComp):void {
			if(crtSelectCity) {
				crtSelectCity.filter = null;
			}
			crtSelectCity = cityComp;
			crtSelectCity.filter = BlurFilter.createGlow();
			propertsPanel.commitData();
		}
		
		public function getChrroseCity():MapCityNodeComp {
			return crtSelectCity;
		}
		
		public override function dispose():void {
			if(crtSelectCity) {
				crtSelectCity.filter = null;
			}
			
			if(mapMove) {
				mapMove.dispose();
				mapMove = null;
			}
			
			if(mapCitys) {
				var i:int = mapCitys.length;
				while(--i > -1) {
					mapCitys[i].removeFromParent(true);
				}
				mapCitys = null;
			}
			super.dispose();
		}
		
		/**
		 * 获取当前编辑场中的大小 
		 * @return 
		 */		
		private function getSize():Rectangle {
			var w:int = Starling.current.stage.stageWidth - left - right;
			var h:int = Starling.current.stage.stageHeight - top - bottom;
			return new Rectangle(left,top,w,h);
		}
		
		private function get ui():MapEditorPanel {
			return uiContent as MapEditorPanel
		}
		
		private function get propertsPanel():CityPropertieController {
			return UserInterfaceManager.getUIByID(AppReg.CITY_EDIT_PROPERTIES) as CityPropertieController
		}
		
		private function get right():int {
			return 200;
		}
		
		private function get bottom():int {
			return 0;
		}
		
		private function get left():int {
			return UserInterfaceManager.getUIByID(AppReg.CITY_NODE_TEMP_PANEL).getGui().width;
		}
		
		private function get top():int {
			return UserInterfaceManager.getUIByID(AppReg.TOP_UI_PANEL).getGui().height;
		}
	}
}