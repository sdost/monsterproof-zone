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
	public class DestructBallAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.DestructBallAction";
		
		public function DestructBallAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
		}//end initParams()
		
		override public function startAction():void 
		{	
			this.finished = false;
		}//end startAction()
		
		override public function update(a_time:Number):void 
		{
		}//end update()
		
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				(_gameElement as Ball).switchAnimation(Ball.NORMAL_BALL);
			}
			else
			{
				(_gameElement as Ball).switchAnimation(Ball.DESTRUCT_BALL);
			}
		}//end set finished()
		
	}//end DestructBallAction

}//end package