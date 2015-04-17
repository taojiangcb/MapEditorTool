package application.mapEditor.comps
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import application.AppReg;
	import application.db.RoadPathNodeVO;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.utils.appData;
	import application.utils.appDataProxy;
	import application.utils.roadDataProxy;
	
	import starling.events.Event;
	import starling.extensions.CustomFeathersControls;
	
	public class MapRoadSpaceComp extends CustomFeathersControls
	{
		private var joinNodes:Vector.<MapRoadNodeComp>;
		public function MapRoadSpaceComp(listenCreateComplete:Boolean=false) {
			super(true);
			joinNodes = new Vector.<MapRoadNodeComp>();
		}
		
		protected override function createCompleteHandler(event:Event):void {
			super.createCompleteHandler(event);
			var i:int = appData.roadPathNodes.length;
			while(--i > -1) {
				var roadNodeComp:MapRoadNodeComp = new MapRoadNodeComp(appData.roadPathNodes[i]);
				roadNodeComp.x = appData.roadPathNodes[i].x; 
				roadNodeComp.y = appData.roadPathNodes[i].y;
				roadNodeComp.visible = false;
				addChild(roadNodeComp);
				joinNodes.push(roadNodeComp);
			}
		}
		
		/**
		 * 自动显示相关的路径节点 
		 */		
		public function smartVisualPoint():void {
			
			var chrooseCity:MapCityNodeComp = mapEditor.getChrroseCity();								//当前选择的城市
			var isChroose:Boolean = false;
			var i:int = 0;
			if(chrooseCity) {
				i = chrooseCity.cityNodeInfo.toCityIds.length;
				var roadKey:String = "";
				while(--i > -1) {
					roadKey = roadDataProxy.getRoadKeyStr(chrooseCity.templateId,chrooseCity.cityNodeInfo.toCityIds[i]);
					if(roadKey == appData.EDIT_ROAD_ID  && appData.EDIT_ROAD_ID != ""  && chrooseCity.roadVisible) {
						isChroose = true;
						break;
					}
				}
			}
			
			var pathKeys:Array = appData.EDIT_ROAD_ID.split(",");
			i = joinNodes.length;
			while(--i > -1) {
				if(pathKeys.length == 2 && isChroose) {
					if(joinNodes[i].roadPathNodeInfo.fromCityId == pathKeys[0] && joinNodes[i].roadPathNodeInfo.toCityId == pathKeys[1]) {
						joinNodes[i].visible = true;
					} else {
						joinNodes[i].visible = false;
					}
				} else {
					joinNodes[i].visible = false;
				}
			}
		}
		
		/**
		 * 添加一个节点 
		 * @param fromId
		 * @param toId
		 * @param tx
		 * @param ty
		 * @param sortId
		 * 
		 */		
		public function addNode(fromId:Number,toId:Number,tx:Number,ty:Number,sortId:int):void {
			var roadNodeInfo:RoadPathNodeVO = roadDataProxy.addRoadNode(fromId,toId,tx,ty,sortId);
			if(roadNodeInfo) {
				var roadNodeComp:MapRoadNodeComp = new MapRoadNodeComp(roadNodeInfo);
				roadNodeComp.x = roadNodeInfo.x; 
				roadNodeComp.y = roadNodeInfo.y;
				addChild(roadNodeComp);
				joinNodes.push(roadNodeComp);
			}
		}
		
		/**
		 * 删除一个点节 
		 * @param fromId
		 * @param toId
		 * @param sortId
		 * 
		 */		
		public function delNode(fromId:Number,toId:Number,sortId:int):void {
			var pathKey:Array = roadDataProxy.getRoadKeyAry(fromId,toId);
			if(pathKey) {
				var i:int = joinNodes.length;
				var eachItem:RoadPathNodeVO;
				var isDel:int = -1;
				while(--i > -1) {
					eachItem = joinNodes[i].roadPathNodeInfo;
					if(eachItem.fromCityId == pathKey[0] && eachItem.toCityId == pathKey[1] && eachItem.sortIndex == sortId) {
						isDel = i;
						break;
					}
				}
				if(isDel > -1) {
					joinNodes[isDel].removeFromParent(true);
					joinNodes.splice(isDel,1);
					roadDataProxy.delPathNode(fromId,toId,sortId);
				}
			}
		}
		
		
		/**
		 * 删除一整条的路径节点 
		 * @param fromId
		 * @param toId
		 */		
		public function delRoad(fromId:Number,toId:Number):void {
			var pathKey:Array = roadDataProxy.getRoadKeyAry(fromId,toId);
			if(pathKey) {
				var i:int = joinNodes.length;
				var eachItem:RoadPathNodeVO;
				var clears:Array = [];
				while(--i > -1) {
					eachItem = joinNodes[i].roadPathNodeInfo;
					if(eachItem.fromCityId == pathKey[0] && eachItem.toCityId == pathKey[1]){
						clears.push(joinNodes[i]);
					}
				}
				
				i = clears.length;
				while(--i > -1) {
					var existIndex:int = joinNodes.indexOf(clears[i]);
					if(existIndex > -1) {
						joinNodes.splice(existIndex,1);
					}
					clears[i].removeFromParent(true);
				}
				roadDataProxy.delRoad(pathKey[0],pathKey[1]);
			}
		}
		
		public override function dispose():void {
			var i:int = joinNodes.length;
			while(--i > -1) {
				joinNodes[i].removeFromParent(true);
				joinNodes.shift();
			}
			super.dispose();
		}
		
		public function get getRoadNodes():Vector.<MapRoadNodeComp> {
			return joinNodes;
		}
		
		public function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
		}
	}
}