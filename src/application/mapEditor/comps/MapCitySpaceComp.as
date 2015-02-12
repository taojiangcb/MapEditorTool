package application.mapEditor.comps
{
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.graphicPack.Graphics;
	
	public class MapCitySpaceComp extends Sprite implements IAnimatable
	{
		public var cityQuadBatch:QuadBatch;
		
		public var roadGraphics:Graphics;
		
		private var roadSpace:Sprite;
		
		public function MapCitySpaceComp() {
			super();
			cityQuadBatch = new QuadBatch();
			addChild(cityQuadBatch);
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
			
			roadSpace = new Sprite();
			addChild(roadSpace);
			
			roadGraphics = new Graphics(roadSpace);
		}
		
		private function addToStageHandler(event:Event):void {
			Starling.juggler.add(this);
		}
		
		private function removeToStageHandler(event:Event):void {
			Starling.juggler.remove(this);
		}
		
		public function advanceTime(time:Number):void {
			//reset();
		}
		
		public function reset():void {
			cityQuadBatch.reset();	
			var len:int = numChildren;
			var child:DisplayObject;
			while(--len > -1) {
				child = getChildAt(len);
				if(child is MapCityNodeComp) {
					var cityImage:Image = MapCityNodeComp(child).ctImage;
					if(cityImage) {
						cityQuadBatch.addImage(cityImage);
						cityImage.x = child.x;
						cityImage.y = child.y;
					}
				}
			}
		}
		
		public override function dispose():void {
			removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removeToStageHandler);
			Starling.juggler.remove(this);
			super.dispose();
		}
	}
}