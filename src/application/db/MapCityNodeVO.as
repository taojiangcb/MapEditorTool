package application.db
{
	public class MapCityNodeVO
	{
		public var cityName:String = "";
		
		public var templateId:int = 0;
		
		//大地图中的坐标
		public var worldX:int = 0;
		public var worldY:int = 0;
		public var textureName:String;
		//预览战火
		public var visualFiree:Boolean = false;
	}
}