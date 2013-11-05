package lzm.starling.swf.tool.utils
{
	import flash.net.FileReference;
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
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
			var types:Array = ["img","spr","mc","btn","s9","bat","flash.text::TextField","text","btn","s9"];
			var types1:Array = ["img","spr","mc","btn","s9","bat","text","text","btn","s9"];
			for (var i:int = 0; i < types.length; i++) {
				if(childName.indexOf(types[i]) == 0){
					return types1[i];
				}
			}
			return null;
		}
		
		public static function getName(rawAsset:Object):String
		{
			var matches:Array;
			var name:String;
			
			if (rawAsset is String || rawAsset is FileReference)
			{
				name = rawAsset is String ? rawAsset as String : (rawAsset as FileReference).name;
				name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
				matches = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);
				
				if (matches && matches.length == 4) return matches[2];
				else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
			}
			else
			{
				name = getQualifiedClassName(rawAsset);
				throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
			}
		}
	}
}