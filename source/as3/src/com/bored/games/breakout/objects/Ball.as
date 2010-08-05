package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.DestructoballAction;
	import com.bored.games.breakout.actions.InvinciballAction;
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
	public class Ball extends GameElement
	{
		public static const NORMAL_BALL:String = "Normal";
		public static const SUPER_BALL:String = "Super";
		public static const DESTRUCT_BALL:String = "Destruct";
		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Ball_MC')]
		private static var mcCls:Class;
		
		private var _ballBody:b2Body;
		
		private var _speed:Number;
		private var _minSpeed:Number;
		private var _maxSpeed:Number;
		
		private var _ballMode:String;
		
		private var _currentEffectAction:String;
		
		private var _sleeping:Boolean;
		
		private var _animatedSprite:AnimatedSprite;
		private var _animationSet:AnimationSet;
		
		private var _damagePoints:int;
		
		public function Ball()
		{	
			_ballMode = NORMAL_BALL;
			
			_animationSet = AnimationSetFactory.generateAnimationSet(new mcCls());
			
			_animatedSprite = _animationSet.getAnimation(NORMAL_BALL);
			//_animatedSprite = _animationSet.getAnimation(DESTRUCT_BALL);
		
			_speed = AppSettings.instance.defaultInitialBallSpeed;
			_minSpeed = AppSettings.instance.defaultMinBallSpeed;
			_maxSpeed = AppSettings.instance.defaultMaxBallSpeed;
			
			initializePhysicsBody();
			initializeActions();
			
			_damagePoints = 1;

		}//end constructor()
		
		public function set damagePoints(a_dmg:int):void
		{
			_damagePoints = a_dmg;
		}//end set damagePoints()
		
		public function get damagePoints():int
		{
			return _damagePoints;
		}//end get damagePoints()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.bullet = true;
			bd.allowSleep = false;
			bd.userData = this;

			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Ball;
			filter.maskBits = GameView.id_Brick | GameView.id_Paddle | GameView.id_Wall | GameView.id_Ball | GameView.id_Collectable;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = new b2CircleShape( (_animatedSprite.width / 2) / PhysicsWorld.PhysScale );
			fd.filter = filter;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			
			_ballBody = PhysicsWorld.CreateBody(bd);
			_ballBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		private function cleanupPhysics():void
		{
			PhysicsWorld.DestroyBody(_ballBody);
		}//end cleanupPhysics()
		
		private function initializeActions():void
		{
			addAction( new DestructoballAction(this, {"time":AppSettings.instance.defaultDestructoballTimer} ) );
			addAction( new InvinciballAction(this, {"time":AppSettings.instance.defaultInvinciballTimer}) );
		}//end initializeAction
		
		public function get physicsBody():b2Body
		{
			return _ballBody;
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
		
		public function changeSpeed(a_per:Number):void
		{
			var newSpeed:Number;
			
			if (a_per < 0) a_per = 0;
			if (a_per > 1) a_per = 1;
			
			newSpeed = (_maxSpeed - _minSpeed) * a_per + _minSpeed;
			
			if ( newSpeed < _minSpeed ) newSpeed = _minSpeed;
			if ( newSpeed > _maxSpeed ) newSpeed = _maxSpeed;
			
			_speed = newSpeed;
		}//end changeSpeed()
		
		public function increaseSpeed(a_per:Number):void
		{
			var newSpeed:Number;
			
			if (a_per < 0) a_per = 0;
			if (a_per > 1) a_per = 1;
			
			newSpeed += (_maxSpeed - _minSpeed) * a_per + _minSpeed;
			
			if ( newSpeed < _minSpeed ) newSpeed = _minSpeed;
			if ( newSpeed > _maxSpeed ) newSpeed = _maxSpeed;
			
			_speed = newSpeed;
		}//end changeSpeed()
		
		public function decreaseSpeed(a_per:Number):void
		{
			var newSpeed:Number;
			
			if (a_per < 0) a_per = 0;
			if (a_per > 1) a_per = 1;
			
			newSpeed -= (_maxSpeed - _minSpeed) * a_per + _minSpeed;
			
			if ( newSpeed < _minSpeed ) newSpeed = _minSpeed;
			if ( newSpeed > _maxSpeed ) newSpeed = _maxSpeed;
			
			_speed = newSpeed;
		}//end changeSpeed()
		
		public function get speed():Number
		{
			return _speed;
		}//end get speed()
		
		public function set sleeping(a_sleep:Boolean):void
		{
			_sleeping = a_sleep;
			
			if ( _sleeping )
			{
				_ballBody.SetLinearDamping(Number.POSITIVE_INFINITY);
			}
			else
			{
				_ballBody.SetLinearDamping(0.0);
			}
		}//end set sleeping()
		
		public function get sleeping():Boolean
		{
			return _sleeping;
		}//end get sleeping()
		
		public function set ballMode(a_str:String):void
		{
			_ballMode = a_str;
		}//end get ballMode()
		
		public function get ballMode():String
		{
			return _ballMode;
		}//end get ballMode()
		
		public function switchAnimation(a_str:String):void
		{
			_animatedSprite = _animationSet.getAnimation(a_str);
		}//end switchAnimation()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			_animatedSprite.update(t);
						
			var pos:b2Vec2 = _ballBody.GetPosition();
			
			this.x = (pos.x * PhysicsWorld.PhysScale - width / 2);
			this.y = (pos.y * PhysicsWorld.PhysScale - height / 2);
			
			if (_sleeping) return;
			
			var bodyVelocity:b2Vec2 = _ballBody.GetLinearVelocity();
			var limitVelocity:b2Vec2 = bodyVelocity.Copy();
			limitVelocity.Normalize();
			limitVelocity.Multiply(_speed);
			_ballBody.SetLinearVelocity(limitVelocity);
			
			bodyVelocity = _ballBody.GetLinearVelocity();
			
			if (Math.abs(bodyVelocity.x) <= AppSettings.instance.ballTrajectoryThreshold)
			{
				_ballBody.ApplyForce(new b2Vec2(AppSettings.instance.ballTrajectoryAdjustFactor * _ballBody.GetMass(), 0), _ballBody.GetWorldCenter());
			}
			
			if (Math.abs(bodyVelocity.y) <= AppSettings.instance.ballTrajectoryThreshold)
			{
				_ballBody.ApplyForce(new b2Vec2(0, AppSettings.instance.ballTrajectoryAdjustFactor * _ballBody.GetMass()), _ballBody.GetWorldCenter());
			}
		
		}//end update()
		
		public function destroy():void 
		{			
			cleanupPhysics();
			
			if ( _ballMode == DESTRUCT_BALL )
			{
				this.deactivateAction(InvinciballAction.NAME);
			}
		}//end destroy()
		
	}//end Ball

}//end package