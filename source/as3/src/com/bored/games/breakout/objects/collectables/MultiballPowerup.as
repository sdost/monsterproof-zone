package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MultiballPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.MultiballPowerup_MC')]
		private static var mcCls:Class;		
		
		public function MultiballPowerup() 
		{
			super( AnimatedSpriteFactory.generateAnimatedSprite(new mcCls()) );
		}//end constructor()
		
		override public function get actionName():String 
		{
			return "multiball";
		}//end get actionName()
		
	}//end MultiballPowerup

}//end package