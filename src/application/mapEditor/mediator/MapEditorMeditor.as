package application.mapEditor.mediator
{
	import flash.utils.getQualifiedClassName;
	
	import application.ApplicationMediator;
	import application.extendsCore.MediatorExpert;
	
	public class MapEditorMeditor extends MediatorExpert
	{
		
		public function MapEditorMeditor(mediatorName:String=null, viewComponent:Object=null) {
			super(mediatorName, viewComponent);
		}
		
		public static function get NAME():String {
			return getQualifiedClassName(MapEditorMeditor);
		}
	}
}