package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.SuperLaserPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SuperLaserPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.SuperLaserPowerup_MC')]
		private static var mcCls:Class;	
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function SuperLaserPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return SuperLaserPaddleAction.NAME;
		}//end get actionName()
		
	}//end SuperLaserPowerup

}//end package