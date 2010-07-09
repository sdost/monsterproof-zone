package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CatchPaddleAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.CatchPaddleAction";
		
		private var _effectTime:Number;
		
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
			
			if ( _finished )
			{
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_NORMAL);
			}
			else
			{
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_CATCH);
			}
		}//end set finished()
		
	}//end CatchPaddleAction

}//end package