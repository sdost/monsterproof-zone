package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class UnbreakableBrick extends Brick
	{
		
		public function UnbreakableBrick(a_width:int, a_height:int, a_sprite:AnimatedSprite) 
		{
			super(a_width, a_height, a_sprite);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override public function notifyHit():void 
		{
			// DO NOTHING!
		}//end notifyHit()
		
	}//end UnbreakableBrick

}//end package