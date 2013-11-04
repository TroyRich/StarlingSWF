package lzm.starling.swf.tool.ui
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.tool.asset.Assets;
	import lzm.starling.swf.tool.utils.ImageUtil;
	import lzm.starling.swf.tool.utils.MovieClipUtil;
	import lzm.starling.swf.tool.utils.SpriteUtil;
	import lzm.starling.swf.tool.utils.Util;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	
	public class MainUi extends BaseUI
	{
		
		private var _selectSwfSource:PushButton;
		private var _refreshSwfSource:PushButton;
		private var _swfPath:InputText;
		private var _imageComboBox:ComboBox;
		private var _spriteComboBox:ComboBox;
		private var _movieClipComboBox:ComboBox;
		
		private var _bgColorChooser:ColorChooser;
		
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
			
			_bgColorChooser = uiConfig.getCompById("bgColor") as ColorChooser;
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
			
			loadSwf();
		}
		
		/**
		 * 加载swf
		 * */
		private function loadSwf():void{
			Loading.instance.show();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadSwfComplete);
			loader.load(new URLRequest(swfPath));
		}
		
		/**
		 * 加载进度
		 * */
		private function loadProgress(e:ProgressEvent):void{
			Loading.instance.value = e.bytesLoaded / e.bytesTotal;
		}
		
		/**
		 * 加载swf完成
		 * */
		private function loadSwfComplete(e:Event):void{
			Loading.instance.hide();
			
			var loaderinfo:LoaderInfo = e.target as LoaderInfo;
			loaderinfo.removeEventListener(ProgressEvent.PROGRESS,loadProgress);
			loaderinfo.removeEventListener(Event.COMPLETE,loadSwfComplete);
			
			_selectSwfSource.enabled = false;
			_refreshSwfSource.enabled = true;
			
			Assets.appDomain = loaderinfo.content.loaderInfo.applicationDomain;
			var clazzKeys:Vector.<String> = Assets.appDomain.getQualifiedDefinitionNames();
			
			Assets.imageDatas = {};
			Assets.spriteDatas = {};
			Assets.movieClipDatas = {};
			
			if(Assets.asset){
				Assets.asset.purge();
			}
			Assets.asset = new AssetManager(1,false);
			Assets.swf = new Swf({
				"img":Assets.imageDatas,
				"spr":Assets.spriteDatas,
				"mc":Assets.movieClipDatas
			},Assets.asset);
			
			var images:Array = [];
			var sprites:Array = [];
			var movieClips:Array = [];
			
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
					Assets.movieClipDatas[clazzName] = MovieClipUtil.getMovieClipInfo(Assets.getClass(clazzName));
					movieClips.push(clazzName);
				}
			}
			
			images.sort();
			sprites.sort();
			movieClips.sort();
			
			_imageComboBox.selectedIndex = -1;
			_spriteComboBox.selectedIndex = -1;
			_movieClipComboBox.selectedIndex = -1;
			
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
		
		public function onColorChange(e:Event):void{
			Starling.current.stage.color = stage.color = _bgColorChooser.value;
			
		}
		
		public function get swfPath():String{
			return _swfPath.text;
		}
		
	}
}