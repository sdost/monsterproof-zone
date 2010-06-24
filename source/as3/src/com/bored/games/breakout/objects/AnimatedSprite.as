package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedSprite extends GameElement
	{
		private var _frames_BMD:Vector.<BitmapData>;
		
		private var _currFrameInd:uint;
		private var _totalFrames:uint;
		
		public function AnimatedSprite(a_frames:uint) 
		{
			super();
			
			_frames_BMD = new Vector.<BitmapData>(a_frames, true);
			_currFrameInd = 0;
			_totalFrames = 0;
		}//end constructor()
		
		public function addFrame(a_bmd:BitmapData):void
		{
			_frames_BMD[_totalFrames++] = a_bmd; 
		}//end addFrame()
		
		override public function update(t:Number = 0):void
		{
			_currFrameInd ++;
			
			if ( _currFrameInd >= _totalFrames )
				_currFrameInd = 0;
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