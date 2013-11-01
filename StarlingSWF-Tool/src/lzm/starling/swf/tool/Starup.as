package lzm.starling.swf.tool
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import lzm.starling.swf.tool.ui.Loading;
	import lzm.starling.swf.tool.ui.MainUi;
	
	public class Starup extends Sprite
	{
		
		public static var stage:Stage;
		public static var tempContent:Sprite;
		
		private var _mainUi:MainUi;
		
		public function Starup()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			
			init();
			
			_mainUi = new MainUi();
			addChild(_mainUi);
		}
		
		
		
		private function init():void{
			Starup.stage = stage;
			Starup.tempContent = new Sprite();
			Starup.tempContent.x = Starup.tempContent.y = 200;
			Starup.stage.addChild(Starup.tempContent);
			
			Loading.init(stage);
		}
	}
}