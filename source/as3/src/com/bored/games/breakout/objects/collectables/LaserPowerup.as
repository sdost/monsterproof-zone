package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LaserPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.LaserPowerup_MC')]
		private static var mcCls:Class;	
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function LaserPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return LaserPaddleAction.NAME;
		}//end get actionName()
		
	}//end LaserPowerup

}//end package