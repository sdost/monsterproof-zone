package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import org.flintparticles.common.renderers.Renderer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SimpleBrick extends Brick
	{
		public function SimpleBrick(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override public function notifyHit():Boolean
		{
			addAction(new DisintegrateBrickAction(this));
			activateAction(DisintegrateBrickAction.NAME);
			
			return super.notifyHit();
		}//end notifyHit()
		
		override public function destroy():void 
		{
			removeAction(DisintegrateBrickAction.NAME);
			
			super.destroy();
		}//end destroy()
		
	}//end SimpleBrick

}//end package