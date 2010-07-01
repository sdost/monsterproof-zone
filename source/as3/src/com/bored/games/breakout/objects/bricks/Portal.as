package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.objects.AnimationController;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Portal extends Brick
	{
		// Animation States
		public static const PORTAL_OPEN:String = "portal_open";
		public static const PORTAL_LOOP:String = "portal_loop";
		
		private var _animController:AnimationController;
		
		public function Portal(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			_animatedSprite = _animationSet.getAnimation(PORTAL_OPEN);
			
			_animController = new AnimationController(_animatedSprite);
			_animController.addEventListener(AnimationController.ANIMATION_COMPLETE, animationComplete, false, 0, true);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override protected function initializePhysics():void
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = this.gridWidth * AppSettings.instance.defaultTileWidth;
			var b2Height:Number = this.gridHeight * AppSettings.instance.defaultTileHeight;
			
			var b2X:Number = this.gridX * AppSettings.instance.defaultTileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * AppSettings.instance.defaultTileHeight + b2Height / 2;			
			
			shape.SetAsOrientedBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2, new b2Vec2( b2X / PhysicsWorld.PhysScale, b2Y / PhysicsWorld.PhysScale ) );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.userData = this;
			fd.isSensor = true;
			
			_brickFixture = _grid.gridBody.CreateFixture(fd);
		}//end initializePhysics()
		
		override public function notifyHit():void 
		{			
			//super.notifyHit();
		}//end notifyHit()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animController.update(t);
		}//end update()
		
		override public function get currFrame():BitmapData
		{
			return _animController.currFrame;
		}//end currFrame()
		
		private function animationComplete(e:Event):void
		{
			_animController.removeEventListener(AnimationController.ANIMATION_COMPLETE, animationComplete);
			
			_animatedSprite = _animationSet.getAnimation(PORTAL_LOOP);
			_animController.setAnimation(_animatedSprite, true);
		}//end animationComplete()
		
		override public function destroy():void 
		{			
			super.destroy();
		}//end destroy()
		
	}//end Portal

}//end package