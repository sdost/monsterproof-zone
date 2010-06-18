package com.bored.games.breakout.states.views 
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2LineJoint;
	import Box2D.Dynamics.Joints.b2LineJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.input.Input;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameView extends StateView
	{
		private var _grid:Grid;
		private var _ball:Ball;
		private var _paddle:Paddle;
		
		private var _gameScreen:Bitmap;
		
		private var _levelLoader:Loader;
		
		private var _ready:Boolean = false;
		
		private var _mouseXWorldPhys:Number;
		private var _mouseYWorldPhys:Number;
		
		private var _mouseXWorld:Number;
		private var _mouseYWorld:Number;
		
		private var _mouseJoint:b2MouseJoint;
		private var _lineJoint:b2LineJoint;
		
		public function GameView() 
		{
			super();
				
			PhysicsWorld.InitializePhysics();
			PhysicsWorld.SetDebugDraw(this);
			PhysicsWorld.SetContactListener(new GameContactListener());
			
			_gameScreen = new Bitmap();
			addChild( _gameScreen );
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			_gameScreen.bitmapData = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			
			_grid = new Grid( AppSettings.instance.defaultGridWidth, AppSettings.instance.defaultGridHeight );
			_ball = new Ball();
			_paddle = new Paddle();
			
			_ready = true;
		}//end addedToStageHandler()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		override public function reset():void
		{
		}//end reset()
		
		override public function enter():void
		{			
			var wall:b2PolygonShape = new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			wallBd.position.Set( -30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale);
			wall.SetAsBox( 30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set( 336 / PhysicsWorld.PhysScale, -30 / PhysicsWorld.PhysScale);
			wall.SetAsBox(336 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set(704 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale);
			wall.SetAsBox( 30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set(336 / PhysicsWorld.PhysScale, 574 / PhysicsWorld.PhysScale);
			wall.SetAsBox(336 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			_ball.physicsBody.SetPosition( new b2Vec2( 336 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale ) );
			
			_paddle.physicsBody.SetPosition( new b2Vec2( 336 / PhysicsWorld.PhysScale, 408 / PhysicsWorld.PhysScale ) );
			
			var md:b2MouseJointDef = new b2MouseJointDef();
			md.bodyA = PhysicsWorld.GetGroundBody();
			md.bodyB = _paddle.physicsBody;
			md.target.Set(336 / PhysicsWorld.PhysScale, 408 / PhysicsWorld.PhysScale);
			md.collideConnected = true;
			md.maxForce = 300.0 * _paddle.physicsBody.GetMass();
			_mouseJoint = PhysicsWorld.CreateJoint(md) as b2MouseJoint;
			_paddle.physicsBody.SetAwake(true);
			
			var ljd:b2LineJointDef = new b2LineJointDef();
			ljd.Initialize( PhysicsWorld.GetGroundBody(), _paddle.physicsBody, _paddle.physicsBody.GetPosition(), new b2Vec2( 1, 0 ) );
			
			ljd.lowerTranslation = -272 / PhysicsWorld.PhysScale;
			ljd.upperTranslation = 272 / PhysicsWorld.PhysScale;
			ljd.enableLimit = true;
			
			_lineJoint = PhysicsWorld.CreateJoint(ljd) as b2LineJoint;
			
			_levelLoader = new Loader();
			_levelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_levelLoader.load( new URLRequest("../assets/TestLevel.swf") );
			
			enterComplete();
		}//end enter()
		
		private function onComplete(e:Event):void
		{
			var parent:DisplayObjectContainer = _levelLoader.content as DisplayObjectContainer;
			
			for ( var i:int = 0; i < parent.numChildren; i++ )
			{
				var obj:DisplayObject = parent.getChildAt(i);
				
				if( getQualifiedClassName(obj) == "brick" )
					_grid.addGridObject( new Brick( uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5), uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5) ), uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5) );
			}
			
			var impulse:b2Vec2 = new b2Vec2(Math.random() * 20 - 10, Math.random() * 20 - 10);
			_ball.physicsBody.ApplyImpulse(impulse, _ball.physicsBody.GetWorldCenter());
		}//end onComplete()
		
		override public function exit():void
		{
			_grid = null;
			_ball = null;
			_paddle = null;
			
			exitComplete();
		}//end exit()
		
		override public function update():void
		{
			if ( !_ready ) return;
			
			UpdateMouseWorld();
			
			_mouseJoint.SetTarget(new b2Vec2(_mouseXWorldPhys, _mouseYWorldPhys));
			
			PhysicsWorld.UpdateWorld();
			
			_grid.update();
			_ball.update();
			//_paddle.update();
			
			var go:GridObject;
			
			_gameScreen.bitmapData.fillRect( _gameScreen.bitmapData.rect, 0x00000000);
			for ( var i:int = 0; i < _grid.gridWidth; i++ )
			{
				for ( var j:int = 0; j < _grid.gridHeight; j++ )
				{
					go = _grid.getGridObjectAt(i, j);
					if (go) 
					{
						var bmd:BitmapData = (go as Brick).tileSet.loadTile( Math.floor(Math.random() * 1000) );
						_gameScreen.bitmapData.copyPixels( bmd, bmd.rect, new Point(i * AppSettings.instance.defaultTileWidth, j * AppSettings.instance.defaultTileHeight), null, null, true );
					}
				}
			}
				
			_gameScreen.bitmapData.copyPixels( _ball.bitmap.bitmapData, _ball.bitmap.bitmapData.rect, new Point( _ball.x - _ball.width / 2, _ball.y - _ball.height / 2 ), null, null, true );		
		}//end update()
		
		private function UpdateMouseWorld():void
		{
			_mouseXWorldPhys = (Input.mouseX) / PhysicsWorld.PhysScale;
			_mouseYWorldPhys = (Input.mouseY) / PhysicsWorld.PhysScale;
			
			_mouseXWorld = (Input.mouseX);
			_mouseXWorld = (Input.mouseY);
		}//end UpdateMouseWorld()
	
	}//end GameView

}//end package

import Box2D.Collision.b2Manifold;
import Box2D.Dynamics.b2ContactImpulse;
import Box2D.Dynamics.b2ContactListener;
import Box2D.Dynamics.b2Fixture;
import Box2D.Dynamics.Contacts.b2Contact;
import com.bored.games.breakout.objects.bricks.Brick;

class GameContactListener extends b2ContactListener
{
	override public function BeginContact(contact:b2Contact):void
	{
		// TODO: Nothing?
	}//end BeginContact()
	
	override public function EndContact(contact:b2Contact):void
	{
		var f:b2Fixture = contact.GetFixtureA();
		var data:* = f.GetUserData();
		if ( data && data is Brick )
		{
			data.notifyHit();
		}
	}//end EndContact()
	
	override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
	{
		// TODO: Nothing?
	}//end BeginContact()
	
	override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
	{
		// TODO: Nothing?
	}//end BeginContact()
	
}//end GameContactListener