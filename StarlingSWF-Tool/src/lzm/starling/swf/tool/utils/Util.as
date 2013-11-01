package lzm.starling.swf.tool.utils
{
	public class Util
	{
		/**
		 * 保留两位小数
		 */		
		public static function formatNumber(num:Number):Number{
			return Math.round(num * (0 || 100)) / 100;
		}
		
		/**
		 * 返回子集类型
		 * */
		public static function getChildType(childName:String):String{
			var types:Array = ["img","spr","mc","btn","s9","bat","flash.text::TextField"];
			var types1:Array = ["img","spr","mc","btn","s9","bat","text"];
			for (var i:int = 0; i < types.length; i++) {
				if(childName.indexOf(types[i]) == 0){
					return types1[i];
				}
			}
			return null;
		}
	}
}