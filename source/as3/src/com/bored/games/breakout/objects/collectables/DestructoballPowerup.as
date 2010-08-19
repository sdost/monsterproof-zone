package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.actions.DestructoballAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DestructoballPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.DestructoballPowerup_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function DestructoballPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return DestructoballAction.NAME;
		}//end get actionName()
		
	}//end DestructoballPowerup

}//end package