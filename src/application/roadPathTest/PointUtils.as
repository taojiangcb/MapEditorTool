package application.roadPathTest
{
	import flash.geom.Point;

	public class PointUtils
	{
		
		public function PointUtils() {
			
		}
		
		/**
		 * 获取两点的弧度 
		 * @param pt1
		 * @param pt2
		 */		
		public static function calcRadian(pt1:Point,pt2:Point):Number {
			return Math.atan2(pt2.y - pt1.y,pt2.x - pt1.x);
		}
		
		/**
		 * 根据一个弧度和一个半径来获取个一个节点的向量 
		 * @param radian
		 * @param radius
		 * @return 
		 */		
		public static function calcVector(radian:Number,radius:Number,resPoint:Point = null):Point{
			var vectorPoint:Point = resPoint ? resPoint : new Point();
			vectorPoint.x = Math.cos(radian) * radius;
			vectorPoint.y = Math.sin(radian) * radius;
			return vectorPoint;
		}
	}
}