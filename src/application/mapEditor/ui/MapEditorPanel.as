package application.mapEditor.ui
{
	import application.mapEditor.comps.MapFloorComp;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.CustomFeathersControls;
	
	public class MapEditorPanel extends CustomFeathersControls
	{
		public var uiContent:Sprite;
		
		public var citySpace:Sprite;
		public var mapFloor:MapFloorComp;
		
		public function MapEditorPanel(listenCreateComplete:Boolean=false) {
			super(true);
		}
		
		protected override function initialize():void {
			super.initialize();
			uiContent = new Sprite();
			addChild(uiContent);
			
			mapFloor = new MapFloorComp();
			uiContent.addChild(mapFloor);
			
			citySpace = new Sprite();
			uiContent.addChild(citySpace);
		}
		
		protected override function createCompleteHandler(event:Event):void {
			super.createCompleteHandler(event);
		}
	}
}