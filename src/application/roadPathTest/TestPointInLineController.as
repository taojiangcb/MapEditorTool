package application.roadPathTest
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import application.db.RoadPathNodeVO;
	import application.utils.appData;
	import application.utils.appDataProxy;
	import application.utils.roadDataProxy;
	
	import gframeWork.uiController.WindowUIControllerBase;
	
	public class TestPointInLineController extends WindowUIControllerBase
	{
		
		private var cirs:Vector.<circle>;
		
		private var addCir:circle;
		
		public function TestPointInLineController() {
			super();
			cirs = new Vector.<circle>();
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			initNodes();
			
			addCir = new circle(0x00FF00,10,null);
			addCir.visible = false;
			ui.addElement(addCir);
			
			ui.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler,false,0,true);
			ui.addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
			ui.addEventListener(Event.ENTER_FRAME,enterFrameHandler,false,0,true);
		}
		
		private function initNodes():void {
			
			appData.roadKey = ["1,2"];
			
			var stpt1:RoadPathNodeVO = new RoadPathNodeVO();
			stpt1.fromCityId = 1;
			stpt1.toCityId = 2;
			stpt1.x = 116;
			stpt1.y = 31;
			stpt1.sortIndex = 0;
			appData.roadPathNodes.push(stpt1);
			
			var stpt2:RoadPathNodeVO = new RoadPathNodeVO();
			stpt2.fromCityId = 1;
			stpt2.toCityId = 2;
			stpt2.x = 186;
			stpt2.y = 101;
			stpt2.sortIndex = 1;
			appData.roadPathNodes.push(stpt2);
			
			var stpt3:RoadPathNodeVO = new RoadPathNodeVO();
			stpt3.fromCityId = 1;
			stpt3.toCityId = 2;
			stpt3.x = 259;
			stpt3.y = 174;
			stpt3.sortIndex = 2;
			appData.roadPathNodes.push(stpt3);
			
			var stpt4:RoadPathNodeVO = new RoadPathNodeVO();
			stpt4.fromCityId = 1;
			stpt4.toCityId = 2;
			stpt4.x = 198;
			stpt4.y = 235;
			stpt4.sortIndex = 3;
			appData.roadPathNodes.push(stpt4);
			
			var stpt5:RoadPathNodeVO = new RoadPathNodeVO();
			stpt5.fromCityId = 1;
			stpt5.toCityId = 2;
			stpt5.x = 119;
			stpt5.y = 235;
			stpt5.sortIndex = 4;
			appData.roadPathNodes.push(stpt5);
			
			var pathNodes:Array = roadDataProxy.getRoadNodes(1,2);
			var i:int = pathNodes.length;
			while(--i > -1) {
				var cir:circle = new circle(0xFF0000,10,pathNodes[i]);
				cir.x = pathNodes[i].x;
				cir.y = pathNodes[i].y;
				cirs.push(cir);
				ui.abc.addChild(cir);
			}
		}
		
		private function moveHandler(event:MouseEvent):void {
			if(event.ctrlKey) {
				var test:int = roadDataProxy.testPointInLine(1,2,ui.mouseX,ui.mouseY);
				if(test) {
					addCir.visible = true;
					addCir.x = ui.mouseX;
					addCir.y = ui.mouseY;
				} else {
					addCir.visible = false;
				}
			} else {
				addCir.visible = false;	
			}
		}
		
		private function enterFrameHandler(event:Event):void {
			updateDraw();
		}
		
		private function updateDraw():void {
			var g:Graphics = ui.abc.graphics;
			g.clear();
			g.lineStyle(1,0);
			var i:int = cirs.length;
			if(i > 0) g.moveTo(cirs[i - 1].x,cirs[i - 1].y);
			while(--i > -1) g.lineTo(cirs[i].x,cirs[i].y);
		}
		
		public override function dispose():void {
			if(ui) {
				ui.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				ui.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}
			super.dispose();
		}
		
		private function clickHandler(event:MouseEvent):void {
			if(event.ctrlKey) {
				var test:int = roadDataProxy.testPointInLine(1,2,ui.mouseX,ui.mouseY);
				if(test) {
					var pathNode:RoadPathNodeVO = roadDataProxy.addRoadNode(1,2,ui.mouseX,ui.mouseY,test);
					if(pathNode) {
						var cir:circle = new circle(0xFF0000,10,pathNode);
						cir.x = pathNode.x;
						cir.y = pathNode.y;
						cirs.push(cir);
						ui.abc.addChild(cir);
						updateNodeList();
					}
				}
			} else if(event.shiftKey) {
				var cir:circle = event.target as circle;
				if(cir) {
					var index:int = cirs.indexOf(cir);
					if(index > -1) cirs.splice(index, 1);
					if(cir.parent) {
						cir.parent.removeChild(cir);
					}
					roadDataProxy.delPathNode(cir.nodeInfo.fromCityId,cir.nodeInfo.toCityId,cir.sortIndex);
					updateNodeList();
				}
			}
		}
		
		private function updateNodeList():void {
			
			cirs.sort(function(a:circle,b:circle):int {
				if(a.sortIndex > b.sortIndex) return 1;
				if(a.sortIndex < b.sortIndex) return -1;
				return 0;
			});
				
			var i:int = cirs.length;
			while(--i > -1) {
				cirs[i].updateLabel();
			}
		}
		
		private function get ui():TestPointInLinePanel {
			return mGUI as TestPointInLinePanel;
		}
	}
}