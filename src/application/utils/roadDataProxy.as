package application.utils
{
	import application.proxy.RoadDataProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	public var roadDataProxy:RoadDataProxy = Facade.getInstance().retrieveProxy(RoadDataProxy.NAME) as RoadDataProxy;
}