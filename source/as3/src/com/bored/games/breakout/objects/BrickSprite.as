package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BrickSprite extends GameElement
	{
		private var _frames_BMD:Vector.<BitmapData>;
		
		private var _currFrameInd:uint;
		private var _totalFrames:uint;
		
		public function BrickSprite() 
		{
			super();
			
			_frames_BMD = new Vector.<BitmapData>(30, true);
			_currFrameInd = 0;
			_totalFrames = 0;
		}//end contructor()
		
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
		
	}//end BrickSprite

}//end package