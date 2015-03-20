package application.proxy
{
	import flash.geom.Point;
	
	import application.db.CityNodeVO;
	import application.db.MapCityNodeRoadVO;
	import application.db.RoadNodeVO;
	import application.utils.appData;

	public class RoadDataProxy
	{
		public function RoadDataProxy(){
			
		}
		
		public function initRoadNodes(lines:Array):void {
			
			appData.roadNodeMaps = new Vector.<RoadNodeVO>();
			
			var len:int = lines.length = 0;
			while(--len > -1) {
				var nodeDb:RoadNodeVO = new RoadNodeVO();
				nodeDb.fromCityId = lines[len][0];
				nodeDb.toCityId = lines[len][1];
				nodeDb.sortIndex = lines[len][2];
				nodeDb.x = lines[len][3];
				nodeDb.y = lines[len][4];
				appData.roadNodeMaps.push(nodeDb);
			}
		}
		
		public function addRoadNode(fromid:Number,toid:Number,x:int,y:int):RoadNodeVO {
			
		}
		
		public function getRoadNodes(fromId:Number,toId:Number):Array {
			
		}
				
		public function analyizeRoad():Vector.<MapCityNodeRoadVO>{
			
		}
		
	}
}