package lzm.starling.swf.tool.ui
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.sampler.getMasterString;
	import flash.system.ApplicationDomain;
	
	import lzm.starling.swf.tool.Starup;
	import lzm.starling.swf.tool.utils.ImageUtil;
	import lzm.starling.swf.tool.utils.MovieClipUtil;
	import lzm.starling.swf.tool.utils.SpriteUtil;
	
	
	public class MainUi extends BaseUI
	{
		
		private var _selectSwfSource:PushButton;
		private var _refreshSwfSource:PushButton;
		private var _swfPath:InputText;
		private var _imageComboBox:ComboBox;
		private var _spriteComboBox:ComboBox;
		private var _movieClipComboBox:ComboBox;
		
		private var _appDomain:ApplicationDomain;
		private var _images:Array;
		private var _sprites:Array;
		private var _movieClips:Array;
		
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
			
			_appDomain = loaderinfo.content.loaderInfo.applicationDomain;
			var clazzKeys:Vector.<String> = _appDomain.getQualifiedDefinitionNames();
			
			_images = [];
			_sprites = [];
			_movieClips = [];
			
			var length:int = clazzKeys.length;
			for (var i:int = 0; i < length; i++) {
				if(clazzKeys[i].indexOf("img") == 0){
					_images.push(clazzKeys[i]);
				}else if(clazzKeys[i].indexOf("spr") == 0){
					_sprites.push(clazzKeys[i]);
				}else if(clazzKeys[i].indexOf("mc") == 0){
					_movieClips.push(clazzKeys[i]);
				}
			}
			
			_images.sort();
			_sprites.sort();
			_movieClips.sort();
			
			_imageComboBox.selectedIndex = -1;
			_spriteComboBox.selectedIndex = -1;
			_movieClipComboBox.selectedIndex = -1;
			
			if(_images.length > 0){
				_imageComboBox.items = _images;
				_imageComboBox.enabled = true;
			}else{
				_imageComboBox.items = [];
				_imageComboBox.enabled = false;
			}
			
			if(_sprites.length > 0){
				_spriteComboBox.items = _sprites;
				_spriteComboBox.enabled = true;
			}else{
				_spriteComboBox.items = [];
				_spriteComboBox.enabled = false;
			}
			
			if(_movieClips.length > 0){
				_movieClipComboBox.items = _movieClips;
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
			loadSwf();
		}
		
		/**
		 * 选择image
		 * */
		public function onSelectImage(e:Event):void{
			if(_imageComboBox.selectedItem){
				Starup.tempContent.removeChildren();
				var bitmap:Bitmap = new Bitmap(ImageUtil.getBitmapdata(getClass(_imageComboBox.selectedItem as String),2));
				trace(JSON.stringify(ImageUtil.getImageInfo(getClass(_imageComboBox.selectedItem as String))));
				Starup.tempContent.addChild(bitmap);
			}
		}
		
		/**
		 * 选择sprite
		 * */
		public function onSelectSprite(e:Event):void{
			if(_spriteComboBox.selectedItem){
				Starup.tempContent.removeChildren();
				var clazz:Class = getClass(_spriteComboBox.selectedItem as String);
				var mc:MovieClip = new clazz();
				trace(JSON.stringify(SpriteUtil.getSpriteInfo(clazz)));
				Starup.tempContent.addChild(mc);
			}
		}
		
		/**
		 * 选择movieclip
		 * */
		public function onSelectMovieClip(e:Event):void{
			if(_movieClipComboBox.selectedItem){
				Starup.tempContent.removeChildren();
				var clazz:Class = getClass(_movieClipComboBox.selectedItem as String);
				var mc:MovieClip = new clazz();
				trace(JSON.stringify(MovieClipUtil.getMovieClipInfo(clazz)));
				Starup.tempContent.addChild(mc);
			}
		}
		
		public function get swfPath():String{
			return _swfPath.text;
		}
		
		public function getClass(clazzName:String):Class{
			return _appDomain.getDefinition(clazzName) as Class;
		}
		
	}
}