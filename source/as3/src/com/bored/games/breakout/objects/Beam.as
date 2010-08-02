package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Beam extends GameElement
	{
		private var _beamBody:b2Body;
		
		private var _animatedSprite:AnimatedSprite;
		
		private var _animationController:AnimationController;
		
		public function Beam(a_sprite:AnimatedSprite)
		{		
			_animatedSprite = a_sprite;
			
			_animationController = new AnimationController(_animatedSprite);
			_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, animationComplete, false, 0, true);
						
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
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsOrientedBox( (_animatedSprite.width / 2) / PhysicsWorld.PhysScale, (_animatedSprite.height / 2) / PhysicsWorld.PhysScale, new b2Vec2(0, _animatedSprite.height / 2 / PhysicsWorld.PhysScale) );
			
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Bullet;
			filter.maskBits = GameView.id_Brick | GameView.id_Wall;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.filter = filter;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			fd.isSensor = true;
			
			_beamBody = PhysicsWorld.CreateBody(bd);
			_beamBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		private function cleanupPhysics():void
		{
			PhysicsWorld.DestroyBody(_beamBody);
			
			_beamBody = null;
		}//end cleanupPhysics()
		
		public function get physicsBody():b2Body
		{
			return _beamBody;
		}//end get physicsBody()
		
		public function get currFrame():BitmapData
		{
			return _animationController.currFrame;
		}//end get bitmap()
		
		override public function get width():Number
		{
			return _animationController.currFrame.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _animationController.currFrame.height;
		}//end get height()
		
		public function updateBody():void
		{
			var fixture:b2Fixture = _beamBody.GetFixtureList();
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsOrientedBox( (_animationController.currFrame.width / 2) / PhysicsWorld.PhysScale, (_animationController.currFrame.height / 2) / PhysicsWorld.PhysScale, new b2Vec2(0, _animationController.currFrame.height / 2 / PhysicsWorld.PhysScale) );
			
			fixture.GetShape().Set(shape);
		}//end updateBody()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			_animationController.update(t);
			
			if ( _beamBody ) 
			{
				updateBody();
				var pos:b2Vec2 = _beamBody.GetPosition();
			
				this.x = pos.x * PhysicsWorld.PhysScale - ( width / 2 );
				this.y = pos.y * PhysicsWorld.PhysScale;
			}
		}//end update()
		
		private function animationComplete(e:Event):void
		{
			destroy();
		}//end animationComplete()
		
		public function destroy():void 
		{			
			cleanupPhysics();
		}//end destroy()
		
	}//end Beam

}//end package