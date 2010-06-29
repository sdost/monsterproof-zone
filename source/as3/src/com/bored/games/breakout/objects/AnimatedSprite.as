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
		private var _refCount:uint = 0;
		
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
		
		public function getFrame(a_num:int):BitmapData
		{			
			if( a_num >= _totalFrames )
				return _frames_BMD[_totalFrames - 1];
			else
				return _frames_BMD[a_num];
		}//end advanceFrame()
		
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
			return _frames_BMD[_currFrameInd];
		}//end get currFrame()
		
		override public function get width():Number 
		{
			return _frames_BMD[_currFrameInd].width;
		}//end get width()
		
		override public function get height():Number
		{
			return _frames_BMD[_currFrameInd].height;
		}//end get height()
		
		public function incrementReferenceCount():void
		{
			_refCount++;
		}//end incrementReferenceCount()
		
		public function decrementReferenceCount():void
		{
			_refCount--;
			
			if ( _refCount == 0 )
			{
				destroyBitmapData();
			}
		}//end decrementReferenceCount()
		
		private function destroyBitmapData():void
		{			
			for ( var i:uint = 0; i < _totalFrames; i++ )
			{
				_frames_BMD[i].dispose();
				_frames_BMD[i] = null;
			}
			
			_frames_BMD = null;
		}//end destroyBitmapData()
		
	}//end AnimatedSprite

}//end package