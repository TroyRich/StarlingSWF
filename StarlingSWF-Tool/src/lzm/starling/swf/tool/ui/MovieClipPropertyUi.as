package lzm.starling.swf.tool.ui
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	
	import flash.events.Event;
	
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.tool.asset.Assets;

	/**
	 * 
	 * @author zmliu
	 * 
	 */
	public class MovieClipPropertyUi extends BaseUI
	{
		
		private var _movieClip:SwfMovieClip;
		
		private var _totalFrames:Label;
		private var _labels:ComboBox;
		private var _isLoop:CheckBox;
		
		public function MovieClipPropertyUi()
		{
			super();
			loadUi("assets/ui/movieclip_property.xml");
		}
		
		protected override function loadXMLComplete(e:Event):void{
			_totalFrames = uiConfig.getCompById("totalFrames") as Label;
			_labels = uiConfig.getCompById("labelsComboBox") as ComboBox;
			_isLoop = uiConfig.getCompById("isLoop") as CheckBox;
		}
		
		public function set movieClip(value:SwfMovieClip):void{
			_movieClip = value;
			
			_totalFrames.text = _movieClip.totalFrames + "";
			
			_labels.selectedIndex = -1;
			_labels.items = _movieClip.labels;
			_labels.enabled = _labels.items.length > 0;
			
			_isLoop.selected = _movieClip.loop;
		}
		
		public function onSelectLabels(e:Event):void{
			if(_labels.selectedIndex != -1){
				_movieClip.gotoAndPlay(_labels.selectedItem);
			}
		}
		
		public function onChangeLoop(e:Event):void{
			_movieClip.loop = _isLoop.selected;
			
			Assets.movieClipDatas[_movieClip.name]["loop"] = _movieClip.loop;
			Assets.swf.swfData[Swf.dataKey_MovieClip][_movieClip.name]["loop"] = _movieClip.loop;
			Assets.putTempData(_movieClip.name,_movieClip.loop);
		}
		
		public function onPlay(e:Event):void{
			_movieClip.play();
		}
		
	}
}