package application.db
{
	public class CityNodeVO
	{
		//预览的城市名称
		public var cityName:String = "";
		//绑定的城市templateId
		public var templateId:Number = 0;
		//大地图中的坐标
		public var worldX:int = 0;
		public var worldY:int = 0;
		 //道路列表 
		public var toCityIds:Array = [];
		//城市道路列表
		public var toRoads:Vector.<MapCityNodeRoadVO> = new Vector.<MapCityNodeRoadVO>();
		//城市纹理图片名称
		public var textureName:String;
		//预览战火
		public var visualFiree:Boolean = false;
		//显示道路
		public var visualRaod:Boolean = false;
		//显示旗子
		public var visualFlag:Boolean = false;
		
	}
}