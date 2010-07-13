package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CatchPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.CatchPowerup_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function CatchPowerup() 
		{
			super(sprite);
		}//end constructor()
		
		override public function get actionName():String 
		{
			return CatchPaddleAction.NAME;
		}//end get actionName()
		
	}//end CatchPowerup

}//end package