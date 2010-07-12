package com.bored.games.breakout.objects 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
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
		
		private var _paddleJoint:b2PrismaticJoint;
		
		private var _stickyMode:Boolean;
			
		public function Paddle() 
		{
			super();
			
			_animationSet = AnimationSetFactory.generateAnimationSet(new mcCls());
			
			_animatedSprite = _animationSet.getAnimation(PADDLE_NORMAL);
			
			_normalHeight = _animatedSprite.height;
			
			initializePhysicsBody();
			initializeActions();
			
			_stickyMode = false;
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
			addAction( new CatchPaddleAction(this, { "time": 10000 } ) ) ;
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
		
		public function catchBall(a_ball:Ball):void
		{
			var worldAxis:b2Vec2 = new b2Vec2(1.0, 0.0);
			
			a_ball.sleeping = true;
			
			var pos:b2Vec2 = _paddleBody.GetWorldCenter();
			pos.y -= a_ball.height / PhysicsWorld.PhysScale;
			a_ball.physicsBody.SetPosition( pos );
			
			var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			jointDef.Initialize(
				a_ball.physicsBody, 
				_paddleBody, 
				a_ball.physicsBody.GetWorldCenter(),
				worldAxis);
				
			jointDef.lowerTranslation = -(this.width / 2) / PhysicsWorld.PhysScale;
			jointDef.upperTranslation = (this.width / 2) / PhysicsWorld.PhysScale;
			jointDef.enableLimit = true;
			
			_paddleJoint = PhysicsWorld.CreateJoint(jointDef) as b2PrismaticJoint;
		}//end catchBall()
		
		public function releaseBall():void
		{
			if (_paddleJoint)
			{				
				var ball:b2Vec2 = _paddleJoint.GetBodyA().GetPosition();
				var paddle:b2Vec2 = _paddleJoint.GetBodyB().GetPosition();
				
				var ballXDiff:Number = ball.x - paddle.x;
				
				var rect:b2AABB = new b2AABB();
				_paddleJoint.GetBodyA().GetFixtureList().GetShape().ComputeAABB(rect, new b2Transform());
				
				var ballXRatio:Number = ballXDiff / (rect.GetExtents().x * 2);
				
				if (ballXRatio < -0.95) ballXRatio = -0.95;
				if (ballXRatio > 0.95) ballXRatio = 0.95;
				
				var b:Ball = _paddleJoint.GetBodyA().GetUserData() as Ball;
				
				var vel:b2Vec2 = new b2Vec2();
				vel.x = ballXRatio * AppSettings.instance.paddleReflectionMultiplier;
				vel.y = -Math.sqrt((b.speed * b.speed) - (vel.x * vel.x));
				
				PhysicsWorld.DestroyJoint(_paddleJoint);
				_paddleJoint = null;
				
				b.sleeping = false;
				b.physicsBody.SetLinearVelocity(vel);	
			}
		}//end releaseBall()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animatedSprite.update(t);
			
			var pos:b2Vec2 = _paddleBody.GetPosition();
			
			this.x = (pos.x * PhysicsWorld.PhysScale - width / 2);
			this.y = ((pos.y * PhysicsWorld.PhysScale + _normalHeight / 2) - height);
		}//end update()
		
		public function get occupied():Boolean
		{
			return (_paddleJoint != null);
		}//end get occupied()
		
		public function set stickyMode(a_mode:Boolean):void
		{
			_stickyMode = a_mode;
		}//end set stickyMode()
		
		public function get stickyMode():Boolean
		{
			return _stickyMode;
		}//end get stickyMode()
		
	}//end Paddle

}//end package