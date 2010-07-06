package com.bored.games.breakout.objects.collectables 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.animations.AnimatedShot;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Collectable extends GameElement
	{
		protected var _collectableBody:b2Body;
		
		protected var _animatedSprite:AnimatedSprite;
		
		public function Collectable(a_sprite:AnimatedSprite)
		{
			_animatedSprite = a_sprite;
			
			initializePhysics();
		}//end constructor()
				
		protected function initializeActions():void
		{
		}//end initializeActions
				
		protected function initializePhysics():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.allowSleep = false;
			bd.userData = this;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = _animatedSprite.currFrame.width;
			var b2Height:Number = _animatedSprite.currFrame.height;
			
			shape.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2 );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.isSensor = true;
			fd.userData = this;
			
			_collectableBody = PhysicsWorld.CreateBody(bd);
			_collectableBody.CreateFixture(fd);
		}//end initializePhysics()
		
		private function cleanupPhysics():void
		{
			PhysicsWorld.DestroyBody(_collectableBody);
		}//end cleanupPhysics()
		
		public function get physicsBody():b2Body
		{
			return _collectableBody;
		}//end get physicsBody()
		
		override public function get width():Number 
		{
			return _animatedSprite.currFrame.width;
		}//end get width()
		
		override public function get height():Number 
		{
			return _animatedSprite.currFrame.height;
		}//end get height()
		
		public function get currFrame():BitmapData
		{
			return _animatedSprite.currFrame;
		}//end get currFrame()
		
		public function get actionName():String
		{
			return "";
		}//end get actionName()
		
		public function notifyHit():void
		{
		}//end notifyHit()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animatedSprite.update(t);
			
			var pos:b2Vec2 = _collectableBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
		}//end update()
		
		public function destroy():void 
		{			
			cleanupPhysics();
		}//end destroy()
		
	}//end Collectable

}//end package