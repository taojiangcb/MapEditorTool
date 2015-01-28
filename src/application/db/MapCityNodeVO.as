package application.db
{
	public class MapCityNodeVO
	{
		//预览的城市名称
		public var cityName:String = "";
		//绑定的城市templateId
		public var templateId:int = 0;
		//大地图中的坐标
		public var worldX:int = 0;
		public var worldY:int = 0;
		
		/**
		 * 道路的数量 
		 */		
		public var roadNum:int = 0;
		
		/**
		 * 道路列表 
		 */		
		public var toCityIds:Array = [];
		
		//城市纹理图片名称
		public var textureName:String;
		//预览战火
		public var visualFiree:Boolean = false;
	}
}