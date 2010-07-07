package com.bored.games.breakout.objects.collectables 
{
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ExtendPowerup extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.ExtendPowerup_MC')]
		private static var mcCls:Class;		
		
		public function ExtendPowerup() 
		{
			super( AnimatedSpriteFactory.generateAnimatedSprite(new mcCls()) );
		}//end constructor()
		
		override public function get actionName():String 
		{
			return ExtendPaddleAction.NAME;
		}//end get actionName()
		
	}//end ExtendPowerup

}//end package