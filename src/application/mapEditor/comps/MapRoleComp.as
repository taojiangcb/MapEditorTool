package application.mapEditor.comps
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweenTimeline;
	
	import flash.geom.Point;
	
	import application.road.RoutePannelResult;
	import application.roadPathTest.RunController;
	import application.utils.appData;
	
	import starling.display.Image;
	import starling.extensions.CustomFeathersControls;
	
	/**
	 * 角色移动组件 
	 * @author JiangTao
	 * 
	 */	
	public class MapRoleComp extends CustomFeathersControls 
	{
		
		private var img:Image;
		private var gtline:GTweenTimeline;
		private var runPath:RunController;
		
		public function MapRoleComp(listenCreateComplete:Boolean=false) {
			super(listenCreateComplete);
			runPath = new RunController();
		}
		
		protected override function initialize():void {
			super.initialize();
			img = new Image(appData.textureManager.getTexture("redsolider"));
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;
			addChild(img);
		}
		
		public function run(routeRes:RoutePannelResult,stime:uint,totalTime:uint):void {

			var allNodes:Array = runPath.getRoadNodesByRoute(routeRes);
			var runRes:Object = runPath.getRunJoinPoints(allNodes,stime,totalTime);
			
			if(!runRes) return;
			
			var allPoint:Array = runRes["points"];
			var allTimes:Array = runRes["times"];
			if(gtline) gtline.paused = true;
			gtline = new GTweenTimeline(this);
			var i:int = 0;
			var len:int = allPoint.length;
			var totalTimes:Number = 0;
			x = allPoint[0].x;
			y = allPoint[0].y;
			for(i = 1; i != len; i++) {
				gtline.addTween(totalTimes,new GTween(this,allTimes[i - 1],{x:allPoint[i].x,y:allPoint[i].y}));
				totalTimes += allTimes[i - 1];
			}
			gtline.calculateDuration();
		}
		
		public override function dispose():void {
			if(gtline) gtline.paused = true;
		}
	}
}