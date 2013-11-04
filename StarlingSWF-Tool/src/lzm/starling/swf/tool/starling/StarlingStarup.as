package lzm.starling.swf.tool.starling
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import lzm.starling.STLConstant;
	import lzm.starling.STLRootClass;
	import lzm.starling.STLStarup;
	import lzm.starling.swf.tool.asset.Assets;
	import lzm.util.Mobile;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.HAlign;
	
	public class StarlingStarup extends STLStarup
	{
		
		private var contentSprite:Sprite;
		
		public function StarlingStarup()
		{
			super();
			addEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:flash.events.Event):void{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
			
			STLConstant.nativeStage = stage;
			
			Starling.handleLostContext = !Mobile.isIOS();
			
			var viewPort:Rectangle = new Rectangle(0,121,1024,800-121);
			STLConstant.StageWidth = viewPort.width;
			STLConstant.StageHeight = viewPort.height;
			
			_mStarling = new Starling(STLRootClass, stage, viewPort,null,"auto","baseline");
			_mStarling.antiAliasing = 0;
			_mStarling.stage.stageWidth  = STLConstant.StageWidth;
			_mStarling.stage.stageHeight = STLConstant.StageHeight;
			_mStarling.simulateMultitouch  = false;
			_mStarling.enableErrorChecking = Capabilities.isDebugger;
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, app:STLRootClass):void
				{
					STLConstant.currnetAppRoot = app;
					
					_mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
					_mStarling.start();
					_mStarling.showStatsAt(HAlign.RIGHT);
					
					contentSprite = new Sprite();
					app.addChild(contentSprite);
				});
		}
		
		public function showObject(object:DisplayObject):void{
			contentSprite.removeChildren();
			
			var rect:Rectangle = object.getBounds(object.parent);
			object.x = (STLConstant.StageWidth - rect.width)/2;
			object.y = (STLConstant.StageHeight - rect.height)/2;
			
			contentSprite.addChild(object);
		}
		
		public function clear():void{
			contentSprite.removeChildren();
		}
	}
}