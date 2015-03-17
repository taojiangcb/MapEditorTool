package application.db
{
	import flash.geom.Point;

	public class MapCityNodeRoadVO
	{
		public var roadId:int = 0;									//道路id
		public var points:Vector.<Point> = new Vector.<Point>();	//路径的节点
		public var reversal:Boolean = false;						//是否反转节点
		
		public var fromCityId:int = 0;
		public var toCityId:int = 0;
		public var distance:int = 0;
		
		public function MapCityNodeRoadVO() {
			
		}
	}
}