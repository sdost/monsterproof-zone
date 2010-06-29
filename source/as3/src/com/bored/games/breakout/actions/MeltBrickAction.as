package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.emitters.BrickMelt;
	import com.bored.games.breakout.objects.bricks.Brick;
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
	public class MeltBrickAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.MeltBrickAction";
	
		public function MeltBrickAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function startAction():void 
		{
			_finished = false;
			
			var emitter:BrickMelt = new BrickMelt( (_gameElement as Brick) );
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishAction, false, 0, true );
			GameView.ParticleRenderer.addEmitter(emitter);
			emitter.start();
		}//end startAction()
		
		private function finishAction(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener( EmitterEvent.EMITTER_EMPTY, finishAction);
			
			_finished = true;
			
			GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
		}//end finishAction()
		
	}//end MeltBrickAction

}//end package