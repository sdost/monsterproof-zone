package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.jac.soundManager.SoundManager;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DisintegrateBrickAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.DisintegrateBrickAction";
		
		public static const sfx_DisintegrateLg:String = "disintegrate_lg";
	
		public function DisintegrateBrickAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			/*
			SoundManager.getInstance().getSoundControllerByID("sfxController").addSound( new SMSound("disintegrate_lg_1", "breakout.assets.sfx.BrickDestroyLg_1", false) );
			SoundManager.getInstance().getSoundControllerByID("sfxController").addSound( new SMSound("disintegrate_lg_2", "breakout.assets.sfx.BrickDestroyLg_2", false) );
			SoundManager.getInstance().getSoundControllerByID("sfxController").addSound( new SMSound("disintegrate_lg_3", "breakout.assets.sfx.BrickDestroyLg_3", false) );
			SoundManager.getInstance().getSoundControllerByID("sfxController").addSound( new SMSound("disintegrate_lg_4", "breakout.assets.sfx.BrickDestroyLg_4", false) );
			*/
		}//end constructor()
		
		override public function startAction():void 
		{
			_finished = false;
			
			//var v:uint = uint(Math.random() * 3 + 1);
			
			//SoundManager.getInstance().getSoundControllerByID("sfxController").play(sfx_DisintegrateLg + "_" + v);
			
			var emitter:BrickCrumbs = new BrickCrumbs( (_gameElement as Brick) );
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
		
	}//end DisintegrateBrickAction

}//end package