package com.bored.games.breakout.states.views 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameView extends StateView
	{
		private var _grid:Grid;
		private var _ball:Ball;
		
		private var _gameScreen:Bitmap;
		
		private var _ready:Boolean = false;
		
		public function GameView() 
		{
			super();
			
			PhysicsWorld.InitializePhysics();
			//PhysicsWorld.SetDebugDraw(this);
			
			_gameScreen = new Bitmap();
			addChild( _gameScreen );
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			_gameScreen.bitmapData = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			
			_grid = new Grid( AppSettings.instance.defaultGridWidth, AppSettings.instance.defaultGridHeight );
			_ball = new Ball();
			
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
			
			wallBd.position.Set( -30 / PhysicsWorld.PhysScale, 275 / PhysicsWorld.PhysScale);
			wall.SetAsBox( 30 / PhysicsWorld.PhysScale, 275 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set( 350 / PhysicsWorld.PhysScale, -30 / PhysicsWorld.PhysScale);
			wall.SetAsBox(350 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set(730 / PhysicsWorld.PhysScale, 275 / PhysicsWorld.PhysScale);
			wall.SetAsBox( 30 / PhysicsWorld.PhysScale, 275 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			wallBd.position.Set(350 / PhysicsWorld.PhysScale, 580 / PhysicsWorld.PhysScale);
			wall.SetAsBox(350 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale);
			wallB = PhysicsWorld.CreateBody(wallBd);
			wallB.CreateFixture2(wall);
			
			_ball.physicsBody.SetPosition( new b2Vec2( 320 / PhysicsWorld.PhysScale, 320 / PhysicsWorld.PhysScale ) );
			
			for ( var i:uint = 0; i < 100; i++ )
			{
				_grid.addGridObject(
					new Brick(Math.ceil(Math.random() * 3), Math.ceil(Math.random() * 3)),
					uint(Math.random() * _grid.gridWidth),
					uint(Math.random() * _grid.gridWidth));
			}
			
			var impulse:b2Vec2 = new b2Vec2(Math.random() * 20 - 10, Math.random() * 20 - 10);
			_ball.physicsBody.ApplyImpulse(impulse, _ball.physicsBody.GetWorldCenter());
			
			enterComplete();
		}//end enter()
		
		override public function exit():void
		{
			_grid = null;
			_ball = null;
			
			exitComplete();
		}//end exit()
		
		override public function update():void
		{
			if ( !_ready ) return;
			
			PhysicsWorld.UpdateWorld();
			
			_grid.update();
			_ball.update();
			
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
	}//end GameView

}//end package