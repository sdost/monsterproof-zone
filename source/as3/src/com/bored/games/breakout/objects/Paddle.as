package com.bored.games.breakout.objects 
{
	import Box2DAS.Collision.AABB;
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.XF;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2Filter;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import Box2DAS.Dynamics.Joints.b2LineJoint;
	import Box2DAS.Dynamics.Joints.b2PrismaticJoint;
	import Box2DAS.Dynamics.Joints.b2PrismaticJointDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.actions.ExtendPaddleAction;
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.actions.SuperLaserPaddleAction;
	import com.sven.animation.AnimatedSprite;
	import com.sven.animation.AnimationController;
	import com.sven.animation.AnimationSet;
	import com.sven.factories.AnimationSetFactory;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Paddle extends GameElement
	{
		// Paddle States
		public static const PADDLE_NORMAL:String = "Normal";
		public static const PADDLE_LASER:String = "Laser";
		public static const PADDLE_CATCH:String = "Catch";		
		public static const PADDLE_EXTEND:String = "Extend";
		
		// Paddle Transitions
		public static const PADDLE_INTRO:String = "Intro";
		public static const PADDLE_OUTRO:String = "Outro";
		public static const PADDLE_EXTEND_IN:String = "ExtendIn";
		public static const PADDLE_EXTEND_OUT:String = "ExtendOut";
		public static const PADDLE_LASER_IN:String = "LaserIn";
		public static const PADDLE_LASER_OUT:String = "LaserOut";
		public static const PADDLE_CATCH_IN:String = "CatchIn";
		public static const PADDLE_CATCH_OUT:String = "CatchOut";
		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Paddle_MC')]
		private static var mcCls:Class;
		
		private var _animationSet:AnimationSet;
		private var _animatedSprite:AnimatedSprite;
		private var _animationController:AnimationController;
		
		private var _normalHeight:Number;
		
		private var _paddleBody:b2Body;
		
		private var _currentEffectAction:String;
		
		private var _paddleJoint:b2LineJoint;
		
		private var _stickyMode:Boolean;
			
		public function Paddle() 
		{
			super();
			
			_animationSet = AnimationSetFactory.generateAnimationSet(new mcCls());
			
			_animatedSprite = _animationSet.getAnimation(PADDLE_NORMAL);
			
			_animationController = new AnimationController(_animatedSprite, true);
			
			_normalHeight = _animatedSprite.height;
			
			initializePhysics();
			initializeActions();
			
			_stickyMode = false;
		}//end constructor()
		
		public function initializePhysics():void
		{
			if ( !PhysicsWorld.Exists() ) return;
			
			b2Def.body.type = b2Body.b2_dynamicBody;
			b2Def.body.fixedRotation = true;
			b2Def.body.allowSleep = false;
			b2Def.body.userData = this;
			b2Def.body.linearDamping = 0.0;
			
			b2Def.polygon.SetAsBox( (_animatedSprite.currFrame.width / 2) / PhysicsWorld.PhysScale, (_animatedSprite.currFrame.height / 2) / PhysicsWorld.PhysScale );
			
			/*
			var filter:b2Filter = new b2Filter();
			filter.categoryBits = GameView.id_Paddle;
			filter.maskBits = GameView.id_Collectable | GameView.id_Ball;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Paddle;
			b2Def.fixture.filter.maskBits = GameView.id_Collectable | GameView.id_Ball;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.friction = 0.0;
			b2Def.fixture.restitution = 0.0;			
			b2Def.fixture.userData = this;
			b2Def.fixture.isSensor = false;
			
			_paddleBody = PhysicsWorld.CreateBody(b2Def.body);
			b2Def.fixture.create(_paddleBody);
		}//end initializePhysicsBody()
		
		private function initializeActions():void
		{
			addAction( new LaserPaddleAction(this, { "time": AppSettings.instance.defaultLaserTimer, "fireRate": AppSettings.instance.defaultLaserFireRate } ) ) ;
			addAction( new ExtendPaddleAction(this, { "time": AppSettings.instance.defaultExtendTimer } ) ) ;
			addAction( new CatchPaddleAction(this, { "time": AppSettings.instance.defaultCatchTimer } ) ) ;
			addAction( new SuperLaserPaddleAction(this) );
		}//end intializeActions()
		
		public function updateBody():void
		{
			var fixture:b2Fixture = _paddleBody.GetFixtureList();
			(fixture.m_shape as b2PolygonShape).SetAsBox( (_animatedSprite.currFrame.width / 2) / PhysicsWorld.PhysScale, (_normalHeight / 2) / PhysicsWorld.PhysScale );
		}//end updateBody()
		
		public function get physicsBody():b2Body
		{
			return _paddleBody;
		}//end get physicsBody()
		
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
			
			_animatedSprite.visible = value;
		}//end set visible()
		
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

		public function activatePowerup(str:String):void
		{
			if(_currentEffectAction) deactivateAction(_currentEffectAction);
			
			if ( checkForActionNamed(str) )
			{
				activateAction(str);
				_currentEffectAction = str;
			}
		}//end activatePowerup()
		
		public function switchAnimation(a_str:String):void
		{
			_animatedSprite = _animationSet.getAnimation(a_str);
				
			if (a_str == PADDLE_INTRO)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, introComplete, false, 0, true);
			}
			else if (a_str == PADDLE_OUTRO)
			{
				_animationController.setAnimation(_animatedSprite, false);
			}
			else if (a_str == PADDLE_EXTEND_IN)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, extendInComplete, false, 0, true);
			}
			else if (a_str == PADDLE_EXTEND_OUT)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, extendOutComplete, false, 0, true);
			}
			else if (a_str == PADDLE_LASER_IN)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, laserInComplete, false, 0, true);
			}
			else if (a_str == PADDLE_LASER_OUT)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, laserOutComplete, false, 0, true);
			}
			else if (a_str == PADDLE_CATCH_IN)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, catchInComplete, false, 0, true);
			}
			else if (a_str == PADDLE_CATCH_OUT)
			{
				_animationController.setAnimation(_animatedSprite, false);
				_animationController.addEventListener(AnimationController.ANIMATION_COMPLETE, catchOutComplete, false, 0, true);
			}
			else
			{
				_animationController.setAnimation(_animatedSprite, true);
			}
			
			updateBody();
			
		}//end switchAnimation()
		
		private function introComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, introComplete);
			switchAnimation(PADDLE_NORMAL);
		}//end introComplete()
		
		private function extendInComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, extendInComplete);
			switchAnimation(PADDLE_EXTEND);
		}//end extendInComplete()
		
		private function extendOutComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, extendOutComplete);
			switchAnimation(PADDLE_NORMAL);
		}//end extendOutComplete()
		
		private function laserInComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, laserInComplete);
			switchAnimation(PADDLE_LASER);
		}//end extendInComplete()
		
		private function laserOutComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, laserOutComplete);
			switchAnimation(PADDLE_NORMAL);
		}//end extendOutComplete()
		
		private function catchInComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, catchInComplete);
			switchAnimation(PADDLE_CATCH);
		}//end extendInComplete()
		
		private function catchOutComplete(e:Event):void
		{
			_animationController.removeEventListener(AnimationController.ANIMATION_COMPLETE, catchOutComplete);
			switchAnimation(PADDLE_NORMAL);
		}//end extendOutComplete()
		
		public function catchBall(a_ball:Ball):void
		{
			var worldAxis:V2 = new V2(1.0, 0.0);
			
			a_ball.sleeping = true;
			
			var pos:V2 = _paddleBody.GetWorldCenter();
			pos.y -= a_ball.height / PhysicsWorld.PhysScale;
			a_ball.physicsBody.SetTransform( pos, 0 );
			
			b2Def.lineJoint.enableLimit = true;
			b2Def.lineJoint.lowerTranslation = -(this.width / 2) / PhysicsWorld.PhysScale;
			b2Def.lineJoint.upperTranslation = (this.width / 2) / PhysicsWorld.PhysScale;
			
			b2Def.lineJoint.Initialize( 
				_paddleBody,
				a_ball.physicsBody,
				a_ball.physicsBody.GetWorldCenter(),
				worldAxis);
				
			_paddleJoint = PhysicsWorld.CreateJoint(b2Def.lineJoint) as b2LineJoint;		
		}//end catchBall()
		
		public function releaseBall():void
		{
			if (_paddleJoint)
			{	
				var ball:V2 = _paddleJoint.GetBodyB().GetPosition();
				var paddle:V2 = _paddleJoint.GetBodyA().GetPosition();
				
				var ballXDiff:Number = ball.x - paddle.x;
				
				var extent:Number = (this.width / 2) / PhysicsWorld.PhysScale;
				
				/*
				var rect:AABB = new AABB();
				_paddleJoint.GetBodyB().GetFixtureList().m_shape.ComputeAABB(rect, new XF());
				*/
			
				var ballXRatio:Number = ballXDiff / (extent * 2);
				
				if (isNaN(ballXRatio)) ballXRatio = 0;
				if (ballXRatio < -0.95) ballXRatio = -0.95;
				if (ballXRatio > 0.95) ballXRatio = 0.95;
				
				var b:Ball = _paddleJoint.GetBodyB().GetUserData() as Ball;
				
				var vel:V2 = new V2();
				vel.x = ballXRatio * AppSettings.instance.paddleReflectionMultiplier;
				vel.y = -Math.sqrt(Math.abs((b.speed * b.speed) - (vel.x * vel.x)));
				
				PhysicsWorld.DestroyJoint(_paddleJoint);
				_paddleJoint = null;
				
				b.sleeping = false;
				b.physicsBody.SetLinearVelocity(vel);	
			}
		}//end releaseBall()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animationController.update(t);
			
			var pos:V2 = _paddleBody.GetPosition();
			
			this.x = int(pos.x * PhysicsWorld.PhysScale - width / 2);
			this.y = int((pos.y * PhysicsWorld.PhysScale + _normalHeight / 2) - height);
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