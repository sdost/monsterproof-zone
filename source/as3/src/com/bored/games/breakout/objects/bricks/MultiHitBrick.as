package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimationSet;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MultiHitBrick extends Brick
	{
		public static const DAMAGE:Array = [ "Damage0", "Damage1", "Damage2" ];
		
		private var _disintegrate:DisintegrateBrickAction;
		//private var _crack:CrackBrickAction;
		
		private var _hitsToBreak:uint;
		private var _accumulatedHits:uint;
		
		public function MultiHitBrick(a_hits:uint, a_width:uint, a_height:uint, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			_hitsToBreak = a_hits;
			_accumulatedHits = 0;
			
			_animatedSprite = _animationSet.getAnimation(DAMAGE[_accumulatedHits]);
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
			else
			{
				_animatedSprite = _animationSet.getAnimation(DAMAGE[_accumulatedHits]);
				//activateAction(CrackBrickAction.NAME);
			}
		}//end notifyHit()
		
		override public function destroy():void 
		{
			removeAction(DisintegrateBrickAction.NAME);
			//removeAction(CrackBrickAction.NAME);
			
			super.destroy();
		}
		
	}//end MultiHitBrick

}//end package