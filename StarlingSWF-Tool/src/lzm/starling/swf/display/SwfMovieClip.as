package lzm.starling.swf.display
{
	import lzm.starling.swf.Swf;
	import lzm.starling.swf.SwfUpdateManager;
	
	import starling.display.DisplayObject;
	
	
	public class SwfMovieClip extends SwfSprite
	{
		public static const ANGLE_TO_RADIAN:Number = Math.PI / 180;
		
		private var _frames:Array;
		private var _labels:Array;
		private var _displayObjects:Object;
		
		private var _startFrame:int;
		private var _endFrame:int;
		private var _currentFrame:int;
		
		private var _isPlay:Boolean = false;
		private var _loop:Boolean = true;
		
		private var _completeFunction:Function = null;//播放完毕的回调
		
		public function SwfMovieClip(frames:Array,labels:Array,displayObjects:Object){
			super();
			
			_frames = frames;
			_labels = labels;
			_displayObjects = displayObjects;
			
			_startFrame = 0;
			_endFrame = _frames.length - 1;
			_currentFrame = -1;
			
			play();
		}
		
		public function update():void{
			_currentFrame += 1;
			if(_currentFrame > _endFrame){
				if(_completeFunction) _completeFunction(this);
				
				if(_loop) _loop = !(_startFrame == _endFrame);//只有一帧就不要循环下去了
				if(_loop){
					_currentFrame = _startFrame;
				}else{
					_currentFrame = _startFrame - 1;
					stop();
					return;
				}
			}
			setCurrentFrame(_currentFrame);
		}
		
		
		private var _frameInfos:Array;
		private var _useIndexs:Object;
		public function setCurrentFrame(frame:int):void{
			clearChild();
			
			_frameInfos = _frames[_currentFrame];
			_useIndexs = {};
			
			var name:String;
			var type:String;
			var data:Array;
			var display:DisplayObject;
			var useIndex:int;
			var length:int = _frameInfos.length;
			for (var i:int = 0; i < length; i++) {
				data = _frameInfos[i];
				useIndex = _useIndexs[data[0]];
				display = _displayObjects[data[0]][useIndex];
				
				display.x = data[2];
				display.y = data[3];
				display.scaleX = data[4];
				display.scaleY = data[5];
				display.skewX = data[6] * ANGLE_TO_RADIAN;
				display.skewY = data[7] * ANGLE_TO_RADIAN;
				display.name = data[8];
				addQuiackChild(display);
				
				if(data[1] == Swf.dataKey_TextField){
					display["width"] = data[9];
					display["height"] = data[10];
					display["fontName"] = data[11];
					display["color"] = data[12];
					display["fontSize"] = data[13];
					display["vAlign"] = data[14];
					display["italic"] = data[15];
					display["bold"] = data[16];
					display["text"] = data[17];
				}
				_useIndexs[data[0]] = (useIndex+1);
			}
		}
		
		public function play():void{
			if(_isPlay) return;
			_isPlay = true;
			SwfUpdateManager.addSwfMovieClip(this);
		}
		
		public function stop():void{
			_isPlay = false;
			SwfUpdateManager.removeSwfMovieClip(this);
		}
		
		public function gotoAndStop(frame:Object):void{
			goTo(frame);
			stop();
		}
		
		public function gotoAndPlay(frame:Object):void{
			goTo(frame);
			play();
		}
		
		private function goTo(frame:*):void{
			if((frame is String)){
				var labelData:Array = getLabelData(frame);
				_currentFrame = _startFrame = labelData[1];
				_endFrame = labelData[2];
			}else if(frame is int){
				_currentFrame = _startFrame = 0;
				_endFrame = _frames.length - 1;
			}
			setCurrentFrame(_currentFrame);
		}
		
		private function getLabelData(label:String):Array{
			var length:int = _labels.length;
			var labelData:Array;
			for (var i:int = 0; i < length; i++) {
				labelData = _labels[i];
				if(labelData[0] == label){
					return labelData;
				}
			}
			return null;
		}
		
		
		public function get isPlay():Boolean{
			return _isPlay;
		}
		
		public function get loop():Boolean{
			return _loop;
		}
		
		public function set loop(value:Boolean):void{
			_loop = loop;
		}
		
		/**
		 * 设置播放完毕的回调
		 */		
		public function set completeFunction(value:Function):void{
			_completeFunction = value;
		}
		
		public override function dispose():void{
			SwfUpdateManager.removeSwfMovieClip(this);
			super.dispose();
		}
		
		
		
	}
}