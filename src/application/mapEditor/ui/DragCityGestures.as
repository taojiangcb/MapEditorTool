package application.mapEditor.ui
{
	import com.frameWork.gestures.DragGestures;
	
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	public class DragCityGestures extends DragGestures
	{
		public function DragCityGestures(target:DisplayObject, callBack:Function=null) {
			super(target, callBack);
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				_downPoint = touch.getLocation(_target.stage);
				DragScrollGestures.CAN_DRAG = false;
			}else if(touch.phase == TouchPhase.MOVED){
				var movePoint:Point = touch.getLocation(_target.stage);
				_target.x += movePoint.x - _downPoint.x;
				_target.y += movePoint.y - _downPoint.y;
				_downPoint = movePoint;
				if(_dragRect) checkTargetPosition();
				if(_callBack) _callBack();
				_isDrag = true;
			}else if(touch.phase == TouchPhase.ENDED){
				_downPoint = null;
				_isDrag = false;
				DragScrollGestures.CAN_DRAG = true;
			}
		}
	}
}