package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Bullet extends GameElement
	{
		private var _bulletBody:b2Body;
		
		private var _animatedSprite:AnimatedSprite;
		
		public function Bullet(a_sprite:AnimatedSprite)
		{		
			_animatedSprite = a_sprite;
						
			initializePhysicsBody();
		}//end constructor()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.bullet = true;
			bd.allowSleep = false;
			bd.userData = this;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = new b2CircleShape( (_animatedSprite.width / 2) / PhysicsWorld.PhysScale );
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			fd.isSensor = true;
			
			_bulletBody = PhysicsWorld.CreateBody(bd);
			_bulletBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		public function get physicsBody():b2Body
		{
			return _bulletBody;
		}//end get physicsBody()
		
		public function get currFrame():BitmapData
		{
			return _animatedSprite.currFrame;
		}//end get bitmap()
		
		override public function get width():Number
		{
			return _animatedSprite.currFrame.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _animatedSprite.currFrame.height;
		}//end get height()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			_animatedSprite.update(t);
			
			var pos:b2Vec2 = _bulletBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
		}//end update()
		
	}//end Bullet

}//end package