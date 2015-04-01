package application.events
{
	import flash.events.Event;
	
	public class SelectRoadEvent extends Event
	{
		public static const CHROOSE_ROAD:String = "chrooseRoad";
		public function SelectRoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}