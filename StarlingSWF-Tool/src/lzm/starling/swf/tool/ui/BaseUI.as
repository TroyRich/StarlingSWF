package lzm.starling.swf.tool.ui
{
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class BaseUI extends Sprite
	{
		
		protected var uiConfig:MinimalConfigurator;
		
		public function BaseUI()
		{
			
		}
		
		public function loadUi(path:String):void{
			uiConfig = new MinimalConfigurator(this);
			uiConfig.loadXML(path);
			uiConfig.addEventListener(Event.COMPLETE,loadXMLComplete);
		}
		
		protected function loadXMLComplete(e:Event):void{
			
		}
	}
}