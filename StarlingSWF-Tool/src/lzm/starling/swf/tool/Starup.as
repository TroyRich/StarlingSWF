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
	import lzm.starling.swf.tool.ui.MovieClipPropertyUi;
	import lzm.starling.swf.tool.ui.UIEvent;
	
	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class Starup extends Sprite
	{
		
		public static var stage:Stage;
		public static var tempContent:Sprite;
		
		private var _mainUi:MainUi;
		private var _movieClipProUi:MovieClipPropertyUi;
		
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
			_mainUi.addEventListener("selectButton",onSelectButton);
			_mainUi.addEventListener("selectScale9",onSelectScale9);
			addChild(_mainUi);
			
			_movieClipProUi = new MovieClipPropertyUi();
			_movieClipProUi.x = 1024 - 160;
			_movieClipProUi.y = 120;
			
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
			hidePropertyPanel();
			
			_starlingStarup.clear();
		}
		
		/**
		 * 选择了一张图片
		 * */
		private function onSelectImage(e:UIEvent):void{
			hidePropertyPanel();
			
			_starlingStarup.showObject(Assets.swf.createImage(e.data.name));
		}
		
		/**
		 * 选择了sprite
		 * */
		private function onSelectSprite(e:UIEvent):void{
			hidePropertyPanel();
			
			_starlingStarup.showObject(Assets.swf.createSprite(e.data.name));
		}
		
		/**
		 * 选择moviecllip
		 * */
		private function onSelectMovieClip(e:UIEvent):void{
			hidePropertyPanel();
			showPropertyPanel();
			
			var mc:SwfMovieClip = Assets.swf.createMovieClip(e.data.name);
			mc.name = e.data.name;
			_movieClipProUi.movieClip = mc;
			_starlingStarup.showObject(mc);
		}
		
		/**
		 * 选择moviecllip
		 * */
		private function onSelectButton(e:UIEvent):void{
			hidePropertyPanel();
			
			_starlingStarup.showObject(Assets.swf.createButton(e.data.name));
		}
		
		/**
		 * 选择moviecllip
		 * */
		private function onSelectScale9(e:UIEvent):void{
			hidePropertyPanel();
			_starlingStarup.showScale9(e.data.name);
		}
		
		private function showPropertyPanel():void{
			addChild(_movieClipProUi);
		}
		
		private function hidePropertyPanel():void{
			if(_movieClipProUi.parent) _movieClipProUi.parent.removeChild(_movieClipProUi);
		}
		
	}
}