package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import lzm.starling.swf.tool.Starup;
	
	public class StarlingSWF_Tool extends Sprite
	{
		public function StarlingSWF_Tool()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild(new Starup());
		}
	}
}