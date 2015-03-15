package application.road
{
	/**
	 * 路径 
	 * @author JiangTao
	 */	
	public class PassedPath
	{
		public var crtNodeId:Number = 0;							//当前节点Id
		public var weight:Number = 0;								//距离
		public var beProcesseed:Boolean = false;					//是否通过
		public var passedPathList:Array = [];						//经过的路径
		
		public function PassedPath(nodeID:Number)
		{
			crtNodeId = nodeID;
			weight = Number.MAX_VALUE;
		}
		
		public function get exploration():Boolean {
			return true;
		}
	}
}