package application.db
{
	public class MapCityNodeTempVO
	{
		//名称的相对坐标位置
		public var labelX:int = 0;
		public var labelY:int = 0;
		
		//战火的相对坐标位置
		public var freeX:int = 0;
		public var freeY:int = 0;
		
		//旗子的位置
		public var flagX:int = 0;
		public var flagY:int = 0;
		
		//按钮
		public var menuX:int = 0;
		public var menuY:int = 0;
		
		//显示的纹理名称
		public var textureName:String = "";
		
		public function MapCityNodeTempVO() {
		}
	}
}