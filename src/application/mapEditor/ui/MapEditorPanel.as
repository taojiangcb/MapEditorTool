package application.mapEditor.ui
{
	import application.mapEditor.comps.MapCitySpaceComp;
	import application.mapEditor.comps.MapFloorComp;
	import application.mapEditor.comps.MapRoadNodeComp;
	import application.mapEditor.comps.MapRoadSpaceComp;
	import application.mapEditor.comps.MapRoleComp;
	import application.utils.appData;
	
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
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
		public var roadSpace:MapRoadSpaceComp;
		
		public var addImg:Image;		//加节点
		public var delImg:Image;		//删除节点
		
		public var marchRole:MapRoleComp;
		
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
			
			roadSpace = new MapRoadSpaceComp();
			uiContent.addChild(roadSpace);
			
			marchRole = new MapRoleComp();
			uiContent.addChild(marchRole);
			
			addImg = new Image(appData.textureManager.getTexture("page-indicator-selected-skin"));
			addImg.pivotX = addImg.width >> 1;
			addImg.touchable = false;
			addImg.pivotY = addImg.height >> 1;
			uiContent.addChild(addImg);
			addImg.visible = false;
			
			delImg = new Image(appData.textureManager.getTexture("page-indicator-selected-skin"));
			delImg.color = 0xFF0000;
			delImg.touchable = false;
			delImg.pivotX = delImg.width >> 1;
			delImg.pivotY = delImg.height >> 1;
			uiContent.addChild(delImg);
			delImg.visible = false;
		}
	}
}