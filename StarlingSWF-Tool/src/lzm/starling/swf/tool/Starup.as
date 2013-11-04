package lzm.starling.swf.tool
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.tool.asset.Assets;
	import lzm.starling.swf.tool.starling.StarlingStarup;
	import lzm.starling.swf.tool.ui.Loading;
	import lzm.starling.swf.tool.ui.MainUi;
	import lzm.starling.swf.tool.ui.UIEvent;
	
	public class Starup extends Sprite
	{
		
		public static var stage:Stage;
		public static var tempContent:Sprite;
		
		private var _mainUi:MainUi;
		
		private var _starlingStarup:StarlingStarup;
		
		public function Starup()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			
			init();
			
			_mainUi = new MainUi();
			_mainUi.addEventListener("onRefresh",onRefresh);
			
			_mainUi.addEventListener("selectImage",onSelectImage);
			_mainUi.addEventListener("selectSprite",onSelectSprite);
			_mainUi.addEventListener("selectMovieClip",onSelectMovieClip);
			addChild(_mainUi);
			
			initStarling();
		}
		
		private function initStarling():void{
			_starlingStarup = new StarlingStarup();
			addChildAt(_starlingStarup,0);
		}
		
		private function init():void{
			Starup.stage = stage;
			Starup.tempContent = new Sprite();
			Starup.tempContent.x = Starup.tempContent.y = 3000;
			Starup.stage.addChild(Starup.tempContent);
			
			Loading.init(stage);
			
			Swf.init(stage);
		}
		
		private function onRefresh(e:UIEvent):void{
			_starlingStarup.clear();
		}
		
		/**
		 * 选择了一张图片
		 * */
		private function onSelectImage(e:UIEvent):void{
			_starlingStarup.showObject(Assets.swf.createImage(e.data.name));
		}
		
		/**
		 * 选择了sprite
		 * */
		private function onSelectSprite(e:UIEvent):void{
			_starlingStarup.showObject(Assets.swf.createSprite(e.data.name));
		}
		
		/**
		 * 选择moviecllip
		 * */
		private function onSelectMovieClip(e:UIEvent):void{
			_starlingStarup.showObject(Assets.swf.createMovieClip(e.data.name));
		}
		
	}
}