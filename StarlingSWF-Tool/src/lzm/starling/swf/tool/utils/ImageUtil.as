package lzm.starling.swf.tool.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import lzm.starling.swf.tool.Starup;

	/**
	 * 图片工具
	 * */
	public class ImageUtil
	{
		
		/**
		 * 获取图片bitmapdata
		 * */
		public static function getBitmapdata(clazz:Class,scale:Number):BitmapData{
			var mc:MovieClip = new clazz();
			mc.scaleX = mc.scaleY = scale;
			
			Starup.tempContent.addChild(mc);
			
			var rect:Rectangle = mc.getRect(Starup.tempContent);
			mc.x = -rect.x;
			mc.y = -rect.y;
			
			var bitmapdata:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmapdata.draw(Starup.tempContent);
			
			Starup.tempContent.removeChild(mc);
			
			return bitmapdata;
		}
		
		/**
		 * 获取图片信息
		 * */
		public static function getImageInfo(clazz:Class):Object{
			var mc:MovieClip = new clazz();
			
			Starup.tempContent.addChild(mc);
			
			var rect:Rectangle = mc.getRect(Starup.tempContent);
			
			Starup.tempContent.removeChild(mc);
			
			var obj:Object = {
				piX:Util.formatNumber(-rect.x),
				piY:Util.formatNumber(-rect.y)
			};
			
			return obj;
		}
		
	}
}