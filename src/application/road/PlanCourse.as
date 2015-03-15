package application.road
{
	
	import flash.utils.Dictionary;
	
	import application.db.MapCityNodeVO;
	import application.db.MapCityNodeRoadVO;

	/**
	 * 路径分配归划初始
	 * @author JiangTao
	 * 
	 */	
	public class PlanCourse
	{
		/**
		 * 线路缓存 
		 */		
		private var cacheDict:Dictionary;
		
		public function PlanCourse(nodeList:Vector.<MapCityNodeVO>,originId:Number) {
			cacheDict = new Dictionary();
			var originNode:MapCityNodeVO;
			var i:int = nodeList.length;
			while(--i > -1) {
				if (nodeList[i].templateId == originId) {
					originNode = nodeList[i];
				} else {
					var path:PassedPath = new PassedPath(nodeList[i].templateId);
					cacheDict[nodeList[i].templateId] = path;
				}
			}
			
			if(!originNode) {
				throw new Error("The origin node is not exist !") ;
			}
			
			initializeWeight(originNode);
		}
		
		/**
		 * 初始原点的距离
		 * @param node
		 */		
		private function initializeWeight(node:MapCityNodeVO): void {
			var roadList:Vector.<MapCityNodeRoadVO> = node.toRoads;
			if(!roadList || roadList.length == 0) return;
			var i:int = roadList.length;
			while(--i > -1) {
				var path:PassedPath = cacheDict[roadList[i].toCityId];
				if(!path) continue;
				path.passedPathList.push(node.templateId);
				path.weight = roadList[i].distance;
			}
		}
		
		public function get pathCache():Dictionary {
			return cacheDict;
		}
	}
}