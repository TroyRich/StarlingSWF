package lzm.starling.swf.tool.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import lzm.starling.swf.tool.Starup;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class SpriteUtil
	{
		public static function getSpriteInfo(clazz:Class):Array{
			var mc:MovieClip = new clazz();
			
			Starup.tempContent.addChild(mc);
			
			var childSize:int = mc.numChildren;
			var childInfos:Array = [];
			var childInfo:Array;
			var child:DisplayObject;
			var childName:String;
			var type:String;
			for (var i:int = 0; i < childSize; i++) {
				child = mc.getChildAt(i) as DisplayObject;
				childName = getQualifiedClassName(child);
				type = Util.getChildType(childName);
				if(type == null){
					continue;
				}
				childInfo = [
					childName,
					type,
					Util.formatNumber(child.x),
					Util.formatNumber(child.y),
					Util.formatNumber(child.scaleX),
					Util.formatNumber(child.scaleY),
					MatrixUtil.getSkewX(child.transform.matrix),
					MatrixUtil.getSkewY(child.transform.matrix),
					child.alpha
				];
				
				if(child.name.indexOf("instance") == -1){
					childInfo.push(child.name);
				}else{
					childInfo.push("");
				}
				
				if(type == "s9"){
					childInfo.push(Util.formatNumber(child.width));
					childInfo.push(Util.formatNumber(child.height));
				}else if(type == "text"){
					childName = childInfo[0] = type;
					childInfo.push((child as TextField).width);
					childInfo.push((child as TextField).height);
					childInfo.push((child as TextField).defaultTextFormat.font);
					childInfo.push((child as TextField).defaultTextFormat.color);
					childInfo.push((child as TextField).defaultTextFormat.size);
					childInfo.push((child as TextField).defaultTextFormat.align);
					childInfo.push((child as TextField).defaultTextFormat.italic);
					childInfo.push((child as TextField).defaultTextFormat.bold);
					childInfo.push((child as TextField).text);
				}
				
				childInfos.push(childInfo);
			}
			
			Starup.tempContent.removeChild(mc);
			
			return childInfos;
		}
	}
}