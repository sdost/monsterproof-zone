package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DestructoballAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.DestructoballAction";
		
		private var _startTime:int;
		private var _effectTime:int;
		
		public function DestructoballAction(a_gameElement:GameElement, a_params:Object = null) 
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
			
			if (_finished)
			{
				(_gameElement as Ball).ballMode = Ball.NORMAL_BALL;
				(_gameElement as Ball).switchAnimation(Ball.NORMAL_BALL);
				(_gameElement as Ball).damagePoints = 1;
			}
			else
			{
				(_gameElement as Ball).ballMode = Ball.SUPER_BALL;
				(_gameElement as Ball).switchAnimation(Ball.SUPER_BALL);
				(_gameElement as Ball).damagePoints = 3;
			}
		}//end set finished()
		
	}//end DestructoballAction

}//end package