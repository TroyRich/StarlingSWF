package lzm.starling.swf.tool.asset
{
	import flash.system.ApplicationDomain;
	
	import lzm.starling.swf.Swf;
	
	import starling.utils.AssetManager;
	
	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class Assets
	{
		public static var appDomain:ApplicationDomain;
		public static var imageDatas:Object;
		public static var spriteDatas:Object;
		public static var movieClipDatas:Object;
		public static var buttons:Object;
		public static var s9s:Object;
		public static var swf:Swf;
		public static var asset:AssetManager;
		
		
		
		public static function getClass(clazzName:String):Class{
			return appDomain.getDefinition(clazzName) as Class;
		}
		
		
	}
}