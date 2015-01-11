package application.appui
{
	import mx.events.FlexEvent;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	public class CityPropertieController extends MainUIControllerBase
	{
		
		public function CityPropertieController() 	{
			super();
			autoClose = false;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
		}
		
		public function get ui():CityPropertiePanel {
			return mGUI as CityPropertiePanel;
		}
	}
}