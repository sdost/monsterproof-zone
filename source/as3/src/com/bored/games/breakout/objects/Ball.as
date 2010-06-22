package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Ball extends GameElement
	{
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Ball_BMP')]
		private var imgCls:Class;
		
		private var _ballBmp:Bitmap;
		
		private var _ballBody:b2Body;
		
		private var _speedLimit:Number = 50;
		
		public function Ball()
		{
			_ballBmp = new imgCls();
			
			initializePhysicsBody();
			initializeActions();
		}//end constructor()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.allowSleep = false;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = new b2CircleShape( (_ballBmp.bitmapData.width / 2) / PhysicsWorld.PhysScale );
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			
			_ballBody = PhysicsWorld.CreateBody(bd);
			_ballBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		private function initializeActions():void
		{
			// TODO add initial 
		}//end initializeAction
		
		public function get physicsBody():b2Body
		{
			return _ballBody;
		}//end get physicsBody()
		
		public function get bitmap():Bitmap
		{
			return _ballBmp;
		}//end get bitmap()
		
		override public function get width():Number
		{
			return _ballBmp.bitmapData.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _ballBmp.bitmapData.height;
		}//end get height()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			var pos:b2Vec2 = _ballBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
			
			var bodyVelocity:b2Vec2 =_ballBody.GetLinearVelocity();
			if (bodyVelocity.Length() > _speedLimit) {
				var limitVelocity:b2Vec2 = bodyVelocity.Copy();
				limitVelocity.Normalize();
				limitVelocity.Multiply(_speedLimit);
				var velocityDifference:b2Vec2 = bodyVelocity.Copy()
				velocityDifference.Subtract(limitVelocity);
				_ballBody.ApplyImpulse(velocityDifference.GetNegative(), _ballBody.GetPosition());
			}
		}//end update()
		
	}//end Ball

}//end package