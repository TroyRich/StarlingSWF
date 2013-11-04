package lzm.starling.swf.tool.ui
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		
		public var data:Object;
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}