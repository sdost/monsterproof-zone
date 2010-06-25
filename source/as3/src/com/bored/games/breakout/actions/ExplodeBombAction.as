package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickExplosion;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ExplodeBombAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.ExplodeBombAction";
		
		public function ExplodeBombAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);	
		}//end constructor()
		
		override public function startAction():void 
		{			
			var brick:Brick = (_gameElement as Brick);
			
			var emitter:Emitter2D = new BrickExplosion(brick);
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishExplosion, false, 0, true );
			GameView.ParticleRenderer.addEmitter(emitter);
			emitter.start();
			
			var grid:Grid = brick.grid;
			
			var go:Brick;
			
			for ( var i:uint = brick.gridX - 1; i <= brick.gridX + brick.gridWidth + 1; i++ )
			{
				for ( var j:uint = brick.gridY - 1; j <= brick.gridY + brick.gridHeight + 1; j++ )
				{
					go = grid.getGridObjectAt(i, j) as Brick;
					if ( go && go != brick )
					{
						go.notifyHit();
						
						emitter = new BrickExplosion(go);
						emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishExplosion, false, 0, true );
						GameView.ParticleRenderer.addEmitter(emitter);
						emitter.start();
					}
				}
			}
		}//end startAction()
		
		private function finishExplosion(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener( EmitterEvent.EMITTER_EMPTY, finishExplosion);
			
			GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
		}//end finishAction()
		
	}//end ExplodeBombAction

}//end package