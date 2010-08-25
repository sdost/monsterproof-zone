package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BallStateTransition;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
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
			
			var emitter:BallStateTransition = new BallStateTransition( (_gameElement as Ball), 0xFF99FFFF, 0xFFCCFFFF );
			emitter.useInternalTick = false;
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishAction, false, 0, true );
			GameView.ParticleRenderer.addEmitter(emitter);
			GameView.Emitters.append(emitter);
			emitter.start();
			
			this.finished = false;
		}//end startAction()
		
		private function finishAction(e:Event):void
		{
			Emitter2D(e.currentTarget).stop();
			Emitter2D(e.currentTarget).removeEventListener( EmitterEvent.EMITTER_EMPTY, finishAction);
			
			GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
			GameView.Emitters.remove(Emitter2D(e.currentTarget));
		}//end finishAction()
		
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