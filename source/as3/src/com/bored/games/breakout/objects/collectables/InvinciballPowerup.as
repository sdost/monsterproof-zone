package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.actions.InvinciballAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class InvinciballPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.InvinciballPowerup_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function InvinciballPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return InvinciballAction.NAME;
		}//end get actionName()
		
	}//end InvinciballPowerup

}//end package