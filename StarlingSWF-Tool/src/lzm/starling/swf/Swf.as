package lzm.starling.swf
{
	import flash.display.Stage;
	
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	public class Swf
	{
		public static const dataKey_Sprite:String = "spr";
		public static const dataKey_Image:String = "img";
		public static const dataKey_MovieClip:String = "mc";
		public static const dataKey_TextField:String = "text";
		
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		public static function init(stage:Stage):void{
			SwfUpdateManager.init(stage);
		}
		
		public const createFuns:Object = {
			"img":createImage,
			"spr":createSprite,
			"mc":createMovieClip,
			"text":createTextField
		};
		
		private var _assets:AssetManager;
		private var _swfDatas:Object;
		
		public function Swf(swfData:Object,assets:AssetManager){
			this._swfDatas = swfData;
			this._assets = assets;
		}
		
		/**
		 * 创建sprite
		 * */
		public function createSprite(name:String,data:Array=null):SwfSprite{
			var sprData:Array = _swfDatas[dataKey_Sprite][name];
			
			var sprite:SwfSprite = new SwfSprite();
			var length:int = sprData.length;
			var objData:Array;
			var display:DisplayObject;
			var fun:Function;
			for (var i:int = 0; i < length; i++) {
				objData = sprData[i];
				
				fun = createFuns[objData[1]];
				display = fun(objData[0],objData);
					
				display.x = objData[2];
				display.y = objData[3];
				display.scaleX = objData[4];
				display.scaleY = objData[5];
				display.skewX = objData[6] * ANGLE_TO_RADIAN;
				display.skewY = objData[7] * ANGLE_TO_RADIAN;
				display.name = objData[8];
				sprite.addChild(display);
			}
			
			return sprite;
		}
		
		/**
		 * 创建movieclip
		 * */
		public function createMovieClip(name:String,data:Array=null):SwfMovieClip{
			var movieClipData:Object = _swfDatas[dataKey_MovieClip][name];
			
			var objectCountData:Object = movieClipData["objCount"];
			var displayObjects:Object = {};
			var displayObjectArray:Array;
			var type:String;
			var count:int;
			var fun:Function;
			for(var objName:String in objectCountData){
				type = objectCountData[objName][0];
				count = objectCountData[objName][1];
				
				displayObjectArray = displayObjects[objName] == null ? [] : displayObjects[objName];
				
				for (var i:int = 0; i < count; i++) {
					fun = createFuns[type];
					displayObjectArray.push(fun(objName,null));
				}
				
				displayObjects[objName] = displayObjectArray;
			}
			
			return new SwfMovieClip(movieClipData["frames"],movieClipData["labels"],displayObjects);
		}
		
		/**
		 * 创建图片
		 * */
		public function createImage(name:String,data:Array=null):Image{
			var imageData:Array = _swfDatas[dataKey_Image][name];
			var image:Image = new Image(_assets.getTexture(name));
			
			image.pivotX = imageData[0];
			image.pivotY = imageData[1];
			
			return image;
		}
		
		public function createTextField(name:String,data:Array=null):TextField{
			var textfield:TextField = new TextField(2,2,"");
			if(data){
				textfield.width = data[9];
				textfield.height = data[10];
				textfield.fontName = data[11];
				textfield.color = data[12];
				textfield.fontSize = data[13];
				textfield.vAlign = data[14];
				textfield.italic = data[15];
				textfield.bold = data[16];
				textfield.text = data[17];
			}
			return textfield;
		}
		
		
	}
}