package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickExplosion;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ExplodeBrickAction extends Action
	{
		
		public static const NAME:String = "com.bored.games.breakout.actions.ExplodeBrickAction";
	
		public function ExplodeBrickAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function startAction():void 
		{
			_finished = false;
			
			//SoundManager.getInstance().getSoundControllerByID("sfxController").play(GameView.sfx_BrickExplode);
			
			var emitter:BrickExplosion = new BrickExplosion( (_gameElement as Brick) );
			emitter.useInternalTick = false;
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishAction, false, 0, true );
			GameView.ParticleRenderer.addEmitter(emitter);
			GameView.Emitters.append(emitter);
			emitter.start();
		}//end startAction()
		
		private function finishAction(e:Event):void
		{
			Emitter2D(e.currentTarget).stop();
			Emitter2D(e.currentTarget).removeEventListener( EmitterEvent.EMITTER_EMPTY, finishAction);
			
			_finished = true;
			
			GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
			GameView.Emitters.remove(Emitter2D(e.currentTarget));
		}//end finishAction()
		
	}//end ExplodeBrickAction

}//end package