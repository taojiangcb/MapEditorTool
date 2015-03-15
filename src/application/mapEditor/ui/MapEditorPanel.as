package application.mapEditor.ui
{
	import application.mapEditor.comps.MapCitySpaceComp;
	import application.mapEditor.comps.MapFloorComp;
	
	import feathers.core.FeathersControl;
	
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.CustomFeathersControls;
	/**
	 * 地图编辑面板 
	 * @author taojiang
	 */	
	public class MapEditorPanel extends CustomFeathersControls
	{
		public var uiContent:Sprite;
		public var cityQuadSapce:QuadBatch;
		public var citySpace:MapCitySpaceComp;
		public var mapFloor:MapFloorComp;
		
		public function MapEditorPanel() {
			super();
		}
		
		protected override function initialize():void {
			super.initialize();
			uiContent = new Sprite();
			addChild(uiContent);
			
			mapFloor = new MapFloorComp();
			uiContent.addChild(mapFloor);
			
			citySpace = new MapCitySpaceComp();
			uiContent.addChild(citySpace);
		}
	}
}