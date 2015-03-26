package application.roadPathTest
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.UIComponent;
	
	import application.db.RoadPathNodeVO;
	
	public class circle extends UIComponent
	{
		private var colour:uint = 0;
		private var mr:int = 0;
		private var pathNode:RoadPathNodeVO;
		
		private var label:TextField;
		
		private var isDrag:Boolean = false;
		public function circle(color:uint,radius:int,node:RoadPathNodeVO){
			super();
			colour = color;
			mr = radius;
			pathNode = node;
			draw();
			
			label = new TextField();
			label.width = 14;
			label.height = 18;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.x = width - 14 >> 1;
			label.y = height - 18 >> 1;
			label.selectable = false;
			label.mouseEnabled = false;
			addChild(label);
			
			if(pathNode) {
				addEventListener(MouseEvent.MOUSE_DOWN,downHandler,false,0,true)
				updateLabel();
			}
		}
		
		private function downHandler(event:MouseEvent):void {
			isDrag = true;
			this.startDrag();
			if(stage) stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);
			
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			isDrag = false;
			this.stopDrag();
			if(pathNode) {
				pathNode.x = x;
				pathNode.y = y;
			}
		}
		
		private function draw():void {
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(colour,mr);
			g.drawCircle(0,0,mr);
			g.endFill();
		}
		
		public function updateLabel():void {
			if(pathNode) {
				label.text = (pathNode.sortIndex + 1).toString();
			}
		}
		
		public function get nodeInfo():RoadPathNodeVO {
			return pathNode;
		}
			
		public function get sortIndex():int {
			return pathNode ? pathNode.sortIndex : 0;
		}
	}
}