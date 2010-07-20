package com.bored.games.breakout.states.views 
{
	import away3dlite.loaders.Collada;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2LineJoint;
	import Box2D.Dynamics.Joints.b2LineJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import com.bored.games.breakout.actions.BrickMultiplierManagerAction;
	import com.bored.games.breakout.actions.DestructoballAction;
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.actions.InvinciballAction;
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.actions.PaddleMultiplierManagerAction;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Bomb;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.bricks.LimpBrick;
	import com.bored.games.breakout.objects.bricks.MultiHitBrick;
	import com.bored.games.breakout.objects.bricks.NanoBrick;
	import com.bored.games.breakout.objects.bricks.Portal;
	import com.bored.games.breakout.objects.bricks.SimpleBrick;
	import com.bored.games.breakout.objects.bricks.UnbreakableBrick;
	import com.bored.games.breakout.objects.Bullet;
	import com.bored.games.breakout.objects.collectables.CatchPowerup;
	import com.bored.games.breakout.objects.collectables.Collectable;
	import com.bored.games.breakout.objects.collectables.DestructoballPowerup;
	import com.bored.games.breakout.objects.collectables.ExtendPowerup;
	import com.bored.games.breakout.objects.collectables.InvinciballPowerup;
	import com.bored.games.breakout.objects.collectables.LaserPowerup;
	import com.bored.games.breakout.objects.collectables.MultiballPowerup;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.input.Input;
	import com.bored.games.objects.GameElement;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import de.polygonal.ds.mem.MemoryManager;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLIterator;
	import de.polygonal.ds.SLLNode;
	import flash.Boot;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.StageQuality;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import net.hires.debug.Stats;
	import org.flintparticles.common.actions.Fade;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.Line;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.activities.FollowDisplayObject;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RotateToDirection;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.DisplayObjectZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameView extends StateView
	{
		public static var Contacts:ContactLL;
		public static var Collectables:SLL;
		public static var Bullets:SLL;
		
		public static var ParticleRenderer:Renderer;
		
		private var _grid:Grid;
		private var _balls:SLL;
		private var _paddle:Paddle;
		
		private var _walls:b2Body;
		private var _topWall:b2Fixture;
		private var _bottomWall:b2Fixture;
		
		private var _drawnObjects:SLL;
		
		private var _gameScreen:Bitmap;
		
		private var _bkgdMC:MovieClip;
		
		private var _backBuffer:BitmapData;
		private var _effectsBuffer:BitmapData;
		
		private var _ballSparks:Emitter2D;
	
		private var _glowFilter:GlowFilter;
		private var _blurFilter:BlurFilter;
		
		private var _animationSets:Dictionary;
		private var _backgrounds:Vector.<MovieClip>;
		
		private var _spriteLoader:Loader;
		private var _backgroundLoader:Loader;
		private var _spriteExplorer:SWFExplorer;
		private var _backgroundExplorer:SWFExplorer;
		
		private var _spritesLoaded:Boolean = false;
		private var _backgroundsLoaded:Boolean = false;
		
		private var _currBkgd:int;
		
		private var _levelLoader:Loader;
		
		private var _paused:Boolean = true;
		
		private var _mouseXWorldPhys:Number;
		private var _mouseYWorldPhys:Number;
		
		private var _mouseXWorld:Number;
		private var _mouseYWorld:Number;
		
		private var _mouseXDelta:Number;
		private var _mouseXLast:Number;
		
		private var _mouseJoint:b2MouseJoint;
		private var _lineJoint:b2LineJoint;
		
		private var _matrix:Array;
		
		private var _stats:Stats;
		
		private var _multiplier:GameElement;
		private var _brickMultiplierManager:BrickMultiplierManagerAction;
		private var _paddleMultiplierManager:PaddleMultiplierManagerAction;
		
		public function GameView() 
		{
			super();
						
			_balls = new SLL();
			
			Contacts = new ContactLL();
			Collectables = new SLL();
			Bullets = new SLL();
			
			_drawnObjects = new SLL();
			
			_multiplier = new GameElement();
			_brickMultiplierManager = new BrickMultiplierManagerAction(_multiplier, { "timeout":250 } );
			_paddleMultiplierManager = new PaddleMultiplierManagerAction(_multiplier, { "maxMultiplier":5 } );
			_multiplier.addAction(_brickMultiplierManager);
			_multiplier.addAction(_paddleMultiplierManager);
				
			PhysicsWorld.InitializePhysics();
			//PhysicsWorld.SetDebugDraw(this);
			PhysicsWorld.SetContactListener(new GameContactListener());
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			stage.quality = StageQuality.BEST;
			
			new CatchPowerup();
			new InvinciballPowerup();
			new ExtendPowerup();
			new LaserPowerup();
			new MultiballPowerup();
			new DestructoballPowerup();
			
			new LaserPaddleAction(null, null);
			
			_currBkgd = 0;
			
			_backBuffer = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			_effectsBuffer = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			
			_gameScreen = new Bitmap();
			_gameScreen.bitmapData = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			_gameScreen.smoothing = true;
			addChild( _gameScreen );
			
			_grid = new Grid( AppSettings.instance.defaultGridWidth, AppSettings.instance.defaultGridHeight );
			_paddle = new Paddle();
			
			_spriteLoader = new Loader();
			_spriteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spritesLoaded, false, 0, true);
			_spriteLoader.load( new URLRequest("../assets/BrickSpriteLibrary.swf") );
			
			_backgroundLoader = new Loader();
			_backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundsLoaded, false, 0, true);
			_backgroundLoader.load( new URLRequest("../assets/BackgroundLibrary.swf") );
			
			ParticleRenderer = new BitmapRenderer( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight), false );
			addChild((ParticleRenderer as BitmapRenderer));
			
			stage.invalidate();
			
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
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
			wallBd.type = b2Body.b2_staticBody;
			_walls = PhysicsWorld.CreateBody(wallBd);
			
			wall.SetAsOrientedBox( 30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale, new b2Vec2(-30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale) );
			_walls.CreateFixture2(wall);
			
			wall.SetAsOrientedBox( 336 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale, new b2Vec2(336 / PhysicsWorld.PhysScale, -30 / PhysicsWorld.PhysScale) );
			_topWall = _walls.CreateFixture2(wall);
			
			wall.SetAsOrientedBox( 30 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale, new b2Vec2(704 / PhysicsWorld.PhysScale, 272 / PhysicsWorld.PhysScale) );
			_walls.CreateFixture2(wall);
			
			wall.SetAsOrientedBox( 336 / PhysicsWorld.PhysScale, 30 / PhysicsWorld.PhysScale, new b2Vec2(336 / PhysicsWorld.PhysScale, 574 / PhysicsWorld.PhysScale) );
			_bottomWall = _walls.CreateFixture2(wall);
			
			_paddle.physicsBody.SetPosition( new b2Vec2( 336 / PhysicsWorld.PhysScale, 500 / PhysicsWorld.PhysScale ) );
						
			var md:b2MouseJointDef = new b2MouseJointDef();
			md.bodyA = PhysicsWorld.GetGroundBody();
			md.bodyB = _paddle.physicsBody;
			md.target.Set( AppSettings.instance.paddleStartX / PhysicsWorld.PhysScale, AppSettings.instance.paddleStartY / PhysicsWorld.PhysScale);
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
		
		private function backgroundsLoaded(e:Event):void
		{
			_backgroundExplorer = new SWFExplorer();
			_backgroundExplorer.addEventListener(SWFExplorerEvent.COMPLETE, backgroundAssetsParsed, false, 0, true);
			_backgroundExplorer.parse(_backgroundLoader.contentLoaderInfo.bytes);
		}//end backgroundsLoaded()
		
		private function spriteAssetsParsed(e:SWFExplorerEvent):void
		{
			_animationSets = new Dictionary(true);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _spriteLoader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				var anims:AnimationSet = AnimationSetFactory.generateAnimationSet(new cls() as MovieClip);
				
				_animationSets[e.definitions[i]] = anims;
			}
			
			_spritesLoaded = true;
			
			if ( _spritesLoaded && _backgroundsLoaded )
			{
				loadNextLevel();
			}
		}//end spriteAssetsParsed()
		
		private function backgroundAssetsParsed(e:SWFExplorerEvent):void
		{
			_backgrounds = new Vector.<MovieClip>(e.definitions.length);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _backgroundLoader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				_backgrounds[i] = new cls() as MovieClip;
			}
			
			_backgroundsLoaded = true;
			
			if ( _spritesLoaded && _backgroundsLoaded )
			{
				loadNextLevel();
			}
		}//end backgroundAssetsParsed()
		
		private function loadNextLevel():void
		{			
			_levelLoader = new Loader();
			_levelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, levelLoaded, false, 0, true);
			_levelLoader.load( new URLRequest(HUDView.Level.levelDataURL) );
		}//end loadNextLevel()
		
		private function levelLoaded(e:Event):void
		{
			var parent:DisplayObjectContainer = _levelLoader.content as DisplayObjectContainer;
			
			for ( var i:int = 0; i < parent.numChildren; i++ )
			{
				var obj:DisplayObject = parent.getChildAt(i);
				
				var brick:Brick;
				
				switch(getQualifiedClassName(obj))
				{
					case "Bomb":
						brick = new Bomb(
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedLimp": case "SmLimp":
						brick = new LimpBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedTwoHit": case "SmTwoHit":
						brick = new MultiHitBrick(
							2,
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedThreeHit": case "SmThreeHit":
						brick = new MultiHitBrick(
							3,
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedMetal": case "SmMetal":
						brick = new UnbreakableBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "Portal":
						brick = new Portal( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedNanoAlive":
						brick = new NanoBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
					case "MedNanoDead":
						brick = new NanoBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)],
							false);
						break;
					default:
						brick = new SimpleBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							_animationSets[getQualifiedClassName(obj)]);
						break;
				}
			
				if ( brick )
					_grid.addGridObject(brick, uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
			}
		
			var ball:Ball = addBallAt();
			
			_paddle.catchBall(ball);
			
			stage.quality = StageQuality.LOW;
		
			_paused = false;
		}//end onComplete()
		
		private function addBallAt(a_x:Number = 0, a_y:Number = 0):Ball
		{
			var ball:Ball = new Ball();
			
			ball.physicsBody.SetPosition( new b2Vec2( a_x / PhysicsWorld.PhysScale, a_y / PhysicsWorld.PhysScale ) );
			
			_balls.append(ball);
			
			return ball;
		}//end resetBall()
		
		private function ballLost():void
		{
			_multiplier.deactivateAction(BrickMultiplierManagerAction.NAME);
			_multiplier.deactivateAction(PaddleMultiplierManagerAction.NAME);
			
			HUDView.Profile.decrementLives();
			
			if (HUDView.Profile.lives > 0)
			{
				var ball:Ball = addBallAt();
				_paddle.catchBall(ball);
			}
			else
			{
				_paused = true;
			}
		}//end ballLost()
		
		override public function exit():void
		{
			_grid = null;
			_paddle = null;
			
			exitComplete();
		}//end exit()
		
		private function renderFrame(e:Event):void
		{			
			var go:GridObject;
			_drawnObjects.clear();
			
			if( _backgroundsLoaded )
				_backBuffer.draw(_backgrounds[_currBkgd]);
			
			var iter:SLLIterator = new SLLIterator(Collectables);
			for ( var i:int = 0; i < _grid.gridWidth; i++)
			{
				for ( var j:int = 0; j < _grid.gridHeight; j++ )
				{
					go = _grid.getGridObjectAt(i, j);
					if (go && !_drawnObjects.contains(go)) 
					{
						var bmd:BitmapData = (go as Brick).currFrame;
						_backBuffer.copyPixels( bmd, bmd.rect, new Point(i * AppSettings.instance.defaultTileWidth, j * AppSettings.instance.defaultTileHeight), null, null, true );
						
						_drawnObjects.append(go);
					}
				}
			}
			
			var obj:Object;
			
			iter = new SLLIterator(_balls);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				_backBuffer.copyPixels( obj.currFrame, obj.currFrame.rect, new Point( obj.x, obj.y ), null, null, true );
			}
			
			_backBuffer.copyPixels( _paddle.currFrame, _paddle.currFrame.rect, new Point( _paddle.x, _paddle.y ), null, null, true );
			
			iter = new SLLIterator(Collectables);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				_backBuffer.copyPixels( obj.currFrame, obj.currFrame.rect, new Point( obj.x, obj.y ), null, null, true );
			}
			
			iter = new SLLIterator(Bullets);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				_backBuffer.copyPixels( obj.currFrame, obj.currFrame.rect, new Point(obj.x, obj.y), null, null, true );
			}
					
			_gameScreen.bitmapData.copyPixels(_backBuffer, _gameScreen.bitmapData.rect, new Point());	
		}//end render()
		
		private function handleBallCollision(a_ball:b2Fixture, a_fixture:b2Fixture, a_point:b2Vec2):void
		{
			var node:SLLNode;
			
			if ( a_fixture == _bottomWall )
			{
				 node = _balls.nodeOf(a_ball.GetUserData(), _balls.head())
				 if (node) node.remove();
				 a_ball.GetUserData().destroy();
			}
			else if ( a_fixture.GetUserData() is Paddle )
			{
				if ( a_fixture.GetUserData().stickyMode && !a_fixture.GetUserData().occupied )
				{
					a_fixture.GetUserData().catchBall(a_ball.GetUserData() as Ball);
				}
				
				if ( _paddleMultiplierManager.finished )
				{
					_multiplier.activateAction(PaddleMultiplierManagerAction.NAME);
				}
				
				_paddleMultiplierManager.increaseMultiplier();
			}
			else if ( a_fixture.GetUserData() is Brick )
			{
				if ( a_ball.GetUserData().ballMode == Ball.SUPER_BALL )
				{
					var neighbors:Vector.<Brick> = _grid.getAllNeighbors(a_fixture.GetUserData() as Brick);
					_grid.explodeBricks(neighbors);
					
					if (a_fixture.GetUserData().notifyHit())
					{
						if ( _brickMultiplierManager.finished )
						{
							_multiplier.activateAction(BrickMultiplierManagerAction.NAME)
						}
						
						_brickMultiplierManager.increaseMultiplier();
						
						HUDView.Profile.addPoints(AppSettings.instance.brickPoints * _brickMultiplierManager.multiplier * _paddleMultiplierManager.multiplier);
					}
				}
				else if ( a_ball.GetUserData().ballMode == Ball.DESTRUCT_BALL )
				{
					a_fixture.GetUserData().addAction(new DisintegrateBrickAction(a_fixture.GetUserData() as Brick));
					a_fixture.GetUserData().activateAction(DisintegrateBrickAction.NAME);
					
					a_fixture.GetUserData().activateAction(RemoveGridObjectAction.NAME);
					
					if ( _brickMultiplierManager.finished )
					{
						_multiplier.activateAction(BrickMultiplierManagerAction.NAME)
					}
					
					_brickMultiplierManager.increaseMultiplier();
					
					HUDView.Profile.addPoints(AppSettings.instance.brickPoints * _brickMultiplierManager.multiplier * _paddleMultiplierManager.multiplier);
				}
				else
				{
					if (a_fixture.GetUserData().notifyHit())
					{
						if ( _brickMultiplierManager.finished )
						{
							_multiplier.activateAction(BrickMultiplierManagerAction.NAME)
						}
						
						_brickMultiplierManager.increaseMultiplier();
						
						HUDView.Profile.addPoints(AppSettings.instance.brickPoints * _brickMultiplierManager.multiplier * _paddleMultiplierManager.multiplier);
					}
				}
			}
		}//end handleBallCollision()
		
		private function handleCollectableCollision(a_collectable:b2Fixture, a_fixture:b2Fixture):void
		{
			var ind:int;
			var node:SLLNode;
			
			if ( a_fixture == _bottomWall )
			{
				node = Collectables.nodeOf(a_collectable.GetUserData(), Collectables.head());
				if (node) node.remove();
				a_collectable.GetUserData().destroy();
				return;
			}
			else if ( a_fixture.GetUserData() is Paddle )
			{
				node = Collectables.nodeOf(a_collectable.GetUserData(), Collectables.head());
				if (node) node.remove();
				if ( a_collectable.GetUserData().actionName == "multiball" )
				{
					var obj:Object = _balls.getNodeAt(0).val;
					
					addBallAt(obj.x, obj.y);
					addBallAt(obj.x, obj.y);
				}
				else if ( a_collectable.GetUserData().actionName == DestructoballAction.NAME || a_collectable.GetUserData().actionName == InvinciballAction.NAME )
				{
					var iter:SLLIterator = new SLLIterator(_balls);
					while ( iter.hasNext() )
					{
						obj = iter.next();
						obj.activatePowerup( a_collectable.GetUserData().actionName );
					}
				}
				else
				{
					a_fixture.GetUserData().activatePowerup(a_collectable.GetUserData().actionName);
				}
				a_collectable.GetUserData().destroy();
			}
		}//end handleCollectableCollision()
		
		private function handleBulletCollision(a_bullet:b2Fixture, a_fixture:b2Fixture):void
		{
			var ind:int;
			var node:SLLNode;
			
			if ( a_fixture == _topWall )
			{
				node = Bullets.nodeOf(a_bullet.GetUserData(), Bullets.head())
				if (node) node.remove();
				a_bullet.GetUserData().destroy();
			}
			else if ( a_fixture.GetUserData() is NanoBrick )
			{
				if ( a_fixture.GetUserData().alive )
				{
					node = Bullets.nodeOf(a_bullet.GetUserData(), Bullets.head())
					if (node) node.remove();
					a_fixture.GetUserData().notifyHit();
					a_bullet.GetUserData().destroy();
				}
			}
			else if ( a_fixture.GetUserData() is Portal )
			{
				return;
			}
			else if ( a_fixture.GetUserData() is Brick )
			{
				node = Bullets.nodeOf(a_bullet.GetUserData(), Bullets.head())
				if (node) node.remove();
				a_fixture.GetUserData().notifyHit();
				a_bullet.GetUserData().destroy();
			}
		}//end handleBulletCollision()
		
		override public function update():void
		{
			if ( _paused ) return;
			
			if ( HUDView.Profile.time <= 0 ) _paused = true;
			
			if ( _balls.isEmpty() ) ballLost();
			
			if ( Input.isKeyReleased(Keyboard.F1) ) 
			{
				_currBkgd ++;
				if ( _currBkgd >= _backgrounds.length ) _currBkgd = 0;
			}
			
			UpdateMouseWorld();
			
			if ( Input.mouseDown ) _paddle.releaseBall();
			
			_mouseJoint.SetTarget(new b2Vec2(_mouseXWorldPhys, AppSettings.instance.paddleStartY / PhysicsWorld.PhysScale));
			
			_lineJoint.SetLimits( -(330 - _paddle.width / 2) / PhysicsWorld.PhysScale, (330 - _paddle.width / 2) / PhysicsWorld.PhysScale );
			
			PhysicsWorld.UpdateWorld();
		
			var iter:SLLIterator = new SLLIterator(Contacts);
			while( iter.hasNext() )
			{
				var c:Object = iter.next();
				
				if ( c.fixtureA.GetUserData() is Ball )
				{
					handleBallCollision(c.fixtureA, c.fixtureB, c.point);
					continue;
				}
				
				if ( c.fixtureB.GetUserData() is Ball )
				{
					handleBallCollision(c.fixtureB, c.fixtureA, c.point);
					continue;
				}
				
				if ( c.fixtureA.GetUserData() is Collectable )
				{
					handleCollectableCollision(c.fixtureA, c.fixtureB);
					continue;
				}
				
				if ( c.fixtureB.GetUserData() is Collectable )
				{
					handleCollectableCollision(c.fixtureB, c.fixtureA);
					continue;
				}
				
				if ( c.fixtureA.GetUserData() is Bullet )
				{
					handleBulletCollision(c.fixtureA, c.fixtureB);
					continue;
				}
				
				if ( c.fixtureB.GetUserData() is Bullet )
				{
					handleBulletCollision(c.fixtureB, c.fixtureA);
					continue;
				}
			}	
			
			if( stage )	stage.invalidate();
		}//end update()
		
		private function UpdateMouseWorld():void
		{
			_mouseXWorldPhys = (Input.mouseX) / PhysicsWorld.PhysScale;
			_mouseYWorldPhys = (Input.mouseY) / PhysicsWorld.PhysScale;
			
			_mouseXWorld = (Input.mouseX);
			_mouseYWorld = (Input.mouseY);
		}//end UpdateMouseWorld()
	
	}//end GameView

}//end package

import Box2D.Collision.b2AABB;
import Box2D.Collision.b2Bound;
import Box2D.Collision.b2Manifold;
import Box2D.Collision.b2WorldManifold;
import Box2D.Collision.Shapes.b2CircleShape;
import Box2D.Collision.Shapes.b2PolygonShape;
import Box2D.Common.Math.b2Transform;
import Box2D.Common.Math.b2Vec2;
import Box2D.Dynamics.b2Body;
import Box2D.Dynamics.b2ContactImpulse;
import Box2D.Dynamics.b2ContactListener;
import Box2D.Dynamics.b2Fixture;
import Box2D.Dynamics.Contacts.b2Contact;
import Box2D.Dynamics.Joints.b2DistanceJointDef;
import com.bored.games.breakout.objects.Ball;
import com.bored.games.breakout.objects.bricks.Brick;
import com.bored.games.breakout.objects.Bullet;
import com.bored.games.breakout.objects.Paddle;
import com.bored.games.breakout.physics.PhysicsWorld;
import com.bored.games.breakout.states.views.GameView;
import com.sven.utils.AppSettings;
import de.polygonal.ds.SLL;
import de.polygonal.ds.SLLNode;

class GameContactListener extends b2ContactListener
{
	override public function BeginContact(contact:b2Contact):void
	{
		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		
		var wm:b2WorldManifold = new b2WorldManifold();
		contact.GetWorldManifold(wm);
		
		var point:b2Vec2 = wm.m_points[0];
		
		if ( contact.IsEnabled() ) 
		{
			GameView.Contacts.append( new GameContact(contact.GetFixtureA(), contact.GetFixtureB(), point) );
		}
	}//end BeginContact()
	
	override public function EndContact(contact:b2Contact):void
	{
		var obj:GameContact = new GameContact(contact.GetFixtureA(), contact.GetFixtureB());
		
		GameView.Contacts.nodeOf(obj, GameView.Contacts.head()).remove();		
	}//end EndContact()
	
	override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
	{
		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		
		if (!(fixtureA.GetUserData() is Paddle && fixtureB.GetUserData() is Ball))
			return;
		
		var paddle:b2Vec2 = contact.GetFixtureA().GetBody().GetPosition();
		var ball:b2Vec2 = contact.GetFixtureB().GetBody().GetPosition();
		
		var ballXDiff:Number = ball.x - paddle.x;
		
		var rect:b2AABB = new b2AABB();
		contact.GetFixtureA().GetShape().ComputeAABB(rect, new b2Transform());
		
		var ballXRatio:Number = ballXDiff / (rect.GetExtents().x * 2);
		
		if (ballXRatio < -0.95) ballXRatio = -0.95;
		if (ballXRatio > 0.95) ballXRatio = 0.95;
		
		var wm:b2WorldManifold = new b2WorldManifold();
		contact.GetWorldManifold(wm);
		
		var point:b2Vec2 = wm.m_points[0];
		
		var bodyB:b2Body = contact.GetFixtureB().GetBody();
		var vB:b2Vec2 = bodyB.GetLinearVelocityFromWorldPoint(point);
		
		var newVel:b2Vec2 = vB.Copy();
		newVel.x = ballXRatio * AppSettings.instance.paddleReflectionMultiplier;
		
		var solvedYVel:Number = Math.sqrt(vB.LengthSquared() - (newVel.x * newVel.x));
		
		newVel.y = -solvedYVel;
		
		bodyB.SetLinearVelocity(newVel);		
	}//end BeginContact()
	
	override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
	{	
		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		
		if (fixtureA.GetUserData() is Brick && fixtureB.GetUserData() is Ball)
		{
			if ( fixtureB.GetUserData().ballMode == Ball.DESTRUCT_BALL )
			{
				contact.SetSensor(true);
			}
		}
		
		if (!(fixtureA.GetUserData() is Paddle && fixtureB.GetUserData() is Ball))
			return;
		
		var positionPaddle:b2Vec2 = fixtureA.GetBody().GetPosition();
		var positionBall:b2Vec2 = fixtureB.GetBody().GetPosition();
		
		var paddle:Paddle = fixtureA.GetUserData() as Paddle;
		var ball:Ball = fixtureB.GetUserData() as Ball;
		var heightPhys:Number = paddle.height / PhysicsWorld.PhysScale;
		
		if (positionBall.y > (positionPaddle.y - heightPhys / 2))
		{
			contact.SetEnabled(false);		
		}
	}//end BeginContact()
	
}//end GameContactListener

class GameContact 
{
	public var fixtureA:b2Fixture;
	public var fixtureB:b2Fixture;
	public var point:b2Vec2;
	
	public function GameContact( a_fixtureA:b2Fixture, a_fixtureB:b2Fixture, a_point:b2Vec2 = null )
	{
		fixtureA = a_fixtureA;
		fixtureB = a_fixtureB;
		point = a_point;
	}//end constructor()
	
	public function equals(a_gameContact:GameContact):Boolean
	{
		return (a_gameContact.fixtureA === this.fixtureA) && (a_gameContact.fixtureB === this.fixtureB);
	}//end equals()
	
}//end GameContact

class ContactLL extends SLL
{
	override public function nodeOf(x:Object, from:SLLNode = null):SLLNode 
	{		
		var node:SLLNode = from;
		while (_valid(node))
		{
			if (node.val.equals(x)) break;
			node = node.next;
		}
		
		return node;
	}	
}//end ContactLL