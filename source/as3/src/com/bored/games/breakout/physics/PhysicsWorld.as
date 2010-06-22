package com.bored.games.breakout.physics 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author sam
	 */
	public class PhysicsWorld
	{
		private static var _world:b2World;
		private static var _doSleep:Boolean = true;
		
		private static var _timeStep:Number = 1.0 / 60.0;
		private static var _velIterations:int = 20;
		private static var _posIterations:int = 20;
		
		private static var _physScale:Number = 30;
		
		public static function InitializePhysics():void
		{
			_world = new b2World( new b2Vec2(0, 0), _doSleep );
			_world.SetWarmStarting(true);
		}//end InitializePhysics()
		
		public static function SetContactListener(a_listener:b2ContactListener):void
		{
			_world.SetContactListener(a_listener);
		}//end SetContactListener()
		
		public static function SetDebugDraw(a_sprite:Sprite):void
		{
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(a_sprite);
			dbgDraw.SetDrawScale(_physScale);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(dbgDraw);
		}//end SetDebugDraw()
		
		public static function get PhysScale():Number
		{
			return _physScale;
		}//end get PhysScale()
		
		public static function CreateBody( a_def:b2BodyDef ):b2Body
		{
			return _world.CreateBody(a_def);
		}//end CreateBody()
		
		public static function CreateJoint( a_def:b2JointDef ):b2Joint
		{
			return _world.CreateJoint(a_def);
		}//end CreateJoint()
		
		public static function GetGroundBody():b2Body
		{
			return _world.GetGroundBody();
		}//end GetGroundBody()
		
		public static function UpdateWorld():void
		{
			if ( _world )
			{
				_world.Step(_timeStep, _velIterations, _posIterations);
				_world.ClearForces();
				
				_world.DrawDebugData();
			}
		}//end UpdateWorld()
		
		public static function DestroyBody( a_body:b2Body ):void
		{
			_world.DestroyBody(a_body);				
		}//end CleanupBody()
		
		public static function IsLocked():Boolean
		{
			return _world.IsLocked();
		}//end IsLocked()
		
	}//end PhysicsWorld

}//end package