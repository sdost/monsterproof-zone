package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimatedSprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MultiHitBrick extends Brick
	{
		private var _disintegrate:DisintegrateBrickAction;
		//private var _crack:CrackBrickAction;
		
		private var _hitsToBreak:uint;
		private var _accumulatedHits:uint;
		
		public function MultiHitBrick(a_hits:uint, a_width:uint, a_height:uint, a_sprite:AnimatedSprite) 
		{
			super(a_width, a_height, a_sprite);
			
			_hitsToBreak = a_hits;
			_accumulatedHits = 0;
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
			
			_disintegrate = new DisintegrateBrickAction(this);
			addAction(_disintegrate);
			
			/*
			_crack = new CrackBrickAction(this);
			addAction(_crack);
			*/
		}//end initializeActions()
		
		override public function notifyHit():void 
		{
			_accumulatedHits++;
			
			if ( _accumulatedHits >= _hitsToBreak ) 
			{
				activateAction(DisintegrateBrickAction.NAME);
				super.notifyHit()
			}
			//else
				//activateAction(CrackBrickAction.NAME);
		}//end notifyHit()
		
	}//end MultiHitBrick

}//end package