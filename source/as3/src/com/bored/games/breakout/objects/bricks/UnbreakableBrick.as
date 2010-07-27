package com.bored.games.breakout.objects.bricks 
{
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
			
			this.hitPoints = 9999;
		}//end constructor()
		
	}//end UnbreakableBrick

}//end package