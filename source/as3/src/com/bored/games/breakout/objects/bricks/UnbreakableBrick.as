package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimationSet;
	
	/**
	 * ...
	 * @author sam
	 */
	public class UnbreakableBrick extends Brick
	{
		
		public function UnbreakableBrick(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			this.hitPoints = 500;
		}//end constructor()
		
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
		
	}//end UnbreakableBrick

}//end package