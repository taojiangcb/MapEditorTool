package application.extendsCore
{
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * 扩展Mediator类，方便注册消息回调 
	 * @author JiangTao
	 * 
	 */	
	public class MediatorExpert extends Mediator
	{
		
		/**
		 * 消息回调缓存 
		 */		
		private var notificationMap:Dictionary;
		
		public function MediatorExpert(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			notificationMap = new Dictionary();
			installNoficationHandler();
		}
		
		/**
		 * 由子类覆盖需要处理的观察者函数，注册观察回调 
		 */		
		protected function installNoficationHandler():void {
			
		}
		
		/**
		 * 添加消息回调函数，主要由installNoficationHandler()函数里调用。
		 * @param name
		 * @param callFunc
		 */		
		protected function putNotification(name:String,callFunc:Function):void {
			if(!name || name.length == 0) return;
			if(!callFunc) return;
			if(noti$map == null) return;
			noti$map[name] = callFunc;
		}
		
		/**
		 * 获取观察的列表 
		 * @return 
		 */		
		public override function listNotificationInterests():Array {
			var notificationNames:Array = [];
			var k:String;
			for( k in notificationMap) {
				notificationNames.push(k);
			}
			return notificationNames;
		}
		
		/**
		 * 观察到的消息处理 
		 * @param notification
		 */		
		public override function handleNotification(notification:INotification):void {
			if(!notificationMap) return;
			var handFunc:Function = noti$map[notification.getName()];
			if(handFunc != null) {
				handFunc(notification);
			}
		}
		
		public override function onRemove():void {
			notificationMap = null;
		}
		
		public function get noti$map():Dictionary {
			return notificationMap;
		}
	}
}