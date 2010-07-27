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
		
		private var _animation:int;
		
		public function MultiHitBrick(a_hits:uint, a_width:uint, a_height:uint, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			this.hitPoints = a_hits;
			
			_animation = 0;
			
			_animatedSprite = _animationSet.getAnimation(DAMAGE[_animation]);
		}//end constructor()
		
		override public function notifyHit(a_damage:int):Boolean 
		{
			if ( super.notifyHit(a_damage) )
			{
				addAction(new DisintegrateBrickAction(this));
				activateAction(DisintegrateBrickAction.NAME);			
				return true;
			}
			else
			{
				_animation++;
				
				_animatedSprite = _animationSet.getAnimation(DAMAGE[_animation]);
				return false;
			}
		}//end notifyHit()
		
		override public function destroy():void 
		{
			removeAction(DisintegrateBrickAction.NAME);
			
			super.destroy();
		}
		
	}//end MultiHitBrick

}//end package