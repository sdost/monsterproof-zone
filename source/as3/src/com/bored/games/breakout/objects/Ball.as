package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Ball extends GameElement
	{
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Ball_BMP')]
		private static var imgCls:Class;
		
		private static var _ballBmp:Bitmap = new imgCls();
		
		private var _ballBody:b2Body;
		
		private var _speed:Number;
		private var _minSpeed:Number;
		private var _maxSpeed:Number;
		
		public function Ball()
		{			
			_speed = AppSettings.instance.defaultInitialBallSpeed;
			_minSpeed = AppSettings.instance.defaultMinBallSpeed;
			_maxSpeed = AppSettings.instance.defaultMaxBallSpeed;
			
			initializePhysicsBody();
			initializeActions();
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
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			var pos:b2Vec2 = _ballBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
			
			var bodyVelocity:b2Vec2 =_ballBody.GetLinearVelocity();
			var limitVelocity:b2Vec2 = bodyVelocity.Copy();
			limitVelocity.Normalize();
			limitVelocity.Multiply(_speed);
			_ballBody.SetLinearVelocity(limitVelocity);
		}//end update()
		
	}//end Ball

}//end package