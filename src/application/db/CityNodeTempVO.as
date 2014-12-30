package application.db
{
	public class CityNodeTempVO
	{
		//名称的相对坐标位置
		public var labelX:int = 0;
		public var labelY:int = 0;
		
		//战火的相对坐标位置
		public var fireeX:int = 0;
		public var fileeY:int = 0;
		
		public var virutalLabel:Boolean = true;
		public var virtualFiree:Boolean = true;
		
		//显示的纹理名称
		public var textureName:String = "";
		
		public function CityNodeTempVO()
		{
		}
	}
}