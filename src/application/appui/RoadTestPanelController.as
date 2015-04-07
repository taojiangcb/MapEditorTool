package application.appui
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.AppReg;
	import application.db.CityNodeVO;
	import application.db.MapCityNodeRoadVO;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.road.PlanCourse;
	import application.road.RoutePannelResult;
	import application.road.RoutePanner;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	public class RoadTestPanelController extends MainUIControllerBase
	{
		public function RoadTestPanelController() {
			super();
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			gui.horizontalCenter = 0;
			gui.bottom = 0;
			
			gui.btnSearch.addEventListener(MouseEvent.CLICK,searchHandler,false,0,true);
		}
		
		private function searchHandler(event:MouseEvent):void {
			assignRoad();
			var i:int = appData.mapCityNodes.length;
			var nodes:Vector.<CityNodeVO> = new Vector.<CityNodeVO>();
			while(--i > -1) {
				nodes.push(appData.mapCityNodes[i]);
			}
			
			var sTime:Number = Number(gui.sTime.text);
			var tTime:Number = Number(gui.tTime.text);
			
			var sid:int = int(gui.ts.text);
			var eid:int = int(gui.es.text);
			var pc:RoutePanner = new RoutePanner();
			var result:RoutePannelResult = pc.planner(nodes,sid,eid);
			if(result) {
				result.pathNodeIds.push(eid);
				gui.txtResult.text = result.pathNodeIds.toString() + ",allWeight:" + result.allWeight;
				
				mapEditor.ui.marchRole.run(result,sTime,tTime);
				
			} else {
				gui.txtResult.text = "没有寻到路径";
			}
		}
		
		private function assignRoad():void {
			
			var addRoadFunc:Function = function(node:CityNodeVO,road:MapCityNodeRoadVO):void {
				var exist:Boolean = false
				var len:int = node.toRoads.length;
				while(--len > -1) {
					if(node.toRoads[len].toCityId == road.toCityId) {
						exist = true;
					}
				}
				if(!exist) node.toRoads.push(road);
			}
			
			var mapNode:CityNodeVO;
			var mapRoad:MapCityNodeRoadVO;
			var i:int = appData.mapCityNodes.length;
			while(--i > -1) {
				mapNode = appData.mapCityNodes[i];
				mapNode.toRoads = new Vector.<MapCityNodeRoadVO>();
			}
			
			i = appData.mapCityNodes.length;
			while(--i > -1) {
				mapNode = appData.mapCityNodes[i];
				var j:int = mapNode.toCityIds.length;
				while(--j > -1) {
					mapRoad = new MapCityNodeRoadVO();
					mapRoad.fromCityId = mapNode.templateId;
					mapRoad.toCityId = mapNode.toCityIds[j];
					mapRoad.distance = CityRoadPanelController.defaultDisatnce;
					addRoadFunc(mapNode,mapRoad);
					
					var toCityNode:CityNodeVO = appDataProxy.getCityNodeInfoByTemplateId(mapRoad.toCityId);
					if(toCityNode) {
						mapRoad = new MapCityNodeRoadVO();
						mapRoad.fromCityId = mapNode.toCityIds[j];
						mapRoad.toCityId = mapNode.templateId;
						mapRoad.distance = CityRoadPanelController.defaultDisatnce;
						addRoadFunc(toCityNode,mapRoad);
					}
				}
			}
		}
		
		private function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
		}
		
		public function get gui():RoadTestPanel {
			return mGUI as RoadTestPanel;
		}
	}
}