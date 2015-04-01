package application.roadPathTest
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	public class TestRoadRole extends UIComponent
	{
		private var role:circle;
		private var control:RunController;
		private var nowPosition:int = 0;
		
		private var points:Array = [];
		private var startPosition:int = 0;
		
		private var gt:GTween;
		
		private var tTime:Number = 0;
		
		public function TestRoadRole(){
			super();
			
			role = new circle(0x0000FF,10,null);
			addChild(role);
			
			control = new RunController();
			mouseChildren = false;
			mouseEnabled = false;
		}
			
		public function run(fromId:Number,toId:Number,totalTime:Number,startTime:Number):void {
			points = control.analysisPath(fromId,toId,totalTime);
			startPosition = control.getStartPosition(startTime,totalTime) * (points.length / 2);
			tTime = totalTime;
			
			var px:int = startPosition * 2;
			var py:int = startPosition * 2 + 1;
			
			nowPosition = startPosition;
			
			x = points[px];
			y = points[py];
			
			toNextPoint();
		}
		
		private function toNextPoint():void {
			var nextPosition:int = nowPosition + 1;
			var px:int = nextPosition * 2;
			var py:int = nextPosition * 2 + 1;
			
			if(px < points.length) {
				if(gt) gt.paused = true;
				gt = null;
				gt = new GTween(this,tTime / (points.length / 2),{x:points[px],y:points[py]},{ease:Linear.easeNone});
				gt.onComplete = function(g:GTween):void {
					nowPosition = nextPosition;
					toNextPoint();
				}
			} else {
				if(gt) gt.paused = true;
				gt = null;
			}
		}
	}
}