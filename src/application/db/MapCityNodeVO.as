package application.db
{
	public class MapCityNodeVO
	{
		public var cityName:String = "";
		
		public var cityId:int = 0;
		
		//大地图中的坐标
		public var worldX:int = 0;
		public var worldY:int = 0;
		
		public var textureName:String;
		
		//显示标题
		public var visualLabel:Boolean = true;
		public var visualFiree:Boolean = false;
	}
}