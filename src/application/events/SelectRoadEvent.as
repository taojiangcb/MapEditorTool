package application.events
{
	import flash.events.Event;
	
	public class SelectRoadEvent extends Event
	{
		
		public static const CHROOSE_ROAD:String = "chrooseRoad";
		public var roadId:Number = 0;
		
		public function SelectRoadEvent(type:String,id:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			roadId = id;
		}
	}
}