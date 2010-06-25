package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import org.flintparticles.common.renderers.Renderer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SimpleBrick extends Brick
	{
		private var _disintegrate:DisintegrateBrickAction;
		
		public function SimpleBrick(a_width:int, a_height:int, a_sprite:AnimatedSprite) 
		{
			super(a_width, a_height, a_sprite);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
			
			_disintegrate = new DisintegrateBrickAction(this);
			addAction(_disintegrate);
		}//end initializeActions()
		
		override public function notifyHit():void 
		{
			activateAction(DisintegrateBrickAction.NAME);
			
			super.notifyHit();
		}//end notifyHit()
		
	}//end SimpleBrick

}//end package