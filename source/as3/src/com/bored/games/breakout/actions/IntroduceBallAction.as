package com.bored.games.breakout.actions 
{
	import Box2DAS.Common.V2;
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BallIntro;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class IntroduceBallAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.IntroduceBallAction";
	
		private var _emitter:Emitter2D;
		
		public function IntroduceBallAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function startAction():void 
		{
			_finished = false;
			
			_emitter = new BallIntro( (_gameElement as Ball) );
			_emitter.useInternalTick = false;
			_emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishAction, false, 0, true );
			GameView.ParticleRenderer.addEmitter(_emitter);
			_emitter.start();
			
			_gameElement.visible = false;
		}//end startAction()
		
		private function finishAction(e:Event):void
		{
			_emitter.stop();
			_emitter.removeEventListener( EmitterEvent.EMITTER_EMPTY, finishAction);
			
			_finished = true;
			
			GameView.ParticleRenderer.removeEmitter(_emitter);
			
			_gameElement.visible = true;
			//_emitter = null;
		}//end finishAction()
		
		override public function update(a_time:Number):void 
		{
			if ( _emitter )
			{
				_emitter.update(a_time);
			}
		}//end update()
		
	}//end IntroduceBallAction

}//end package