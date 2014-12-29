package application
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Application;
	
	import application.extendsCore.MediatorExpert;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends MediatorExpert
	{
		
		public static const NEW_MAP_DATA_INIT:String = "newMapDataInit";
		
		public function ApplicationMediator(mediatorName:String=null, viewComponent:Object=null) {
			super(NAME, viewComponent);
		}
		
		protected override function installNoficationHandler():void {
			super.installNoficationHandler();
			putNotifiacion(NEW_MAP_DATA_INIT,appNewDataInitComplete);
		}
		
		private function appNewDataInitComplete(notification:INotification):void {
			MapEditor(FlexGlobals.topLevelApplication).appStart();
		}
		
		public static function get NAME():String {
			return getQualifiedClassName(ApplicationMediator);
		}
	}
}