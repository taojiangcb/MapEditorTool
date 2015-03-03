package application.mapEditor.ui
{
	import com.frameWork.gestures.DragGestures;
	import com.frameWork.uiControls.UIMoudle;
	import com.gskinner.motion.GTweener;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	
	import application.AppReg;
	import application.appui.CityPropertieController;
	import application.db.MapCityNodeTempVO;
	import application.db.MapCityNodeVO;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.appDrag.AppDragEvent;
	import gframeWork.appDrag.AppDragMgr;
	import gframeWork.uiController.UserInterfaceManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
			ui.clipRect = new Rectangle(0,0,sizeRect.width,sizeRect.height);
			ui.setSize(sizeRect.width,sizeRect.height);
			mapMove = new DragScrollGestures(ui.uiContent,mapDragHandler);
			mapMove.setDragRectangle(new Rectangle(0,0,sizeRect.width,sizeRect.height),ui.uiContent.width,ui.uiContent.height);
			AppDragMgr.addEventListener(AppDragEvent.DRAG,onDragHandler);
			
			var len:int = appData.mapCityNodes.length;
			while(--len > -1) {
				var mapCityInfo:MapCityNodeVO = appData.mapCityNodes[len];
				var city:MapCityNodeComp = createMapNode(mapCityInfo);
				mapCitys.push(city);
			}
		}
		
		public function resizeHandler():void {
			sizeRect = getSize();
			ui.setSize(sizeRect.width,sizeRect.height);
			ui.clipRect = new Rectangle(0,0,sizeRect.width,sizeRect.height);
			mapMove.setDragRectangle(new Rectangle(0,0,sizeRect.width,sizeRect.height),ui.uiContent.width,ui.uiContent.height);
		}
		
		//拖拽
		private function onDragHandler(event:AppDragEvent):void {
			var localPt:Point = new Point();
			ui.mapFloor.globalToLocal(event.hitPoint,localPt);
			if(ui.mapFloor.hitTest(localPt)) {
				//添加cityInfo
				var cityInfo:MapCityNodeVO = new MapCityNodeVO();
				cityInfo.textureName = MapCityNodeTempVO(event.itemData).textureName;
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
			
			if(crtSelectCity == cityComp) return;
			if(crtSelectCity){
				crtSelectCity.filter = null;
				clearRoad();
			}
			
			crtSelectCity = cityComp;
			if(crtSelectCity) {
				crtSelectCity.filter = BlurFilter.createGlow();
			}
			
			propertsPanel.setChrooseCity(cityComp);
			propertsPanel.commitData();
			smartDrawroad();
		}
		
		/**
		 * 绘制道路的连接线，能画线的画线，不能画线的则清除当前连接线 
		 */		
		public function smartDrawroad():void {
			visualAllRaod(appData.IS_DRAW_ALL_ROAD);
		}
		
		/**
		 * 确定缓制线条 
		 */		
		private function drawingRoad():void {
			if(!crtSelectCity) return;
			ui.citySpace.roadGraphics.clear();
			var toCity:MapCityNodeComp;
			var cityIds:Array = crtSelectCity.cityNodeInfo.toCityIds;
			var i:int = cityIds.length;
			while(--i > -1) {
				toCity = getCityCompById(cityIds[i]);
				var moveX:int = crtSelectCity.x + crtSelectCity.ctImage.x + crtSelectCity.ctImage.width / 2;
				var moveY:int = crtSelectCity.y + crtSelectCity.ctImage.y + crtSelectCity.ctImage.height / 2;
				
				var lineToX:int = toCity.cityNodeInfo.worldX + toCity.ctImage.x + toCity.ctImage.width / 2;
				var lineToY:int = toCity.cityNodeInfo.worldY + toCity.ctImage.y + toCity.ctImage.height / 2;
				
				ui.citySpace.roadGraphics.lineStyle(1,0xFFFFFF,1);
				ui.citySpace.roadGraphics.moveTo(moveX,moveY);
				ui.citySpace.roadGraphics.lineTo(lineToX,lineToY);
			}
		}
		
		/**
		 * 删除一个城市 
		 * @param cityId
		 * @return 
		 * 
		 */		
		public function delCityComp(cityId:int):void {
			var delCity:MapCityNodeComp = getCityCompById(cityId);
			var i:int = 0;
			var len:int = mapCitys.length;
			var itCityComp:MapCityNodeComp;			
			for(i= 0; i != len;) {
				itCityComp = null;
				if(mapCitys[i] == delCity) {
					itCityComp = mapCitys[i];
					mapCitys.splice(i,1);
					appDataProxy.removeCityInfoById(itCityComp.cityNodeInfo.templateId);
					itCityComp.removeFromParent(true);
					len = mapCitys.length;
				} else {
					i++;
				}
			}
			
			if(crtSelectCity && crtSelectCity == delCity) {
				setChrooseCity(null);
			} else {
				smartDrawroad();
			}
		}
		
		/**
		 * 清除道路的连接线条 
		 */		
		public function clearRoad():void {
			ui.citySpace.roadGraphics.clear();
		}
		
		public function getChrroseCity():MapCityNodeComp {
			return crtSelectCity;
		}
		
		public override function dispose():void {
			
			if(ui.stage) {
				ui.stage.removeEventListeners(Event.RESIZE);
			}
			
			if(crtSelectCity) crtSelectCity.filter = null;
			
			if(mapMove) {
				mapMove.dispose();
				mapMove = null;
			}
			
			if(mapCitys) {
				var i:int = mapCitys.length;
				while(--i > -1) mapCitys[i].removeFromParent(true);
				mapCitys = null;
			}
			super.dispose();
		}
		
		private function getCityCompById(templateId:int):MapCityNodeComp {
			var i:int = mapCitys.length;
			while(--i > -1) {
				if(mapCitys[i].cityNodeInfo.templateId == templateId) {
					return mapCitys[i];
				}
			}
			return  null;
		}
		
		/**
		 * 是否会制全地图路径  
		 * @param val	val = true 绘制全地图路径 false 绘制当前选中的城市路径，没有城市选中时不绘制
		 */		
		private function visualAllRaod(val:Boolean):void {
			if(val) {
				ui.citySpace.roadGraphics.clear();
				ui.citySpace.roadGraphics.beginFill(0,0.3);
				ui.citySpace.roadGraphics.drawRect(0,0,appData.mapBit.width,appData.mapBit.height);
				ui.citySpace.roadGraphics.endFill();
				
				var toCity:MapCityNodeComp;
				var forCity:MapCityNodeComp;
				var i:int = mapCitys.length;
				while(--i > -1) {
					forCity = mapCitys[i];
					var j:int = forCity.cityNodeInfo.toCityIds.length;
					while(--j > -1) {
						toCity = getCityCompById(forCity.cityNodeInfo.toCityIds[j]);
						
						var moveX:int = forCity.x + forCity.ctImage.x + forCity.ctImage.width / 2;
						var moveY:int = forCity.y + forCity.ctImage.y + forCity.ctImage.height / 2;
						
						var lineToX:int = toCity.cityNodeInfo.worldX + toCity.ctImage.x + toCity.ctImage.width / 2;
						var lineToY:int = toCity.cityNodeInfo.worldY + toCity.ctImage.y + toCity.ctImage.height / 2;
						
						ui.citySpace.roadGraphics.lineStyle(1,0xFFFFFF,1);
						ui.citySpace.roadGraphics.moveTo(moveX,moveY);
						ui.citySpace.roadGraphics.lineTo(lineToX,lineToY);
					}
				}
				
			} else {
				if(propertsPanel.ui.roadCheck.selected)	drawingRoad();
				else									clearRoad();
			}
		}
		
		/**
		 * 获取当前编辑场中的大小 
		 * @return 
		 */		
		private function getSize():Rectangle {
			var w:int = MapEditor(FlexGlobals.topLevelApplication).width - left - right;
			var h:int = MapEditor(FlexGlobals.topLevelApplication).height - top - bottom;
			return new Rectangle(left,top,w,h);
		}
		
		public function get ui():MapEditorPanel {
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