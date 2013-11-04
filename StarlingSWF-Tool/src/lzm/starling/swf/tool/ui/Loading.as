package lzm.starling.swf.tool.ui
{
	import com.bit101.components.ProgressBar;
	import com.bit101.components.VBox;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class Loading extends BaseUI
	{
		
		private static var _stage:Stage;
		private static var _instance:Loading;
		
		public static function init(stage:Stage):void{
			_stage = stage;
			_instance = new Loading();
		}
		
		public static function get instance():Loading{
			if(_instance == null){
				_instance = new Loading();
			}
			return _instance;
		}
		
		
		private var _vbox:VBox;
		private var _progressBar:ProgressBar;
		private var _sprite:Sprite;
		
		public function Loading()
		{
			super();
			
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0x000000,0.7);
			_sprite.graphics.drawRect(0,0,100,100);
			_sprite.graphics.endFill();
			addChild(_sprite);
			
			loadUi("assets/ui/loading.xml");
		}
		
		protected override function loadXMLComplete(e:Event):void{
			_vbox = uiConfig.getCompById("vbox") as VBox;
			_progressBar = uiConfig.getCompById("progress") as ProgressBar;
		}
		
		public function set value(value:Number):void{
			_progressBar.value = value;
		}
		
		public function show():void{
			var w:Number = _stage.stageWidth;
			var h:Number = _stage.stageHeight;
			
			_sprite.width = w;
			_sprite.height = h;
			
			_vbox.x = (w - _vbox.width)/2;
			_vbox.y = (h - _vbox.height)/2;
			
			_stage.addChild(this);
		}
		
		public function hide():void{
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}