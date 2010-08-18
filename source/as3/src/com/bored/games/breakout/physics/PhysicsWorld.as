package com.bored.games.breakout.physics 
{
	import Box2DAS.Collision.b2AABB;
	import Box2DAS.Common.b2Base;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.b2Settings;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2ContactListener;
	import Box2DAS.Dynamics.b2DebugDraw;
	import Box2DAS.Dynamics.b2World;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Collision.Shapes.b2Shape;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.Joints.b2Joint;
	import Box2DAS.Dynamics.Joints.b2JointDef;
	import com.bored.games.objects.GameElement;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author sam
	 */
	public class PhysicsWorld
	{
		private static var _world:b2World;
		private static var _debugDraw:b2DebugDraw;
		private static var _doSleep:Boolean = false;
		
		private static var _lastUpdate:Number = 0;		
		private static var _timeStep:Number = 1.0 / 40.0;
		private static var _velIterations:int = 3;// 20;
		private static var _posIterations:int = 8;// 20;
		
		private static var _physScale:Number = 30;
		
		public static function InitializePhysics():void
		{
			b2Base.initialize();
			b2Def.initialize();
			_world = new b2World( new V2(0, 0), _doSleep );
			_world.SetWarmStarting(true);
			_world.SetAutoClearForces(true);
			_world.SetContinuousPhysics(true);
		}//end InitializePhysics()
		
		public static function SetContactListener(a_listener:b2ContactListener):void
		{
			_world.SetContactListener(a_listener);
		}//end SetContactListener()
		
		public static function SetDebugDraw(a_sprite:Sprite):void
		{
			_debugDraw = new b2DebugDraw();
			a_sprite.addChild(_debugDraw);
			_debugDraw.scale = _physScale;
			_debugDraw.world = _world;
		}//end SetDebugDraw()
		
		public static function get PhysScale():Number
		{
			return _physScale;
		}//end get PhysScale()
		
		public static function CreateBody( a_def:b2BodyDef ):b2Body
		{
			return a_def.create(_world);
		}//end CreateBody()
		
		public static function CreateJoint( a_def:b2JointDef ):b2Joint
		{
			return a_def.create(_world);
		}//end CreateJoint()
		
		public static function GetGroundBody():b2Body
		{
			return _world.m_groundBody;
		}//end GetGroundBody()
		
		public static function UpdateWorld(t:Number = 0):void
		{
			if ( _world )
			{				
				_world.Step(t / 1000, _velIterations, _posIterations);
				
				//_debugDraw.Draw();
				
				var time:int = getTimer();
				var bb:b2Body = _world.GetBodyList();
				
				while ( bb != null )
				{
					if ( bb.GetUserData() != null )
					{						
						bb.GetUserData().update(t);
					}
					
					bb = bb.GetNext();
				}
			}
		}//end UpdateWorld()
		
		public static function DestroyBody( a_body:b2Body ):void
		{
			_world.DestroyBody(a_body);						
		}//end CleanupBody()
		
		public static function DestroyJoint( a_joint:b2Joint ):void
		{
			_world.DestroyJoint(a_joint);
		}//end DestroyJoint()
		
		public static function IsLocked():Boolean
		{
			return _world.IsLocked();
		}//end IsLocked()
		
	}//end PhysicsWorld

}//end package