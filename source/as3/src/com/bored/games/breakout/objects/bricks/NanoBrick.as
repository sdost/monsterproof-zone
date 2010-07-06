package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.objects.AnimationController;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.objects.Grid;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class NanoBrick extends Brick
	{
		// Animation States
		public static const NANO_LIVE:String = "nano_live";
		public static const NANO_DORMANT:String = "nano_dormant";
		public static const NANO_REVIVE:String = "nano_revive";
		
		private var _alive:Boolean;
		
		private var _animController:AnimationController;
		
		public function NanoBrick(a_width:int, a_height:int, a_set:AnimationSet, a_alive:Boolean = true) 
		{
			super(a_width, a_height, a_set);
			
			_alive = a_alive;
			
			addAction(new DisintegrateBrickAction(this));
			
			var loop:Boolean = false;
			
			if (_alive)
			{
				_animatedSprite = _animationSet.getAnimation(NANO_LIVE);
				loop = true;
			}
			else
			{
				_animatedSprite = _animationSet.getAnimation(NANO_DORMANT);
			}
			
			_animController = new AnimationController(_animatedSprite, loop);
			
		}//end constructor()
		
		override public function addToGrid(a_grid:Grid, a_x:uint, a_y:uint):void 
		{
			super.addToGrid(a_grid, a_x, a_y);
			
			if (_alive)
				_brickFixture.SetSensor(false)
			else
				_brickFixture.SetSensor(true);
			
			_grid.addNanoBrick(this);
		}//end addToGrid()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override public function notifyHit():void 
		{
			if ( !_brickFixture.IsSensor() )
			{
				activateAction(DisintegrateBrickAction.NAME);
				sleep();
			}
		}//end notifyHit()
			
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animController.update(t);
		}//end update()
		
		public function revive():void
		{
			_alive = true;
			_brickFixture.SetSensor(false);
			
			_animatedSprite = _animationSet.getAnimation(NANO_REVIVE);
			_animController.setAnimation(_animatedSprite, false);
			_animController.addEventListener( AnimationController.ANIMATION_COMPLETE, reviveAnimationComplete, false, 0, true );
		}//end revive()
		
		private function reviveAnimationComplete(e:Event):void
		{
			_animController.removeEventListener( AnimationController.ANIMATION_COMPLETE, reviveAnimationComplete );
			
			_animatedSprite = _animationSet.getAnimation(NANO_LIVE);
			_animController.setAnimation(_animatedSprite, true);
		}//end reviveAnimationComplete()
		
		public function sleep():void
		{
			if ( _animController.hasEventListener( AnimationController.ANIMATION_COMPLETE ) )
			{
				_animController.removeEventListener( AnimationController.ANIMATION_COMPLETE, reviveAnimationComplete );
			}
			
			_alive = false;
			_brickFixture.SetSensor(true);
			
			_animatedSprite = _animationSet.getAnimation(NANO_DORMANT);
			_animController.setAnimation(_animatedSprite, false);
		}//end sleep()
		
		override public function get currFrame():BitmapData
		{
			return _animController.currFrame;
		}//end currFrame()
		
		public function get alive():Boolean
		{
			return _alive;
		}//end get alive()
		
		override public function destroy():void 
		{			
			super.destroy();
		}//end destroy()
		
	}//end NanoBrick

}//end package