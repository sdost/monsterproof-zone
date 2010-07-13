package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DestructballPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.DestructballPowerup_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function DestructballPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return CatchPaddleAction.NAME;
		}//end get actionName()
		
	}//end DestructballPowerup

}//end package