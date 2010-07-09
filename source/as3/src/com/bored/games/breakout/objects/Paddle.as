package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Paddle extends GameElement
	{
		public static const PADDLE_NORMAL:String = "Normal";
		public static const PADDLE_LASER:String = "Laser";
		public static const PADDLE_CATCH:String = "Catch";
		public static const PADDLE_EXTEND:String = "Extend";
		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Paddle_MC')]
		private static var mcCls:Class;
		
		private var _animationSet:AnimationSet;
		private var _animatedSprite:AnimatedSprite;
		
		private var _normalHeight:Number;
		
		private var _paddleBody:b2Body;
		
		private var _currentEffectAction:String;
		
		public function Paddle() 
		{
			super();
			
			_animationSet = AnimationSetFactory.generateAnimationSet(new mcCls());
			
			_animatedSprite = _animationSet.getAnimation(PADDLE_NORMAL);
			
			_normalHeight = _animatedSprite.height;
			
			initializePhysicsBody();
			initializeActions();			
		}//end constructor()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.allowSleep = false;
			bd.userData = this;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox( (_animatedSprite.currFrame.width / 2) / PhysicsWorld.PhysScale, (_animatedSprite.currFrame.height / 2) / PhysicsWorld.PhysScale );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			
			_paddleBody = PhysicsWorld.CreateBody(bd);
			_paddleBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		private function initializeActions():void
		{
			addAction( new LaserPaddleAction(this, { "time": 10000, "fireRate": 250 } ) ) ;
			addAction( new ExtendPaddleAction(this, { "time": 10000 } ) ) ;
		}//end intializeActions()
		
		public function updateBody():void
		{
			var fixture:b2Fixture = _paddleBody.GetFixtureList();
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox( (_animatedSprite.currFrame.width / 2) / PhysicsWorld.PhysScale, (_animatedSprite.currFrame.height / 2) / PhysicsWorld.PhysScale );
			
			fixture.GetShape().Set(shape);
		}//end updateBody()
		
		public function get physicsBody():b2Body
		{
			return _paddleBody;
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

		public function activatePowerup(str:String):void
		{
			deactivateAction(_currentEffectAction);
			
			if ( checkForActionNamed(str) )
			{
				activateAction(str);
				_currentEffectAction = str;
			}
		}//end activatePowerup()
		
		public function switchAnimation(a_str:String):void
		{
			_animatedSprite = _animationSet.getAnimation(a_str);
		}//end switchAnimation()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animatedSprite.update();
			
			var pos:b2Vec2 = _paddleBody.GetPosition();
			
			this.x = (pos.x * PhysicsWorld.PhysScale - width / 2);
			this.y = ((pos.y * PhysicsWorld.PhysScale + _normalHeight / 2) - height);
		}//end update()
		
	}//end Paddle

}//end package