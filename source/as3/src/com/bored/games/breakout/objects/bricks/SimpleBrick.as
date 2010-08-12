package com.bored.games.breakout.objects.bricks 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
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
		
		override public function notifyHit(a_damage:int):Boolean
		{
			if ( super.notifyHit(a_damage) )
			{
				addAction(new DisintegrateBrickAction(this));
				activateAction(DisintegrateBrickAction.NAME);
				
				return true;
			}
			
			return false;
		}//end notifyHit()
		
		override public function destroy():void 
		{
			removeAction(DisintegrateBrickAction.NAME);
			
			super.destroy();
		}//end destroy()
		
	}//end SimpleBrick

}//end package