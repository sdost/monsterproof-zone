package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CatchPaddleAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.CatchPaddleAction";
		
		private var _startTime:int;
		private var _effectTime:int;
		
		private var _sndLoop:MightySound;
		
		public function CatchPaddleAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
			_effectTime = a_params.time;
		}//end initParams()
		
		override public function startAction():void 
		{	
			_startTime = getTimer();
			
			_sndLoop = MightySoundManager.instance.getMightySoundByName("sfxPaddleCatchLoop");
			if (_sndLoop)
			{
				_sndLoop.infiniteLoop = true;
				_sndLoop.play();
			}
			
			this.finished = false;
		}//end startAction()
		
		override public function update(a_time:Number):void 
		{
			if ( (getTimer() - _startTime) > _effectTime )
			{					
				this.finished = true;
			}
		}//end update()
		
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				if(_sndLoop) _sndLoop.stop();
				(_gameElement as Paddle).stickyMode = false;
				(_gameElement as Paddle).releaseBall();
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_CATCH_OUT);
			}
			else
			{
				(_gameElement as Paddle).stickyMode = true;
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_CATCH_IN);
			}
		}//end set finished()
		
	}//end CatchPaddleAction

}//end package