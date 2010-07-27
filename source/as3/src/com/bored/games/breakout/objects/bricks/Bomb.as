package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.ExplodeBrickAction;
	import com.bored.games.breakout.emitters.BrickExplosion;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationController;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.states.views.GameView;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Bomb extends Brick
	{
		private var _animController:AnimationController;
		
		public function Bomb(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override public function notifyHit(a_damage:int):Boolean 
		{			
			if ( super.notifyHit(a_damage) )
			{
				grid.explodeBricks(grid.getAllNeighbors(this));
			
				addAction(new ExplodeBrickAction(this));
				activateAction(ExplodeBrickAction.NAME);
				
				return true;
			}
			
			return false;
		}//end notifyHit()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animatedSprite.update(t);
		}//end update()
		
		override public function get currFrame():BitmapData
		{
			return _animatedSprite.currFrame;
		}//end currFrame()
		
		override public function destroy():void 
		{
			removeAction(ExplodeBrickAction.NAME);
			
			super.destroy();
		}//end destroy()

	}//end Bomb

}//end package