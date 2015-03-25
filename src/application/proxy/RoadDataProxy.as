package application.proxy
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import application.AppReg;
	import application.db.CityNodeVO;
	import application.db.RoadPathNodeVO;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.utils.appData;
	import application.utils.appDataProxy;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RoadDataProxy extends Proxy
	{
		public function RoadDataProxy(proxyName:String=null, data:Object=null){
			super(proxyName);
		}
		
		public function initRoadNodes(lines:Array):void {
			appData.roadPathNodes = new Vector.<RoadPathNodeVO>();
			var len:int = lines.length = 0;
			while(--len > -1) {
				var nodeDb:RoadPathNodeVO = new RoadPathNodeVO();
				nodeDb.fromCityId = lines[len][0];
				nodeDb.toCityId = lines[len][1];
				nodeDb.sortIndex = lines[len][2];
				nodeDb.x = lines[len][3];
				nodeDb.y = lines[len][4];
				appData.roadPathNodes.push(nodeDb);
			}
		}
		
		/**
		 * 创建绑定一条道路和路径
		 * @param fromid	起点城市
		 * @param toId		终点城市
		 */		
		public function createBindRoad(fromid:Number,toId:Number):void {
			var oldRoadKey:Array = getRoadKeyAry(fromid,toId);
			if(!oldRoadKey) {
				var key:String = [fromid,toId].join(",");
				appData.roadKey.push(key);
			}
		}
		
		/**
		 * 删除一整条路径啊 
		 * @param fromId
		 * @param toId
		 */		
		public function delRoad(fromId:Number,toId:Number):void {
			var keys:Array = getRoadKeyAry(fromId,toId);
			var existIndex:int = -1;
			if(keys) {
				var keystr:String = keys.join(",");
				existIndex = appData.roadKey.indexOf(keystr);
				if(existIndex > -1) appData.roadKey.splice(existIndex);
				
				var i:int = appData.roadPathNodes.length;
				var node:RoadPathNodeVO = null;
				var clears:Array;
				while(--i > -1) {
					node = appData.roadPathNodes[i];
					if(node.fromCityId == keys[0] && node.toCityId == keys[1]) {
						clears.push(node);
					}
				}
				
				while(clears.length > 0) {
					node = clears.shift();
					existIndex = appData.roadPathNodes.indexOf(node);
					if(existIndex > -1) appData.roadPathNodes.splice(existIndex,1);
				}
			}
		}
		
		/**
		 * 添加一个路径节点 
		 * @param fromid
		 * @param toid
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function addRoadNode(fromid:Number,toid:Number,x:int,y:int):RoadPathNodeVO {
			return null;
		}
		
		/**
		 * 测试一个点是否在一条路径上 
		 * @param fromId
		 * @param toid
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function testPointInLine(fromId:Number,toId:Number,x:int,y:int):Boolean {
			var pathNodes:Array = getRoadNodes(fromId,toId);
			var len:int = pathNodes.length;
			var i:int = 0;
			var node1:RoadPathNodeVO;
			var node2:RoadPathNodeVO;
			
			var pt1:Point = new Point();
			var pt2:Point = new Point();
			var pt3:Point = new Point();
			
			for(i = 0; i != len - 1; i++) {
				if(i == len - 1) break;
				
				node1 = pathNodes[i];
				node2 = pathNodes[i + 1];
				
				pt1.x = node1.x;
				pt1.y = node1.y;
				
				pt2.x = node2.x;
				pt2.y = node2.y;
				
				var radius:int = Point.distance(pt1,pt2) >> 1;
				var angle:Number = Math.atan2(pt2.y - pt1.y, pt2.x - pt1.x);
				
				pt3.x = pt1.x + Math.cos(angle) * radius;
				pt3.y = pt1.y + Math.sin(angle) * radius;
			}
		}
		
		/**
		 * 删除一个节点 
		 * @param fromId
		 * @param toId
		 * @param sortId
		 * 
		 */		
		public function delPathNode(fromId:Number,toId:Number,sortId:int):Boolean {
			var keys:Array = getRoadKeyAry(fromId,toId);
			if(keys) {
				var i:int = appData.roadPathNodes.length;
				var node:RoadPathNodeVO = null;
				var existIndex:int = -1;
				while(--i > -1) {
					node = appData.roadPathNodes[i];
					if(node.fromCityId == keys[0] && node.toCityId == keys[1] && node.sortIndex == sortId) {
						existIndex = i;
						break;
					}
				}
				if(existIndex > -1) {
					appData.roadPathNodes.splice(existIndex,1);
					//后续节点递减-1
					updateNodeSort(fromId,toId,node.sortIndex,-1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 更新节的排序id 
		 * @param fromId
		 * @param toId
		 * @param beginSortId
		 * @param plus
		 */		
		public function updateNodeSort(fromId:Number,toId:Number,beginSortId:int,plus:int):void {
			var pathNodes:Array = getRoadNodes(fromId,toId);
			var i:int = pathNodes.length;
			while(--i > -1) {
				if(RoadPathNodeVO(pathNodes[i]).sortIndex >= beginSortId) {
					RoadPathNodeVO(pathNodes[i]).sortIndex += plus;
				}
			}
		}
		
		/**
		 * 获取一条道路的节点列表数据 
		 * @param fromId
		 * @param toId
		 * @return 
		 */		
		public function getRoadNodes(fromId:Number,toId:Number):Array {
			var res:Array = [];
			var keys:Array = getRoadKeyAry(fromId,toId);
			if(keys) {
				
				var fromPoint:RoadPathNodeVO = new RoadPathNodeVO();
				fromPoint.sortIndex = 0;
				fromPoint.fromCityId = keys[0];
				fromPoint.toCityId = keys[1];
				var fromCity:MapCityNodeComp = mapEditor.getCityComp(fromId);
				fromPoint.x = fromCity.x + fromCity.width / 2;
				fromPoint.y = fromCity.y + fromCity.height / 2;
				res.push(fromPoint)
				
				var i:int = appData.roadPathNodes.length;
				while(--i > -1) {
					if(appData.roadPathNodes[i].fromCityId == keys[0] && appData.roadPathNodes[i].toCityId == keys[1]) {
						res.push(appData.roadPathNodes[i]);
					}
				}
				
				var toPoint:RoadPathNodeVO = new RoadPathNodeVO();
				toPoint.fromCityId = keys[0];
				toPoint.toCityId = keys[1];
				toPoint.sortIndex = res.length;
				var toCity:MapCityNodeComp = mapEditor.getCityComp(toId);
				toPoint.x = toCity.x + toCity.width / 2;
				toPoint.y = toCity.y + toCity.height / 2;
				res.push(toPoint);
				
				if(isReverseRoad(fromId,toId)== 1)	res.sortOn("sortIndex",Array.NUMERIC);							//正序排列路径节点		
				else 								res.sortOn("sortIndex",Array.DESCENDING | Array.NUMERIC);		//反向路径倒序排序路径节点
			}
			return res;
		}
		
		/**
		 * 是否是反向道路 
		 * @param fromId	
		 * @param toId
		 * @return 
		 * 		返回的是1表示正向道路
		 * 		返回的是2表示反向道路
		 * 		返回的是0表示无此道路
		 */		
		public function isReverseRoad(fromId:Number,toId:Number):int {
			var keys:Array = getRoadKeyAry(fromId,toId);
			if(keys) {
				if(keys[0] == fromId && toId == keys[1]) return 1;
				return 2;
			}
			return 0;
		}
		
		/**
		 * 获路径的key返回字符串 
		 * @param fromId
		 * @param toId
		 * @return 
		 */		
		public function getRoadKeyStr(fromId:Number,toId:Number):String {
			var len:int = appData.roadKey.length;
			while(--len > -1) {
				var keys:Array = String(appData.roadKey[len]).split(",");
				if((fromId == keys[0] && toId == keys[1]) || (fromId == keys[1] && toId == keys[0])) {
					return keys.join(",");
				}
			}
			return null;
		}
		
		/**
		 * 获取路径的key
		 * @param fromId
		 * @param toId
		 * 
		 */		
		public function getRoadKeyAry(fromId:Number,toId:Number):Array {
			var len:int = appData.roadKey.length;
			while(--len > -1) {
				var keys:Array = String(appData.roadKey[len]).split(",");
				if((fromId == keys[0] && toId == keys[1]) || (fromId == keys[1] && toId == keys[0])) {
					return keys;
				}
			}
			return null;
		}
		
		private function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller
		}
		
		public static function get NAME():String{
			return getQualifiedClassName(RoadDataProxy);
		}
	}
}