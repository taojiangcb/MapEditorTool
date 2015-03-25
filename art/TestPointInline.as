package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class TestPointInline extends Sprite {
		
		private var beginPoint:Point;
		private var endPoint:Point;
		
		
		
		public function TestPointInline() {
			// constructor code
			
		}
		
		private function internalInit():void {
			beginPoint = new Point(100,100);
			endPoint = new Point(300,300);
		}
	}
	
}
