package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MultiballPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.MultiballPowerup_MC')]
		private static var mcCls:Class;	
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function MultiballPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return "multiball";
		}//end get actionName()
		
	}//end MultiballPowerup

}//end package