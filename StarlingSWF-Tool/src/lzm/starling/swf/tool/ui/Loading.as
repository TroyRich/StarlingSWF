package lzm.starling.swf.tool.ui
{
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.VBox;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
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
		
		
		private var _label:Label;
		private var _sprite:Sprite;
		
		public function Loading()
		{
			super();
			
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0x000000,0.7);
			_sprite.graphics.drawRect(0,0,100,100);
			_sprite.graphics.endFill();
			addChild(_sprite);
			
			_label = new Label(this,0,0,"Loading...");
		}
		
		public function show():void{
			var w:Number = _stage.stageWidth;
			var h:Number = _stage.stageHeight;
			
			_sprite.width = w;
			_sprite.height = h;
			
			_label.x = (w - _label.width)/2;
			_label.y = (h - _label.height)/2;
			
			_stage.addChild(this);
		}
		
		public function hide():void{
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}