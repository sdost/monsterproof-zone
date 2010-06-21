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
	import com.bored.games.breakout.factories.BrickSpriteFactory;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.BrickSprite;
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
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	
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
		private var _brickSprites:Dictionary;
		private var _brickSpritesVector:Vector.<BrickSprite>;
		
		private var _spriteLoader:Loader;
		private var _spriteExplorer:SWFExplorer;
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
			//PhysicsWorld.SetDebugDraw(this);
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
			
			_spriteLoader = new Loader();
			_spriteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spritesLoaded, false, 0, true);
			_spriteLoader.load( new URLRequest("../assets/BrickSpriteLibrary.swf") );
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
			_paddle.physicsBody.SetPosition( new b2Vec2( 336 / PhysicsWorld.PhysScale, 500 / PhysicsWorld.PhysScale ) );
			
			var md:b2MouseJointDef = new b2MouseJointDef();
			md.bodyA = PhysicsWorld.GetGroundBody();
			md.bodyB = _paddle.physicsBody;
			md.target.Set(336 / PhysicsWorld.PhysScale, 500 / PhysicsWorld.PhysScale);
			md.maxForce = 10000.0 * _paddle.physicsBody.GetMass();
			md.dampingRatio = 0;
			md.frequencyHz = 100;
			_mouseJoint = PhysicsWorld.CreateJoint(md) as b2MouseJoint;
			
			var ljd:b2LineJointDef = new b2LineJointDef();
			ljd.Initialize( PhysicsWorld.GetGroundBody(), _paddle.physicsBody, _paddle.physicsBody.GetPosition(), new b2Vec2( 1.0, 0.0 ) );
			
			ljd.lowerTranslation = -(330 - _paddle.width/2) / PhysicsWorld.PhysScale;
			ljd.upperTranslation = (330 - _paddle.width/2) / PhysicsWorld.PhysScale;
			ljd.enableLimit = true;
			
			_lineJoint = PhysicsWorld.CreateJoint(ljd) as b2LineJoint;
			
			enterComplete();
		}//end enter()
		
		private function spritesLoaded(e:Event):void
		{
			_spriteExplorer = new SWFExplorer();
			_spriteExplorer.addEventListener(SWFExplorerEvent.COMPLETE, spriteAssetsParsed, false, 0, true);
			_spriteExplorer.parse(_spriteLoader.contentLoaderInfo.bytes);
		}//end spritesLoaded()
		
		private function spriteAssetsParsed(e:SWFExplorerEvent):void
		{
			_brickSpritesVector = new Vector.<BrickSprite>(e.definitions.length, true);
			_brickSprites = new Dictionary(true);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _spriteLoader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				var bs:BrickSprite = BrickSpriteFactory.generateBrickSprite(new cls() as MovieClip);
				
				_brickSpritesVector[i] = bs;
				_brickSprites[e.definitions[i]] = bs;
			}
			
			_levelLoader = new Loader();
			_levelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, levelLoaded, false, 0, true);
			_levelLoader.load( new URLRequest("../assets/TestLevel.swf") );
		}//end spriteAssetsParsed()
		
		private function levelLoaded(e:Event):void
		{
			var parent:DisplayObjectContainer = _levelLoader.content as DisplayObjectContainer;
			
			for ( var i:int = 0; i < parent.numChildren; i++ )
			{
				var obj:DisplayObject = parent.getChildAt(i);
				
				_grid.addGridObject( 
					new Brick( 
						uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
						uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
						_brickSprites[getQualifiedClassName(obj)]), 
					uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5),
					uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5) );
			}
			
			var impulse:b2Vec2 = new b2Vec2(Math.random() * 20 - 10, Math.random() * 20 - 10);
			_ball.physicsBody.ApplyImpulse(impulse, _ball.physicsBody.GetWorldCenter());
			
			_ready = true;
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
			
			_mouseJoint.SetTarget(new b2Vec2(_mouseXWorldPhys, 500 / PhysicsWorld.PhysScale));
			
			PhysicsWorld.UpdateWorld();
			
			for each( var bs:BrickSprite in _brickSpritesVector )
			{
				bs.update();
			}
			
			_grid.update();
			_ball.update();
			_paddle.update();
			
			var go:GridObject;
			var objectDrawn:Vector.<GridObject> = new Vector.<GridObject>();
			
			_gameScreen.bitmapData.fillRect( _gameScreen.bitmapData.rect, 0x00000000);
			for ( var i:int = 0; i < _grid.gridWidth; i++)
			{
				for ( var j:int = 0; j < _grid.gridHeight; j++ )
				{
					go = _grid.getGridObjectAt(i, j);
					if (go && objectDrawn.indexOf(go) == -1) 
					{
						var bmd:BitmapData = (go as Brick).brickSprite.currFrame;
						_gameScreen.bitmapData.copyPixels( bmd, bmd.rect, new Point(i * AppSettings.instance.defaultTileWidth, j * AppSettings.instance.defaultTileHeight), null, null, true );
						
						objectDrawn.push(go);
					}
				}
			}
				
			_gameScreen.bitmapData.copyPixels( _ball.bitmap.bitmapData, _ball.bitmap.bitmapData.rect, new Point( _ball.x - _ball.width / 2, _ball.y - _ball.height / 2 ), null, null, true );
			_gameScreen.bitmapData.copyPixels( _paddle.bitmap.bitmapData, _paddle.bitmap.bitmapData.rect, new Point( _paddle.x - _paddle.width / 2, _paddle.y - _paddle.height / 2 ), null, null, true );
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
import Box2D.Collision.b2WorldManifold;
import Box2D.Dynamics.b2ContactImpulse;
import Box2D.Dynamics.b2ContactListener;
import Box2D.Dynamics.b2Fixture;
import Box2D.Dynamics.Contacts.b2Contact;
import com.bored.games.breakout.objects.Ball;
import com.bored.games.breakout.objects.bricks.Brick;
import com.bored.games.breakout.objects.Paddle;

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
	}//end BeginContact()
	
	override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
	{
	}//end BeginContact()
	
}//end GameContactListener