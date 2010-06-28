package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedSprite extends GameElement
	{
		private var _frames_BMD:Vector.<BitmapData>;
		
		private var _currFrame:Number;
		private var _currFrameInd:uint;
		private var _totalFrames:uint;
		private var _frameRate:uint;
		
		private var _lastUpdate:uint;
		
		public function AnimatedSprite(a_frames:uint) 
		{
			super();
			
			_frames_BMD = new Vector.<BitmapData>(a_frames, true);
			_currFrame = 0;
			_currFrameInd = 0;
			_totalFrames = 0;
			_frameRate = AppSettings.instance.defaultSpriteFrameRate;
		}//end constructor()
		
		public function addFrame(a_bmd:BitmapData):void
		{
			_frames_BMD[_totalFrames++] = a_bmd; 
		}//end addFrame()
		
		override public function update(t:Number = 0):void
		{
			var delta:uint = (t - _lastUpdate);
			_lastUpdate = t;
			
			_currFrame += (delta * _frameRate) / 1000;
			
			_currFrameInd = Math.ceil(_currFrame);
			
			if ( _currFrameInd >= _totalFrames )
				_currFrameInd = _currFrame = 0;
		}//end update()
		
		public function get currFrame():BitmapData
		{
			var bmd:BitmapData = _frames_BMD[_currFrameInd];
			
			if (bmd)
			{
				return bmd;
			}
			else
			{
				return null;
			}
		}//end get currFrame()
		
		override public function get width():Number 
		{
			return _frames_BMD[_currFrameInd].width;
		}//end get width()
		
		override public function get height():Number
		{
			return _frames_BMD[_currFrameInd].height;
		}//end get height()
		
	}//end AnimatedSprite

}//end package