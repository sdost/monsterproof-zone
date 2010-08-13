package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimationController extends GameElement
	{
		public static const ANIMATION_LOOP:String = "animationLoop";
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		
		private var _frame:Number;
		private var _frameNum:uint;
		private var _lastUpdate:Number;
		private var _totalFrames:uint;
		
		private var _completed:Boolean;
		
		private var _anim:AnimatedSprite;
		private var _loop:Boolean;
		private var _frameRate:uint;
		
		public function AnimationController(a_anim:AnimatedSprite, a_loop:Boolean = false, a_frameRate:uint = 30) 
		{
			super();
			
			_anim = a_anim;
			_loop = a_loop;
			_frameRate = a_frameRate;
			
			_frame = _frameNum = 0;
			_totalFrames = _anim.totalFrames;
			_lastUpdate = getTimer();
			
			_completed = false;
		}//end constructor()
		
		public function setAnimation(a_anim:AnimatedSprite, a_loop:Boolean = false):void
		{
			_anim = a_anim;
			_loop = a_loop;
			
			_frame = _frameNum = 0;
			_totalFrames = _anim.totalFrames;
			_lastUpdate = getTimer();
			
			_completed = false;
		}//end setAnimation()
		
		override public function update(t:Number = 0):void 
		{
			if (_completed) return;
			
			_frame += (t * _frameRate) / 1000;
			_frameNum = Math.ceil(_frame);
			
			if ( _frameNum >= _totalFrames )
			{
				if ( _loop )
				{
					_frame = _frameNum = 0;
					dispatchEvent( new Event(ANIMATION_LOOP) );
				}
				else
				{
					_frame = _frameNum = _totalFrames - 1;
					_completed = true;
					dispatchEvent( new Event(ANIMATION_COMPLETE) );
				}
			}
		}//end update()
		
		public function get currFrame():BitmapData
		{
			return _anim.getFrame(_frameNum);
		}//end get currFrame()
		
	}//end AnimationController

}//end package