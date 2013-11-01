package lzm.starling.swf.tool.utils
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import lzm.starling.swf.tool.Starup;

	public class MovieClipUtil
	{
		/**
		 * 获取图片信息
		 * */
		public static function getMovieClipInfo(clazz:Class):Object{
			var mc:MovieClip = new clazz();
			
			Starup.tempContent.addChild(mc);
			
			var frameSize:int = mc.totalFrames;
			var frameInfos:Array = [];
			var objectCount:Object = {};
			
			for (var j:int = 1; j <= frameSize; j++) {
				mc.gotoAndStop(j);
				
				var childSize:int = mc.numChildren;
				var childInfos:Array = [];
				var childInfo:Array;
				var child:DisplayObject;
				var childName:String;
				var type:String;
				var childCount:Object = {};
				for (var i:int = 0; i < childSize; i++) {
					child = mc.getChildAt(i) as DisplayObject;
					childName = getQualifiedClassName(child);
					type = Util.getChildType(childName);
					if(type == null){
						continue;
					}
					childInfo = [
						childName,
						Util.formatNumber(child.x),
						Util.formatNumber(child.y),
						Util.formatNumber(child.scaleX),
						Util.formatNumber(child.scaleY),
						MatrixUtil.getSkewX(child.transform.matrix),
						MatrixUtil.getSkewY(child.transform.matrix)
					];
					
					if(child.name.indexOf("instance") == -1){
						childInfo.name = child.name;
					}
					
					childInfo.push(type);
					if(type == "s9"){
						childInfo.push(Util.formatNumber(child.width));
						childInfo.push(Util.formatNumber(child.height));
					}else if(type == "text"){
						childName = childInfo[0] = type;
						childInfo.push((child as TextField).defaultTextFormat.font);
						childInfo.push((child as TextField).defaultTextFormat.color);
						childInfo.push((child as TextField).defaultTextFormat.size);
						childInfo.push((child as TextField).defaultTextFormat.align);
						childInfo.push((child as TextField).defaultTextFormat.italic);
						childInfo.push((child as TextField).defaultTextFormat.bold);
						childInfo.push((child as TextField).text);
					}
					
					childInfos.push(childInfo);
					
					if(childCount[childName]){
						childCount[childName] += 1;
					}else{
						childCount[childName] = 1;
					}
				}
				
				frameInfos.push(childInfos);
				
				for(childName in childCount){
					if(objectCount[childName] == null || objectCount[childName] < childCount[childName]){
						objectCount[childName] = childCount[childName];
					}
				}
			}
			
			var frameLabels:Array = mc.currentLabels;
			var labelSize:int = frameLabels.length;
			
			var frameLabel:FrameLabel;
			var labels:Array = [];
			for (var k:int = 0; k < labelSize; k++) {
				frameLabel = frameLabels[k];
				mc.gotoAndStop(frameLabel.name);
				labels.push([frameLabel.name,frameLabel.frame]);
				if(k > 0){
					(labels[k - 1] as Array).push(frameLabel.frame-1);
				}
				
				if(k == (labelSize-1)){
					(labels[k] as Array).push(mc.totalFrames);
				}
			}
			
			Starup.tempContent.removeChild(mc);
			
			return {frames:frameInfos,labels:labels,objCount:objectCount};
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}