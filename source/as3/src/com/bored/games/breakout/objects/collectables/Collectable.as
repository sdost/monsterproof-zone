package com.bored.games.breakout.objects.collectables 
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2Filter;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.animations.AnimatedShot;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationController;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
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
		protected var _animationController:AnimationController;
		
		public function Collectable(a_sprite:AnimatedSprite)
		{
			_animatedSprite = a_sprite;
			_animationController = new AnimationController(_animatedSprite, true);
			
			initializePhysics();
		}//end constructor()
				
		protected function initializeActions():void
		{
		}//end initializeActions
				
		protected function initializePhysics():void
		{
			b2Def.body.type = b2Body.b2_dynamicBody;
			b2Def.body.fixedRotation = true;
			b2Def.body.allowSleep = false;
			b2Def.body.userData = this;
			b2Def.body.linearDamping = 0.0;
			
			var b2Width:Number = _animatedSprite.currFrame.width;
			var b2Height:Number = _animatedSprite.currFrame.height;
			
			b2Def.polygon.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2 );
			
			/*
			var filter:b2Filter = new b2Filter();
			filter.categoryBits = GameView.id_Collectable;
			filter.maskBits = GameView.id_Paddle | GameView.id_Wall;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Collectable;
			b2Def.fixture.filter.maskBits = GameView.id_Paddle | GameView.id_Wall;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.friction = 0.0;
			b2Def.fixture.restitution = 1.0;
			b2Def.fixture.isSensor = false;
			b2Def.fixture.userData = this;
			
			_collectableBody = PhysicsWorld.CreateBody(b2Def.body);
			var fixture:b2Fixture = b2Def.fixture.create(_collectableBody);
			fixture.m_reportBeginContact = true;
			fixture.m_reportEndContact = true;
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
			return _animationController.currFrame.width;
		}//end get width()
		
		override public function get height():Number 
		{
			return _animationController.currFrame.height;
		}//end get height()
		
		public function get currFrame():BitmapData
		{
			return _animationController.currFrame;
		}//end get currFrame()
		
		public function get actionName():String
		{
			return "";
		}//end get actionName()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animationController.update(t);
			
			var pos:V2 = _collectableBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale - width / 2;
			this.y = pos.y * PhysicsWorld.PhysScale - height / 2;
			
			_collectableBody.ApplyForce(new V2(0, 10 * _collectableBody.GetMass()), _collectableBody.GetWorldCenter());
		}//end update()
		
		public function destroy():void 
		{			
			cleanupPhysics();
		}//end destroy()
		
	}//end Collectable

}//end package