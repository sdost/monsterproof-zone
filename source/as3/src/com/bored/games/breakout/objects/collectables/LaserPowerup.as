package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LaserPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.LaserPowerup_MC')]
		private static var mcCls:Class;		
		
		public function LaserPowerup() 
		{
			super( AnimatedSpriteFactory.generateAnimatedSprite(new mcCls()) );
		}//end constructor()
		
		override public function get actionName():String 
		{
			return LaserPaddleAction.NAME;
		}//end get actionName()
		
	}//end LaserPowerup

}//end package