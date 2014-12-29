package application.utils
{
	import application.proxy.AppDataProxy;
	import org.puremvc.as3.patterns.facade.Facade;
	public var appDataProxy:AppDataProxy = Facade.getInstance().retrieveProxy(AppDataProxy.NAME) as AppDataProxy; 
}