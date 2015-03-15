package application.road
{
	public class RoutePannelResult
	{
		
		//经过的路径城市Id
		private var passedNodeIds:Array = [];
		
		//实际的距离
		private var weight:Number = 0;
		
		public function RoutePannelResult(ids:Array,allWeigth:Number) {
			passedNodeIds = ids;
			weight = allWeigth;
		}
		
		public function get pathNodeIds():Array {
			return passedNodeIds;
		}
		
		public function get allWeight():Number {
			return weight;
		}
	}
}