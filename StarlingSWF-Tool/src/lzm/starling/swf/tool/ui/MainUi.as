package lzm.starling.swf.tool.ui
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.tool.asset.Assets;
	import lzm.starling.swf.tool.utils.ImageUtil;
	import lzm.starling.swf.tool.utils.MovieClipUtil;
	import lzm.starling.swf.tool.utils.SpriteUtil;
	import lzm.starling.swf.tool.utils.Util;
	import lzm.util.LSOManager;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	
	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class MainUi extends BaseUI
	{
		
		private var _selectSwfSource:PushButton;
		private var _refreshSwfSource:PushButton;
		private var _swfPath:InputText;
		private var _imageComboBox:ComboBox;
		private var _spriteComboBox:ComboBox;
		private var _movieClipComboBox:ComboBox;
		private var _buttonComboBox:ComboBox;
		private var _s9ComboBox:ComboBox;
		
		private var _bgColorChooser:ColorChooser;
		private var _fpsValue:HUISlider;
		
		private var _exportScale:NumericStepper;
		private var _exportBtn:PushButton;
		private var _exportPath:String;
		
		public function MainUi()
		{
			super();
			loadUi("assets/ui/main.xml");
		}
		
		protected override function loadXMLComplete(e:Event):void{
			_selectSwfSource = uiConfig.getCompById("selectSwfSource") as PushButton;
			_refreshSwfSource = uiConfig.getCompById("refreshSwfSource") as PushButton;
			_swfPath = uiConfig.getCompById("swfSource") as InputText;
			_imageComboBox = uiConfig.getCompById("imageComboBox") as ComboBox;
			_spriteComboBox = uiConfig.getCompById("spriteComboBox") as ComboBox;
			_movieClipComboBox = uiConfig.getCompById("movieClipComboBox") as ComboBox;
			_buttonComboBox = uiConfig.getCompById("buttonComboBox") as ComboBox;
			_s9ComboBox = uiConfig.getCompById("scale9ComboBox") as ComboBox;
			
			_bgColorChooser = uiConfig.getCompById("bgColor") as ColorChooser;
			_fpsValue = uiConfig.getCompById("fpsValue") as HUISlider;
			
			_exportScale = uiConfig.getCompById("exportScale") as NumericStepper;
			_exportBtn = uiConfig.getCompById("exportBtn") as PushButton;
		}
		
		/**
		 * 点击选择swf按钮
		 * */
		public function onSelectSwfSource(e:Event):void{
			var file:File = new File();
			file.browse([new FileFilter("Flash","*.swf")]);
			file.addEventListener(Event.SELECT,selectSwfOK);
		}
		/**
		 * 选择完swf
		 * */
		private function selectSwfOK(e:Event):void{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT,selectSwfOK);
			
			_swfPath.text = file.url;
			
			LSOManager.NAME = Util.getName(_swfPath.text);
			
			loadSwf();
		}
		
		/**
		 * 加载swf
		 * */
		private function loadSwf():void{
			Loading.instance.show();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadSwfComplete);
			loader.load(new URLRequest(_swfPath.text));
		}
		
		/**
		 * 加载swf完成
		 * */
		private function loadSwfComplete(e:Event):void{
			Loading.instance.hide();
			
			var loaderinfo:LoaderInfo = e.target as LoaderInfo;
			loaderinfo.removeEventListener(Event.COMPLETE,loadSwfComplete);
			
			_selectSwfSource.enabled = false;
			_refreshSwfSource.enabled = true;
			_exportBtn.enabled = true;
			_exportScale.enabled = true;
			
			Assets.appDomain = loaderinfo.content.loaderInfo.applicationDomain;
			var clazzKeys:Vector.<String> = Assets.appDomain.getQualifiedDefinitionNames();
			
			Assets.imageDatas = {};
			Assets.spriteDatas = {};
			Assets.movieClipDatas = {};
			Assets.buttons = {};
			Assets.s9s = {};
			
			if(Assets.asset){
				Assets.asset.purge();
			}
			Assets.asset = new AssetManager(1,false);
			
			var images:Array = [];
			var sprites:Array = [];
			var movieClips:Array = [];
			var buttons:Array = [];
			var s9s:Array = [];
			
			var length:int = clazzKeys.length;
			var clazzName:String;
			for (var i:int = 0; i < length; i++) {
				clazzName = clazzKeys[i];
				if(Util.getChildType(clazzName) == Swf.dataKey_Image){
					Assets.imageDatas[clazzName] = ImageUtil.getImageInfo(Assets.getClass(clazzName));
					Assets.asset.addTexture(clazzName,Texture.fromBitmapData(ImageUtil.getBitmapdata(Assets.getClass(clazzName),1)));
					images.push(clazzName);
				}else if(Util.getChildType(clazzName) == Swf.dataKey_Sprite){
					Assets.spriteDatas[clazzName] = SpriteUtil.getSpriteInfo(Assets.getClass(clazzName));
					sprites.push(clazzName);
				}else if(Util.getChildType(clazzName) == Swf.dataKey_MovieClip){
					Assets.movieClipDatas[clazzName] = MovieClipUtil.getMovieClipInfo(clazzName,Assets.getClass(clazzName));
					movieClips.push(clazzName);
				}else if(Util.getChildType(clazzName) == Swf.dataKey_Button){
					Assets.buttons[clazzName] = SpriteUtil.getSpriteInfo(Assets.getClass(clazzName));
					buttons.push(clazzName);
				}else if(Util.getChildType(clazzName) == Swf.dataKey_Scale9){
					Assets.s9s[clazzName] = "";
					Assets.asset.addTexture(clazzName,Texture.fromBitmapData(ImageUtil.getBitmapdata(Assets.getClass(clazzName),1)));
					s9s.push(clazzName);
				}
			}
			
			var swfData:ByteArray = new ByteArray();
			swfData.writeUTFBytes(JSON.stringify({
				"img":Assets.imageDatas,
				"spr":Assets.spriteDatas,
				"mc":Assets.movieClipDatas,
				"btn":Assets.buttons,
				"s9":Assets.s9s
			}));
			swfData.compress();
			Assets.swf = new Swf(swfData,Assets.asset);
			
			images.sort();
			sprites.sort();
			movieClips.sort();
			buttons.sort();
			s9s.sort();
			
			_imageComboBox.selectedIndex = -1;
			_spriteComboBox.selectedIndex = -1;
			_movieClipComboBox.selectedIndex = -1;
			_buttonComboBox.selectedIndex = -1;
			_s9ComboBox.selectedIndex = -1;
			
			if(images.length > 0){
				_imageComboBox.items = images;
				_imageComboBox.enabled = true;
			}else{
				_imageComboBox.items = [];
				_imageComboBox.enabled = false;
			}
			
			if(sprites.length > 0){
				_spriteComboBox.items = sprites;
				_spriteComboBox.enabled = true;
			}else{
				_spriteComboBox.items = [];
				_spriteComboBox.enabled = false;
			}
			
			if(movieClips.length > 0){
				_movieClipComboBox.items = movieClips;
				_movieClipComboBox.enabled = true;
			}else{
				_movieClipComboBox.items = [];
				_movieClipComboBox.enabled = false;
			}
			
			if(buttons.length > 0){
				_buttonComboBox.items = buttons;
				_buttonComboBox.enabled = true;
			}else{
				_buttonComboBox.items = [];
				_buttonComboBox.enabled = false;
			}
			
			if(s9s.length > 0){
				_s9ComboBox.items = s9s;
				_s9ComboBox.enabled = true;
			}else{
				_s9ComboBox.items = [];
				_s9ComboBox.enabled = false;
			}
		}
		
		/**
		 * 点击刷新按钮
		 * */
		public function onRefreshSwfSource(e:Event):void{
			dispatchEvent(new UIEvent("onRefresh"));
			loadSwf();
		}
		
		/**
		 * 选择image
		 * */
		public function onSelectImage(e:Event):void{
			if(_imageComboBox.selectedItem){
				var event:UIEvent = new UIEvent("selectImage");
				event.data = {name:_imageComboBox.selectedItem};
				dispatchEvent(event);
			}
		}
		
		/**
		 * 选择sprite
		 * */
		public function onSelectSprite(e:Event):void{
			if(_spriteComboBox.selectedItem){
				var event:UIEvent = new UIEvent("selectSprite");
				event.data = {name:_spriteComboBox.selectedItem};
				dispatchEvent(event);
			}
		}
		
		/**
		 * 选择movieclip
		 * */
		public function onSelectMovieClip(e:Event):void{
			if(_movieClipComboBox.selectedItem){
				var event:UIEvent = new UIEvent("selectMovieClip");
				event.data = {name:_movieClipComboBox.selectedItem};
				dispatchEvent(event);
			}
		}
		
		/**
		 * 选择button
		 * */
		public function onSelectButton(e:Event):void{
			if(_buttonComboBox.selectedItem){
				var event:UIEvent = new UIEvent("selectButton");
				event.data = {name:_buttonComboBox.selectedItem};
				dispatchEvent(event);
			}
		}
		
		/**
		 * 选择s9
		 * */
		public function onSelectScale9(e:Event):void{
			if(_s9ComboBox.selectedItem){
				var event:UIEvent = new UIEvent("selectScale9");
				event.data = {name:_s9ComboBox.selectedItem};
				dispatchEvent(event);
			}
		}
		
		public function onColorChange(e:Event):void{
			Starling.current.stage.color = stage.color = _bgColorChooser.value;
		}
		
		public function onFpsChange(e:Event):void{
			stage.frameRate = _fpsValue.value;
		}
		
		public function onExport(e:Event):void{
			var file:File = new File();
			file.browseForDirectory("输出路径");
			file.addEventListener(Event.SELECT,selectExportPathOk);
		}
		
		/**
		 * 选择完swf
		 * */
		private function selectExportPathOk(e:Event):void{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT,selectExportPathOk);
			
			Loading.instance.show();
			
			setTimeout(function():void{
				__export(file.url);
			},30);
		}
		
		private function __export(exportPath:String):void{
			var imageExportPath:String = exportPath + "/images/";
			var bigImageExportPath:String = exportPath + "/images/big/";
			var dataExportPath:String = exportPath + "/data/layout.bytes";
			
			var images:Array = _imageComboBox.items;
			var length:int = images.length;
			
			var exportFile:File;
			var exportFileStream:FileStream;
			
			var bitmapdata:BitmapData;
			var imageData:ByteArray;
			
			for (var i:int = 0; i < length; i++) {
				bitmapdata = ImageUtil.getBitmapdata(Assets.getClass(images[i]),_exportScale.value);
				imageData = bitmapdata.encode(new Rectangle(0,0,bitmapdata.width,bitmapdata.height),new PNGEncoderOptions());
				
				if(bitmapdata.width > (150 * _exportScale.value) && bitmapdata.height > (150 * _exportScale.value)){
					exportFile = new File(bigImageExportPath + images[i] + ".png");
				}else{
					exportFile = new File(imageExportPath + images[i] + ".png");
				}
				
				exportFileStream = new FileStream();
				exportFileStream.open(exportFile,FileMode.WRITE);
				exportFileStream.writeBytes(imageData);
				exportFileStream.close();
			}
			
			var swfData:ByteArray = new ByteArray();
			swfData.writeUTFBytes(JSON.stringify({
				"img":Assets.imageDatas,
				"spr":Assets.spriteDatas,
				"mc":Assets.movieClipDatas,
				"btn":Assets.buttons,
				"s9":Assets.s9s
			}));
			swfData.compress();
			exportFile = new File(dataExportPath);
			exportFileStream = new FileStream();
			exportFileStream.open(exportFile,FileMode.WRITE);
			exportFileStream.writeBytes(swfData);
			exportFileStream.close();
			
			Loading.instance.hide();
		}
		
		
	}
}