package application.road
{
	import application.db.CityNodeVO;
	import application.db.MapCityNodeRoadVO;

	public class RoutePanner
	{
		public function RoutePanner() {};
		
		/**
		 * 路径归划计算 
		 * @param nodeList
		 * @param originId
		 * @param destId
		 * @return 
		 */		
		public function planner(nodeList:Vector.<CityNodeVO>,originId:Number,destId:Number):RoutePannelResult {
			if(originId == destId) return null;
			var panCoures:PlanCourse = new PlanCourse(nodeList,originId);
			var curNode:CityNodeVO = getMinWeightCity(panCoures,nodeList,originId);
			if(curNode) {
				while(curNode && curNode.templateId != destId) {
					var curPath:PassedPath = panCoures.pathCache[curNode.templateId];
					var nodeRoads:Vector.<MapCityNodeRoadVO> = curNode.toRoads;
					var road:MapCityNodeRoadVO;
					var i:int = nodeRoads.length;
					while(--i > -1) {
						road = nodeRoads[i];
						if(road.toCityId == originId) continue;
						var targetPath:PassedPath = panCoures.pathCache[road.toCityId];
						if(!targetPath) continue;
						var tempWeight:Number = curPath.weight + road.distance;
						if(tempWeight < targetPath.weight) {
							targetPath.weight = tempWeight;
							targetPath.passedPathList = [];
							var ci:int = curPath.passedPathList.length;
							while(--ci > -1) {
								targetPath.passedPathList.unshift(curPath.passedPathList[ci]);
							}
							targetPath.passedPathList.push(curNode.templateId);
						}
					}
					PassedPath(panCoures.pathCache[curNode.templateId]).beProcesseed = true;
					curNode = getMinWeightCity(panCoures,nodeList,originId);
				}
			}
			return getResult(panCoures,destId,originId);
		}
		
		/**
		 * 获取寻路结果 
		 * @param planCourse
		 * @param destId
		 * @param orignId
		 * @return 
		 * 
		 */		
		private function getResult(planCourse:PlanCourse,destId:uint,orignId:uint):RoutePannelResult {
			var path:PassedPath = planCourse.pathCache[destId] as PassedPath;
			if(!path || path.weight == Number.MAX_VALUE) {
				return new RoutePannelResult(null,Number.MAX_VALUE);
			}
			return new RoutePannelResult(path.passedPathList,path.weight);
		}
		
		/**
		 * 获取最短路径节点 
		 * @param planCourse
		 * @param cityList
		 * @param originId
		 * @return 
		 * 
		 */		
		public function getMinWeightCity(planCourse:PlanCourse,cityList:Vector.<CityNodeVO>, originId:Number):CityNodeVO {
			var weight:Number = Number.MAX_VALUE;
			var destNode:CityNodeVO = null;
			var i:int =cityList.length;
			var node:CityNodeVO;
			while(--i > -1) {
				node = cityList[i];
				if(node.templateId == originId) continue;
				var path:PassedPath = planCourse.pathCache[node.templateId];
				if(path.beProcesseed) continue;
				if(path.weight < weight) {
					weight = path.weight;
					destNode = node;
				}
			}
			return destNode;
		}
	}
}