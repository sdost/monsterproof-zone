package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.ExplodeBombAction;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import org.flintparticles.common.renderers.Renderer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Bomb extends Brick
	{
		private var _explode:ExplodeBombAction;
		
		public function Bomb(a_width:int, a_height:int, a_sprite:AnimatedSprite) 
		{
			super(a_width, a_height, a_sprite);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
			
			_explode = new ExplodeBombAction(this);
			addAction(_explode);
		}//end initializeActions()
		
		override public function notifyHit():void 
		{			
			activateAction(ExplodeBombAction.NAME);
			
			super.notifyHit();
		}//end notifyHit()
		
	}//end Bomb

}//end package