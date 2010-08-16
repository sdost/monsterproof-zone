package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedSprite extends GameElement
	{
		private static var _emptyBMD:BitmapData = new BitmapData(1, 1, true, 0x00000000);
		
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
			
			_frames_BMD = new Vector.<BitmapData>(a_frames + 1, true);			
			_currFrame = _currFrameInd = 1;
			_totalFrames = 0;
			_frameRate = AppSettings.instance.defaultSpriteFrameRate;
		}//end constructor()
		
		public function addFrame(a_bmd:BitmapData):void
		{
			_frames_BMD[_totalFrames++] = a_bmd; 
		}//end addFrame()
		
		public function getFrame(a_num:int):BitmapData
		{		
			var frame:int = this.visible ? a_num : 0;
			
			if( frame >= _totalFrames )
				return _frames_BMD[_totalFrames - 1];
			else
				return _frames_BMD[frame];
		}//end advanceFrame()
		
		override public function update(t:Number = 0):void
		{	
			_currFrame += (t/frameRate);
			_currFrameInd = Math.ceil(_currFrame);
				
			if ( _currFrameInd >= _totalFrames )
			{
				_currFrame = _currFrameInd = 1;
			}
		}//end update()
		
		public function get currFrame():BitmapData
		{
			if( this.visible )
				return _frames_BMD[_currFrameInd];
			else
				return _frames_BMD[0];
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
		
		override public function get currentFrame():int 
		{
			return _currFrameInd;
		}//end get currentFrame()
		
		override public function get totalFrames():int 
		{
			return _totalFrames;
		}//end get totalFrames()
		
		public function get frameRate():int
		{
			return _frameRate;
		}//end get frameRate()
		
		public function set frameRate(a_fr:int):void
		{
			_frameRate = a_fr;
		}//end set frameRate()
		
		override public function reset():void 
		{
			_currFrame = _currFrameInd = 1;
		}//end reset()
		
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