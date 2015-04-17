package application.proxy
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		private var leftEndPoint:RoadPathNodeVO;					//路径左节点
		private var rightEndPoint:RoadPathNodeVO;					//路径右节点
		
		private var middlePoint:Point = new Point();				//左右节点的中间的位置,跟据半径距离计算得到的。
		private var radiuDistance:Number = 0;						//左右节点的关径距离
		
		private var radian:Number = 0;								//左右节点的弧度								
		private var theTestRadian:Number = 0;						//当前测试点的左节点的弧度
		
		private var leftPoint:Point = new Point();					//左节点的位置
		private var rightPoint:Point = new Point();				//右节点的位置		
		private var acceptRadian:Number = 5 * Math.PI / 180;		//可接受新节点的弧度范围 
		private var theTestPoint:Point = new Point();				//当前测试的点
		
		private var checkGAP:int = 15; 							//检测的边距		
		
		public var isTest:Boolean = false;							//
		
		
		public function RoadDataProxy(proxyName:String=null, data:Object=null){
			super(proxyName);
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
		 * 更新所有节点的关联城市 
		 * @param oldCityId
		 * @param newCityId
		 * 
		 */		
		public function updateCityId(oldCityId:Number,newCityId:Number):void {
			var i:int = appData.roadKey.length;
			while(--i > -1) {
				var key:String = appData.roadKey[i];
				var keys:Array = key.split(",");
				
				if(Number(keys[0]) == oldCityId) 		keys[0] = newCityId;
				else if(Number(keys[1]) == oldCityId)	keys[1] = newCityId;
				
				appData.roadKey[i] = keys.join(",");
			}
			
			i = appData.roadPathNodes.length;
			while(--i > -1) {
				var roadPathNodeInfo:RoadPathNodeVO = RoadPathNodeVO(appData.roadPathNodes[i]);
				if(roadPathNodeInfo.fromCityId == oldCityId)		roadPathNodeInfo.fromCityId = newCityId;
				else if(roadPathNodeInfo.toCityId == oldCityId)		roadPathNodeInfo.toCityId = newCityId;
			}
		}
		
		/**
		 * 更新一条路径上所有的节点 
		 * @param oldFromId
		 * @param oldToId
		 * @param fromId
		 * @param toId
		 * 
		 */		
		public function updateRoadNodes(oldFromId:Number,oldToId:Number,fromId:Number,toId:Number):void {
			var oldRoadKey:Array = getRoadKeyAry(oldFromId,oldToId);
			if(oldRoadKey) {
				
				var roadKeyStr:String = getRoadKeyStr(oldFromId,oldToId);
				var existIndex:int = appData.roadKey.indexOf(roadKeyStr);
				
				var newRoadKey:Array = oldRoadKey.concat();
				
				if(oldRoadKey[0] == fromId)			newRoadKey[1] = toId;
				else if(oldRoadKey[0] == toId)		newRoadKey[1] = fromId;
				else if(oldRoadKey[1] == toId)		newRoadKey[0] = fromId;
				else if(oldRoadKey[1] == fromId)	newRoadKey[0] = toId;
				
				var roadNodes:Array = getRoadNodes(oldFromId,oldToId);
				var i:int = roadNodes.length;
				while(--i > -1) {
					RoadPathNodeVO(roadNodes[i]).fromCityId = newRoadKey[0];
					RoadPathNodeVO(roadNodes[i]).toCityId = newRoadKey[1];
				}
				appData.roadKey[existIndex] = newRoadKey.join(",");
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
				if(appData.EDIT_ROAD_ID == getRoadKeyStr(fromId,toId)) appData.EDIT_ROAD_ID = "";
				
				var keystr:String = keys.join(",");
				existIndex = appData.roadKey.indexOf(keystr);
				if(existIndex > -1) appData.roadKey.splice(existIndex,1);
				
				var i:int = appData.roadPathNodes.length;
				var node:RoadPathNodeVO = null;
				var clears:Array = [];
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
					existIndex = -1;
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
		public function addRoadNode(fromId:Number,toId:Number,x:int,y:int,sortIndex:int):RoadPathNodeVO {
			var keys:Array = getRoadKeyAry(fromId,toId);
			if(keys) {
				//后结节点全都自增长1
				updateNodeSort(fromId,toId,sortIndex,1);
				
				var roadNode:RoadPathNodeVO = new RoadPathNodeVO();
				roadNode.fromCityId = keys[0];
				roadNode.toCityId = keys[1];
				roadNode.x = x;
				roadNode.y = y;
				roadNode.sortIndex = sortIndex;
				appData.roadPathNodes.push(roadNode);
				
				return roadNode;
			}
			return null;
		}
		
		/**
		 * 测试一个点是否在一条路径上,并且返回当前节点所在的序列 
		 * @param fromId
		 * @param toId
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */				
		public function testPointInLine(fromId:Number,toId:Number,x:int,y:int):int {
			var pathNodes:Array = getRoadNodes(fromId,toId);
			var len:int = pathNodes.length;
			var i:int = 0;
			//当前被检测的点
			var testPoint:Point = new Point(x,y);
			
			for(i = 0; i != len - 1; i++) {
				if(i == len - 1) break;
				
				leftEndPoint = pathNodes[i];
				rightEndPoint = pathNodes[i + 1];
				
				leftPoint.x = leftEndPoint.x;
				leftPoint.y = leftEndPoint.y;
				
				rightPoint.x = rightEndPoint.x;
				rightPoint.y = rightEndPoint.y;
				
				radiuDistance = Point.distance(leftPoint,rightPoint) >> 1;					//两个端点之间的半径
				radian = Math.atan2(rightPoint.y - leftPoint.y, rightPoint.x - leftPoint.x);	//两个端点之间的弧度
				
				middlePoint.x = leftPoint.x + Math.cos(radian) * radiuDistance;
				middlePoint.y = leftPoint.y + Math.sin(radian) * radiuDistance;
				
				theTestRadian = Math.atan2(testPoint.y - leftPoint.y,testPoint.x - leftPoint.x);
				
				var leftLimited:Point = new Point();
				leftLimited.x = Math.min(leftPoint.x,rightPoint.x) - checkGAP;
				leftLimited.y = Math.min(leftPoint.y,rightPoint.y) - checkGAP;
				
				var rightLimited:Point = new Point();
				rightLimited.x = Math.max(leftPoint.x,rightPoint.x) + checkGAP;
				rightLimited.y = Math.max(leftPoint.y,rightPoint.y) + checkGAP;
				
				if(Math.abs(theTestRadian - radian) <= acceptRadian
					&& testPoint.x >= leftLimited.x && testPoint.y >= leftLimited.y
					&& testPoint.x <= rightLimited.x && testPoint.y <= rightLimited.y) {
					return rightEndPoint.sortIndex;
				}
			}
			return 0;
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
				
				if(!isTest) {
					var fromPoint:RoadPathNodeVO = new RoadPathNodeVO();
					fromPoint.sortIndex = 0;
					fromPoint.fromCityId = keys[0];
					fromPoint.toCityId = keys[1];
					var fromCity:MapCityNodeComp = mapEditor.getCityComp(keys[0]);
					fromPoint.x = fromCity.x + fromCity.width / 2;
					fromPoint.y = fromCity.y + fromCity.height / 2;
					res.push(fromPoint)
				}
				
				var i:int = appData.roadPathNodes.length;
				while(--i > -1) {
					if(appData.roadPathNodes[i].fromCityId == keys[0] && appData.roadPathNodes[i].toCityId == keys[1]) {
						res.push(appData.roadPathNodes[i]);
					}
				}
				
				if(!isTest) {
					var toPoint:RoadPathNodeVO = new RoadPathNodeVO();
					toPoint.fromCityId = keys[0];
					toPoint.toCityId = keys[1];
					toPoint.sortIndex = res.length;
					var toCity:MapCityNodeComp = mapEditor.getCityComp(keys[1]);
					toPoint.x = toCity.x + toCity.width / 2;
					toPoint.y = toCity.y + toCity.height / 2;
					res.push(toPoint);
				}
				
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