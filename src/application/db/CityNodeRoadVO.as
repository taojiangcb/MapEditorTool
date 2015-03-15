package application.db
{
	import flash.geom.Point;

	/**
	 * 城市道路数据结构 
	 * @author taojiang
	 * 
	 */	
	public class CityNodeRoadVO
	{
		public var roadId:int = 0;									//道路id
		public var fromId:int = 0;									//起点
		public var toCityId:int = 0;								//终点
		public var points:Vector.<Point> = new Vector.<Point>();	//节点
		public var reversal:Boolean = false;						//是否反转节点
		public function CityNodeRoadVO(){
			
		}
	}
}