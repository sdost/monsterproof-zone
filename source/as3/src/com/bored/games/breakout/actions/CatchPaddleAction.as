package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.jac.soundManager.ISMSound;
	import com.jac.soundManager.SoundManager;
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
		
		private var _sndFX:ISMSound;
		
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
			
			_sndFX = SoundManager.getInstance().getSoundControllerByID("sfxController").play(GameView.sfx_PaddleCatch);
			
			this.finished = false;
		}//end startAction()
		
		override public function update(a_time:Number):void 
		{
			if ( (getTimer() - _startTime) > _effectTime )
			{	
				_sndFX.stopSound();
				
				this.finished = true;
			}
		}//end update()
		
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
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