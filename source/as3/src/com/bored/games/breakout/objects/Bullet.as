package com.bored.games.breakout.objects 
{
	import Box2DAS.Collision.Shapes.b2CircleShape;
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2Filter;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
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
		
		protected var _animatedSprite:AnimatedSprite;
		
		public function Bullet(a_sprite:AnimatedSprite)
		{		
			_animatedSprite = a_sprite;
						
			initializePhysicsBody();
		}//end constructor()
		
		protected function initializePhysicsBody():void
		{
			b2Def.body.type = b2Body.b2_dynamicBody;
			b2Def.body.fixedRotation = true;
			b2Def.body.bullet = true;
			b2Def.body.allowSleep = false;
			b2Def.body.userData = this;
			b2Def.body.linearDamping = 0.0;
			
			b2Def.polygon.SetAsBox( (_animatedSprite.width / 2) / PhysicsWorld.PhysScale, (_animatedSprite.height / 2) / PhysicsWorld.PhysScale );
			
			/*
			var filter:b2Filter = new b2Filter();
			filter.categoryBits = GameView.id_Bullet;
			filter.maskBits = GameView.id_Brick | GameView.id_Wall;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Bullet;
			b2Def.fixture.filter.maskBits = GameView.id_Brick | GameView.id_Wall;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.friction = 0.0;
			b2Def.fixture.restitution = 1.0;
			b2Def.fixture.userData = this;
			b2Def.fixture.isSensor = false;
			
			_bulletBody = PhysicsWorld.CreateBody(b2Def.body);
			var fixture:b2Fixture = b2Def.fixture.create(_bulletBody);
			fixture.m_reportBeginContact = true;
			fixture.m_reportEndContact = true;
		}//end initializePhysicsBody()
		
		protected function cleanupPhysics():void
		{
			PhysicsWorld.DestroyBody(_bulletBody);
		}//end cleanupPhysics()
		
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
			return _animatedSprite.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _animatedSprite.height;
		}//end get height()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			_animatedSprite.update(t);
			
			var pos:V2 = _bulletBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
		}//end update()
		
		public function destroy():void 
		{			
			cleanupPhysics();
		}//end destroy()
		
	}//end Bullet

}//end package