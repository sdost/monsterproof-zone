package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.sven.animation.AnimationSet;
	
	/**
	 * ...
	 * @author sam
	 */
	public class UnbreakableBrick extends SimpleBrick
	{
		
		public function UnbreakableBrick(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			this.hitPoints = 500;
		}//end constructor()
		
	}//end UnbreakableBrick

}//end package