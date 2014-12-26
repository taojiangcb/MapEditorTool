package application.db
{
	public class MapCityNodeVO
	{
		public var cityName:String = "";
		
		//大地图中的坐标
		public var worldX:int = 0;
		public var worldY:int = 0;
		
		//所属阵营
		public var faction:int = 0;
		
		//二级坐标
		public var labelX:int = 0;
		public var labelY:int = 0;
		
		//着火状态坐标
		public var fireeX:int = 0;
		public var fireeY:int = 0;
		
		//显示标题
		public var visualLabel:Boolean = true;
		public var visualFiree:Boolean = false;
	}
}