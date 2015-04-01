package application.roadPathTest
{
	import flash.geom.Point;
	
	import application.db.RoadPathNodeVO;
	import application.utils.roadDataProxy;
	
	import starling.core.Starling;

	public class RunController
	{
		
		private var runTime:int = 15;
		
		private var paths:Array = [];
		
		private var joinPoint:Array;
		
		public function RunController() {
			
		}
		
		/**
		 * 按运动的时时间来分析一条路径的所有运动轨迹节点 
		 * @param fromId
		 * @param toId
		 * @param runTime
		 * @return 
		 * 
		 */		
		public function analysisPath(fromId:Number,toId:Number,runTime:uint):Array {
			var pathNodes:Array = roadDataProxy.getRoadNodes(fromId,toId);
			var vector:Number = getRunVector(fromId,toId,runTime)		//运动的时间向量
			var res:Array = [];
			
			var len:int = pathNodes.length;
			var i:int = 0;
			
			var pt1:Point = new Point();
			var pt2:Point = new Point();
			
			var pt3:Point = new Point();
			
			var vectorPoint:Point = new Point();						//运动的轨迹向量
			var radian:Number = 0;
			
			var nowDistance:Number = 0;
			var limitedDistance:Number = 0;
			
			var addFirst:Boolean = false;
			
			for(i = 0; i != len; i++) {
				if(i == len - 1) break;
				
				pt1.x = RoadPathNodeVO(pathNodes[i]).x;						//起点位置
				pt1.y = RoadPathNodeVO(pathNodes[i]).y;					
				
				pt2.x = RoadPathNodeVO(pathNodes[i + 1]).x;					//终点位置
				pt2.y = RoadPathNodeVO(pathNodes[i + 1]).y;
				
				radian = PointUtils.calcRadian(pt1,pt2);					//两点之间的弧度
				vectorPoint = PointUtils.calcVector(radian,vector);			//两点之间的运动向量
				
				if(!addFirst) {
					addFirst = true;
					res.push(pt1.x,pt1.y);									//添加路径两点的开始节点
				}
				
				pt3.x = pt1.x + vectorPoint.x;
				pt3.y = pt1.y + vectorPoint.y;
				
				nowDistance = Point.distance(pt3,pt2);
				limitedDistance = Point.distance(new Point(pt2.x - vectorPoint.x,pt2.y - vectorPoint.y),pt2);
				
				while(nowDistance > limitedDistance) {
					res.push(pt3.x,pt3.y);
					pt3.x += vectorPoint.x;
					pt3.y += vectorPoint.y;
					nowDistance = Point.distance(pt3,pt2);
				}
			}
			res.push(pt2.x,pt2.y);										//全路径的最后一点
			return res;
		}
		
		/**
		 * 根据开始时间获取运动开始的坐标位置
		 * @param startime
		 * @param fromId
		 * @param toId
		 * @param runTime
		 * @return 
		 * 
		 */		
		public function getStartPosition(startime:Number,runTime:uint):Number {
			return startime / runTime;										//开始路径的节点
		}
		
		/**
		 * 返回运动的时间向量 
		 * @param fromId
		 * @param toId
		 * @param runTime
		 * @return 
		 * 
		 */		
		public function getRunVector(fromId:Number,toId:Number,runTime:uint):Number {
			var pathNodes:Array = roadDataProxy.getRoadNodes(fromId,toId);
			var pathDisatnce:Number = getDistanceByPath(pathNodes);
			var vector:Number = pathDisatnce / runTime;	
			return vector / 120;
		}
		
		/**
		 * 获取一条路径的总长度 
		 * @param nodes		一条路径的所有节点
		 * @return 
		 * 
		 */		
		public function getDistanceByPath(nodes:Array):Number {
			var len:int = nodes.length;
			var i:int = 0;
			var distance:int = 0;
			var pt1:Point = new Point();
			var pt2:Point = new Point();
			for(i = 0; i != len; i++) {
				if(i == len - 1) break;
				pt1.x = RoadPathNodeVO(nodes[i]).x;
				pt1.y = RoadPathNodeVO(nodes[i]).y;
				
				pt2.x = RoadPathNodeVO(nodes[i + 1]).x;
				pt2.y = RoadPathNodeVO(nodes[i + 1]).y;
				
				distance += Point.distance(pt1,pt2);
			}
			return distance;
		}
	}
}