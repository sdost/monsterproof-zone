package com.bored.games.breakout.states.views 
{
	import Box2DAS.Dynamics.ContactEvent;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import flash.utils.getDefinitionByName;
	import Box2DAS.Collision.b2AABB;
	import Box2DAS.Collision.b2Manifold;
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.b2Transform;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import Box2DAS.Dynamics.Contacts.b2Contact;
	import Box2DAS.Dynamics.Joints.b2DistanceJoint;
	import Box2DAS.Dynamics.Joints.b2DistanceJointDef;
	import Box2DAS.Dynamics.Joints.b2LineJoint;
	import Box2DAS.Dynamics.Joints.b2LineJointDef;
	import Box2DAS.Dynamics.Joints.b2MouseJoint;
	import Box2DAS.Dynamics.Joints.b2MouseJointDef;
	import Box2DAS.Dynamics.Joints.b2PrismaticJoint;
	import Box2DAS.Dynamics.Joints.b2PrismaticJointDef;
	import com.bored.games.breakout.actions.BrickMultiplierManagerAction;
	import com.bored.games.breakout.actions.DestructoballAction;
	import com.bored.games.breakout.actions.DisintegrateBrickAction;
	import com.bored.games.breakout.actions.InvinciballAction;
	import com.bored.games.breakout.actions.LaserPaddleAction;
	import com.bored.games.breakout.actions.PaddleMultiplierManagerAction;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.emitters.CollectionFizzle;
	import com.bored.games.breakout.emitters.ImpactSparks;
	import com.bored.games.breakout.emitters.PortalVortex;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.factories.AnimationSetFactory;
	import com.sven.animation.AnimationSet;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Beam;
	import com.bored.games.breakout.objects.bricks.Bomb;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.sven.animation.AnimatedSprite;
	import com.bored.games.breakout.objects.bricks.LimpBrick;
	import com.bored.games.breakout.objects.bricks.MultiHitBrick;
	import com.bored.games.breakout.objects.bricks.NanoBrick;
	import com.bored.games.breakout.objects.bricks.Portal;
	import com.bored.games.breakout.objects.bricks.SimpleBrick;
	import com.bored.games.breakout.objects.bricks.UnbreakableBrick;
	import com.bored.games.breakout.objects.Bullet;
	import com.bored.games.breakout.objects.collectables.Bonus;
	import com.bored.games.breakout.objects.collectables.CatchPowerup;
	import com.bored.games.breakout.objects.collectables.Collectable;
	import com.bored.games.breakout.objects.collectables.DestructoballPowerup;
	import com.bored.games.breakout.objects.collectables.ExtendPowerup;
	import com.bored.games.breakout.objects.collectables.ExtraLifePowerup;
	import com.bored.games.breakout.objects.collectables.InvinciballPowerup;
	import com.bored.games.breakout.objects.collectables.LaserPowerup;
	import com.bored.games.breakout.objects.collectables.MultiballPowerup;
	import com.bored.games.breakout.objects.collectables.SuperLaserPowerup;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.input.Input;
	import com.bored.games.objects.GameElement;
	import com.inassets.events.ObjectEvent;
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
	import flash.text.engine.BreakOpportunity;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
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
	 * Dispatched when level is finished loading
	 *
 	 */
	[Event(name = 'levelLoaded', type = 'flash.events.Event')]
	
	[Event(name = 'levelFinished', type = 'flash.events.Event')]
	
	[Event(name = 'ballLost', type = 'flash.events.Event')]
	
	[Event(name = 'ballGained', type = 'flash.events.Event')]
	
	[Event(name = 'addPoints', type = 'com.inassets.events.ObjectEvent')]
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameView extends StateView
	{	
		public static const sfx_BallWallBounce:String = "ballWallBounce";
		public static const sfx_BallPaddleBounce:String = "ballPaddleBounce";
		public static const sfx_BrickDisintegrate:String = "brickDisintegrate";
		
		public static const sfx_BrickDestroyLg:String = "brickDisintegrate";
		
		public static const sfx_BrickExplode:String = "brickExplode";
		public static const sfx_PaddleCatch:String = "paddleCatch";
		public static const sfx_PaddleExtend:String = "paddleExtend";
		
		public static const id_Ball:uint = 0x0002;
		public static const id_Brick:uint = 0x0004;
		public static const id_Paddle:uint = 0x0008;
		public static const id_Bullet:uint = 0x000F;
		public static const id_Collectable:uint = 0x0020;
		public static const id_Wall:uint = 0x0040;
		
		public static var Contacts:ContactLL;
		public static var Collectables:SLL;
		public static var Bullets:SLL;
		public static var Emitters:SLL;
		
		public static var ParticleRenderer:Renderer;
		
		private var _grid:Grid;
		private var _balls:SLL;
		private var _paddle:Paddle;
		private var _backgroundMC:MovieClip;
		
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
		
		private var _multiplier:GameElement;
		private var _brickMultiplierManager:BrickMultiplierManagerAction;
		private var _paddleMultiplierManager:PaddleMultiplierManagerAction;
		
		private var _lastUpdate:Number;
		
		public function GameView() 
		{
			super();
						
			_balls = new SLL();
			
			_backgroundMC = new MovieClip();
			
			Contacts = new ContactLL();
			Collectables = new SLL();
			Bullets = new SLL();
			Emitters = new SLL();
			
			_drawnObjects = new SLL();
			
			_multiplier = new GameElement();
			_brickMultiplierManager = new BrickMultiplierManagerAction(_multiplier);
			_paddleMultiplierManager = new PaddleMultiplierManagerAction(_multiplier);
			_multiplier.addAction(_brickMultiplierManager);
			_multiplier.addAction(_paddleMultiplierManager);
				
			PhysicsWorld.InitializePhysics();
			//PhysicsWorld.SetDebugDraw(this);
			PhysicsWorld.SetContactListener(new GameContactListener());
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			//trace("GameView::addedToStageHandler()");
			
			super.addedToStageHandler(e);
			
			(new CatchPowerup()).destroy();
			(new InvinciballPowerup()).destroy();
			(new ExtendPowerup()).destroy();
			(new LaserPowerup()).destroy();
			(new MultiballPowerup()).destroy();
			(new DestructoballPowerup()).destroy();
			(new SuperLaserPowerup()).destroy();
			(new ExtraLifePowerup()).destroy();
			
			new LaserPaddleAction(null, null);
			
			_grid = new Grid( AppSettings.instance.defaultGridWidth, AppSettings.instance.defaultGridHeight );
					
			_backBuffer = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			_effectsBuffer = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			
			_gameScreen = new Bitmap();
			_gameScreen.bitmapData = new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00000000 );
			_gameScreen.smoothing = true;
			//_gameScreen.alpha = 0.3;
			addChild( _gameScreen );
			
			ParticleRenderer = new BitmapRenderer( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight), true );
			addChild((ParticleRenderer as BitmapRenderer));
			
			//sfx.addSound( new SMSound( sfx_BallWallBounce, "breakout.assets.sfx.Bounce1" ) );
			//sfx.addSound( new SMSound( sfx_BallPaddleBounce, "breakout.assets.sfx.Bounce2" ) );
			//sfx.addSound( new SMSound( sfx_BrickExplode, "breakout.assets.sfx.Explode" ) );
			//sfx.addSound( new SMSound( sfx_PaddleCatch, "breakout.assets.sfx.PaddleCatch", true ) );
			//sfx.addSound( new SMSound( sfx_PaddleExtend, "breakout.assets.sfx.PaddleExtend" ) );
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
			//trace("GameView::enter()");
			
			/*
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Wall;
			filter.maskBits = GameView.id_Ball | GameView.id_Bullet | GameView.id_Collectable;
			*/
			
			b2Def.fixture.restitution = 1.0;
			b2Def.fixture.filter.categoryBits = GameView.id_Wall;
			b2Def.fixture.filter.maskBits = GameView.id_Ball | GameView.id_Bullet | GameView.id_Collectable;
			b2Def.fixture.isSensor = false;
			b2Def.fixture.userData = null;
			
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			var w2:int = w / 2;
			var h2:int = h / 2;
			var i:int = 30;
			
			b2Def.polygon.SetAsBox( i / PhysicsWorld.PhysScale, h2 / PhysicsWorld.PhysScale, new V2(-(i / PhysicsWorld.PhysScale), h2 / PhysicsWorld.PhysScale) ); // LEFT
			b2Def.polygon.create(PhysicsWorld.GetGroundBody(), b2Def.fixture);
			b2Def.polygon.SetAsBox( w2 / PhysicsWorld.PhysScale, i / PhysicsWorld.PhysScale, new V2(w2 / PhysicsWorld.PhysScale, -(i / PhysicsWorld.PhysScale)) ); // TOP
			_topWall = b2Def.polygon.create(PhysicsWorld.GetGroundBody(), b2Def.fixture);
			_topWall.m_reportBeginContact = true;
			_topWall.m_reportEndContact = true;
			b2Def.polygon.SetAsBox( i / PhysicsWorld.PhysScale, h2 / PhysicsWorld.PhysScale, new V2((w+i) / PhysicsWorld.PhysScale, h2 / PhysicsWorld.PhysScale) ); // RIGHT
			b2Def.polygon.create(PhysicsWorld.GetGroundBody(), b2Def.fixture);
			b2Def.polygon.SetAsBox( w2 / PhysicsWorld.PhysScale, i / PhysicsWorld.PhysScale, new V2(w2 / PhysicsWorld.PhysScale, (h+i) / PhysicsWorld.PhysScale) ); // BOTTOM
			_bottomWall = b2Def.polygon.create(PhysicsWorld.GetGroundBody(), b2Def.fixture);
			_bottomWall.m_reportBeginContact = true;
			_bottomWall.m_reportEndContact = true;
			
			_paddle = new Paddle();
			_paddle.physicsBody.SetTransform( new V2( AppSettings.instance.paddleStartX / PhysicsWorld.PhysScale, AppSettings.instance.paddleStartY / PhysicsWorld.PhysScale ), 0 );
			_paddle.visible = false;
						
			b2Def.mouseJoint.Initialize(_paddle.physicsBody, new V2( AppSettings.instance.paddleStartX / PhysicsWorld.PhysScale, AppSettings.instance.paddleStartY / PhysicsWorld.PhysScale ));
			b2Def.mouseJoint.maxForce = 10000.0 * _paddle.physicsBody.GetMass();
			b2Def.mouseJoint.dampingRatio = 0;
			b2Def.mouseJoint.frequencyHz = 5000;
			_mouseJoint = PhysicsWorld.CreateJoint(b2Def.mouseJoint) as b2MouseJoint;
			
			b2Def.lineJoint.Initialize( PhysicsWorld.GetGroundBody(), _paddle.physicsBody, _paddle.physicsBody.GetPosition(), new V2( 1.0, 0.0 ) );
			
			b2Def.lineJoint.lowerTranslation = -(AppSettings.instance.paddleExtentX - _paddle.width/2) / PhysicsWorld.PhysScale;
			b2Def.lineJoint.upperTranslation = (AppSettings.instance.paddleExtentX - _paddle.width/2) / PhysicsWorld.PhysScale;
			b2Def.lineJoint.enableLimit = true;
			
			_lineJoint = PhysicsWorld.CreateJoint(b2Def.lineJoint) as b2LineJoint;
			
			_brickMultiplierManager.initParams({ "timeout": AppSettings.instance.brickMultiplierTimeout, "maxMultiplier": AppSettings.instance.brickMultiplierMax });
			_paddleMultiplierManager.initParams( { "maxMultiplier": AppSettings.instance.paddleMultiplierMax } );
			
			PhysicsWorld.UpdateWorld();
						
			enterComplete();
		}//end enter()
				
		public function show():void
		{
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
		}//end showGameScreen()
		
		public function hide():void
		{
			this.removeEventListener(Event.RENDER, renderFrame);
		}//end showGameScreen()
		
		public function loadNextLevel(url:String):void
		{			
			_levelLoader = new Loader();
			_levelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, levelLoaded, false, 0, true);
			_levelLoader.load( new URLRequest(url) );
		}//end loadNextLevel()
		
		private function levelLoaded(e:Event = null):void
		{
			_levelLoader.removeEventListener(Event.COMPLETE, levelLoaded);
			
			parseLevel(_levelLoader.content as DisplayObjectContainer);
	
			dispatchEvent(new Event("levelLoaded"));
		}//end levelLoaded()
		
		private function parseLevel(a_level:DisplayObjectContainer):void
		{	
			_grid.clear();
			
			for ( var i:int = 0; i < a_level.numChildren; i++ )
			{
				var obj:DisplayObject = a_level.getChildAt(i);
				
				var brick:Brick;
				
				var className:String = getQualifiedClassName(obj);
				
				if ( className.search("Placeholder") >= 0 )
				{
					switch(className)
					{
						case "PlaceholderGem":
							_grid.addCollectable("bonus", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderExtend":
							_grid.addCollectable("extend", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderCatch":
							_grid.addCollectable("catch", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderLaser":
							_grid.addCollectable("laser", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderSuperLaser":
							_grid.addCollectable("superlaser", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderMultiball":
							_grid.addCollectable("multiball", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderInviciball":
							_grid.addCollectable("invinciball", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderDestructoball":
							_grid.addCollectable("destructoball", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
						case "PlaceholderExtraLife":
							_grid.addCollectable("extralife", uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
							break;
					}
					continue;
				}
				
				if ( className.search("Bonus") >= 0 )
				{
					var pb:Collectable = new Bonus();
					//pb.physicsBody.ApplyImpulse( new V2( 0, AppSettings.instance.defaultCollectableFallSpeed * pb.physicsBody.GetMass() ), pb.physicsBody.GetWorldCenter() );
					pb.physicsBody.SetTransform( new V2( (obj.x + obj.width / 2) / PhysicsWorld.PhysScale, (obj.y + obj.height / 2) / PhysicsWorld.PhysScale ), 0 );
			
					GameView.Collectables.append(pb);
					continue;
				}
				
				switch(getQualifiedClassName(obj))
				{
					case "MedBomb": case "SmBomb":
						brick = new Bomb(
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedLimp": case "SmLimp":
						brick = new LimpBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedTwoHit": case "SmTwoHit":
						brick = new MultiHitBrick(
							2,
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedThreeHit": case "SmThreeHit":
						brick = new MultiHitBrick(
							3,
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedMetal": case "SmMetal":
						brick = new UnbreakableBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "Portal":
						brick = new Portal( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedNanoAlive": case "SmNanoAlive":
						brick = new NanoBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
					case "MedNanoDead": case "SmNanoDead":
						brick = new NanoBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)],
							false);
						break;
					default:
						brick = new SimpleBrick( 
							uint(obj.width / AppSettings.instance.defaultTileWidth + 0.5),
							uint(obj.height / AppSettings.instance.defaultTileHeight  + 0.5),
							AppSettings.instance.brickAnimationSets[getQualifiedClassName(obj)]);
						break;
				}
			
				if ( brick )
					_grid.addGridObject(brick, uint(obj.x / AppSettings.instance.defaultTileWidth  + 0.5), uint(obj.y / AppSettings.instance.defaultTileHeight + 0.5));
			}
		}//end parseLevel()
		
		public function showPaddle():void
		{
			_paddle.visible = true;
			_paddle.switchAnimation(Paddle.PADDLE_INTRO);
		}//end showPaddle()
		
		public function hidePaddle():void
		{
			_paddle.switchAnimation(Paddle.PADDLE_OUTRO);
		}//end showPaddle()
		
		public function resetPaddle():void
		{		
			_paddle.activatePowerup(null);
			
			_lastUpdate = getTimer();
			
			_paused = false;
		}//end initializePaddle()
		
		public function newBall():void
		{			
			var ball:Ball = addBallAt();	
			_paddle.catchBall(ball);
			
			ball.showBall();
		}//end newBall()
		
		private function addBallAt(a_x:Number = 0, a_y:Number = 0):Ball
		{
			var ball:Ball = new Ball();
			
			ball.physicsBody.SetTransform( new V2( a_x / PhysicsWorld.PhysScale, a_y / PhysicsWorld.PhysScale ), 0 );
			
			_balls.append(ball);
			
			return ball;
		}//end resetBall()
		
		private function ballLost():void
		{
			_paddleMultiplierManager.finished = true;
			_brickMultiplierManager.finished = true;
			
			dispatchEvent(new Event("ballLost"));
		}//end ballLost()
		
		override public function exit():void
		{
			_grid = null;
			_paddle = null;
			
			exitComplete();
		}//end exit()
		
		public function setBackground(a_mc:MovieClip):void
		{
			_backgroundMC = a_mc;
		}//end setBackground()
		
		public function renderFrame(e:Event = null):void
		{			
			_gameScreen.bitmapData.lock();
			
			var go:GridObject;
			_gameScreen.bitmapData.draw(_backgroundMC);
			
			var obj:Object;
			
			var iter:SLLIterator = new SLLIterator(_grid.gridObjectList);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				var bmd:BitmapData = obj.currFrame;
				_gameScreen.bitmapData.copyPixels( bmd, bmd.rect, new Point(obj.x, obj.y), null, null, true );
			}
			
			iter = new SLLIterator(_balls);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				_gameScreen.bitmapData.copyPixels( obj.currFrame, obj.currFrame.rect, new Point( obj.x, obj.y ), null, null, true );
			}
			
			_gameScreen.bitmapData.copyPixels( _paddle.currFrame, _paddle.currFrame.rect, new Point( _paddle.x, _paddle.y ), null, null, true );
			
			iter = new SLLIterator(Collectables);
			while ( iter.hasNext() )
			{
				obj = iter.next();				
				_gameScreen.bitmapData.copyPixels( obj.currFrame, obj.currFrame.rect, new Point( obj.x, obj.y ), null, null, true );
			}
			
			iter = new SLLIterator(Bullets);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				_gameScreen.bitmapData.copyPixels( obj.currFrame, obj.currFrame.rect, new Point(obj.x, obj.y), null, null, true );
			}
			
			_gameScreen.bitmapData.unlock();
					
			//_gameScreen.bitmapData.copyPixels(_backBuffer, _gameScreen.bitmapData.rect, new Point());	
		}//end render()
		
		private function handleBallCollision(a_ball:b2Fixture, a_fixture:b2Fixture, a_point:V2):void
		{
			var v:int
			var node:SLLNode;
			var snd:MightySound;
			
			if ( a_fixture == _bottomWall )
			{
				 _balls.remove(a_ball.GetUserData());
				 a_ball.GetUserData().destroy();
			}
			else if ( a_fixture.GetFilterData().categoryBits == id_Wall )
			{
				v = uint(Math.random() * 3 + 1);
				
				snd = MightySoundManager.instance.getMightySoundByName("sfxWallCollision_" + v);
				if (snd) snd.play();
			}
			else if ( a_fixture.GetUserData() is Paddle )
			{
				if ( a_fixture.GetUserData().stickyMode && !a_fixture.GetUserData().occupied )
				{
					a_fixture.GetUserData().catchBall(a_ball.GetUserData() as Ball);
				}
				else
				{
					v = uint(Math.random() * 3 + 1);
				
					snd = MightySoundManager.instance.getMightySoundByName("sfxPaddleCollision_" + v);
					if (snd) snd.play();
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
				}
				
				if ( a_fixture.GetUserData().notifyHit( a_ball.GetUserData().damagePoints ) )
				{
					if ( _brickMultiplierManager.finished )
					{
						_multiplier.activateAction(BrickMultiplierManagerAction.NAME)
					}
					
					_brickMultiplierManager.increaseMultiplier();
					
					dispatchEvent( new ObjectEvent( "addPoints", { "basePoints": AppSettings.instance.brickPoints, "brickMult": _brickMultiplierManager.multiplier, "paddleMult": _paddleMultiplierManager.multiplier, "x": a_ball.GetUserData().x, "y": a_ball.GetUserData().y } ) );
				}
				else if ( a_fixture.GetUserData() is Portal )
				{
					if ( a_fixture.GetUserData().open )
					{
						var dist:V2 = a_ball.GetDistance(a_fixture);
						
						if ( dist.length() > 0.1 ) return;
						
						_paused = true;
			
						var vortex:PortalVortex = new PortalVortex(_gameScreen, a_fixture.GetUserData() as Portal);
						vortex.addEventListener(EmitterEvent.EMITTER_EMPTY, vortexComplete,	false, 0, true);						
						GameView.ParticleRenderer.addEmitter(vortex);
						vortex.start();
						
						hide();
							
						_gameScreen.bitmapData.fillRect(_gameScreen.bitmapData.rect, 0xFF000000);
					}
				}
				else
				{
					if ( !a_fixture.IsSensor() )
					{
						var vel:V2 = a_ball.GetBody().GetLinearVelocity();
						
						var angle:Number = Math.atan2(vel.x, vel.y);
						
						v = uint(Math.random() * 3 + 1);
				
						snd = MightySoundManager.instance.getMightySoundByName("sfxBallSparks_" + v);
						if (snd) snd.play();
					
						var emitter:ImpactSparks = new ImpactSparks(
							new Point( a_point.x * PhysicsWorld.PhysScale, a_point.y * PhysicsWorld.PhysScale ), 
							angle + Math.PI / 2
						);
						emitter.useInternalTick = false;
						emitter.addEventListener(EmitterEvent.EMITTER_EMPTY, 
						function(e:EmitterEvent):void {
							Emitter2D(e.currentTarget).stop();
							GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
							GameView.Emitters.remove(Emitter2D(e.currentTarget));
						},
						false, 0, true);						
						GameView.ParticleRenderer.addEmitter(emitter);
						GameView.Emitters.append(emitter);
						emitter.start();
					}
				}
			}
		}//end handleBallCollision()
		
		private function vortexComplete(e:EmitterEvent):void
		{
			Emitter2D(e.currentTarget).stop();
			GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
			
			dispatchEvent(new ObjectEvent("levelFinished", { "blocksRemaining": _grid.gridObjectList.size() } ));
		}//end vortexComplete()
		
		private function handleCollectableCollision(a_collectable:b2Fixture, a_fixture:b2Fixture):void
		{
			var ind:int;
			var node:SLLNode;
			var snd:MightySound;
			
			if ( a_fixture == _bottomWall )
			{
				Collectables.remove(a_collectable.GetUserData());
				a_collectable.GetUserData().destroy();
				return;
			}
			else if ( a_fixture.GetUserData() is Paddle )
			{
				Collectables.remove(a_collectable.GetUserData());
				
				snd = MightySoundManager.instance.getMightySoundByName("sfxCatchCollectable");
				if (snd) snd.play();
				
				var emitter:CollectionFizzle = new CollectionFizzle(a_fixture.GetUserData() as Paddle);
				emitter.useInternalTick = false;
				emitter.addEventListener(EmitterEvent.EMITTER_EMPTY,
				function(e:EmitterEvent):void {
					Emitter2D(e.currentTarget).stop();
					GameView.ParticleRenderer.removeEmitter(Emitter2D(e.currentTarget));
					GameView.Emitters.remove(Emitter2D(e.currentTarget));
				},
				false, 0, true);						
				GameView.ParticleRenderer.addEmitter(emitter);
				GameView.Emitters.append(emitter);
				emitter.start();				
				
				if ( a_collectable.GetUserData().actionName == "multiball" )
				{
					snd = MightySoundManager.instance.getMightySoundByName("sfxMultiballActivate");
					if (snd) snd.play();
					
					var obj:Object = _balls.getNodeAt(0).val;
					
					addBallAt(obj.x, obj.y);
					addBallAt(obj.x, obj.y);
				}
				else if ( a_collectable.GetUserData().actionName == "extralife" )
				{
					dispatchEvent(new Event("ballGained"));
				}
				else if ( a_collectable.GetUserData().actionName == "bonus" )
				{
					dispatchEvent(new ObjectEvent("addPoints", { "basePoints": 1000, "brickMult": 1, "paddleMult": 0, "x": a_collectable.GetUserData().x, "y": a_collectable.GetUserData().x } ));
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
				Bullets.remove(a_bullet.GetUserData());
				a_bullet.GetUserData().destroy();
			}
			else if ( a_fixture.GetUserData() is NanoBrick )
			{
				if ( a_fixture.GetUserData().alive )
				{
					Bullets.remove(a_bullet.GetUserData());
					a_fixture.GetUserData().notifyHit(1);
					a_bullet.GetUserData().destroy();
				}
			}
			else if ( a_fixture.GetUserData() is Portal )
			{
				return;
			}
			else if ( a_fixture.GetUserData() is Brick )
			{
				Bullets.remove(a_bullet.GetUserData());
				a_fixture.GetUserData().notifyHit(1);
				a_bullet.GetUserData().destroy();
			}
		}//end handleBulletCollision()
		
		private function handleBeamCollision(a_bullet:b2Fixture, a_fixture:b2Fixture):void
		{
			var ind:int;
			var node:SLLNode;
			
			if ( a_fixture.GetUserData() is NanoBrick )
			{
				if ( a_fixture.GetUserData().alive )
				{
					a_fixture.GetUserData().notifyHit(500);
				}
			}
			else if ( a_fixture.GetUserData() is Portal )
			{
				return;
			}
			else if ( a_fixture.GetUserData() is Brick )
			{
				a_fixture.GetUserData().notifyHit(500);
			}
		}//end handleBeamCollision()
		
		public function resetGame():void
		{
			//_paused = true;
			
			Contacts.clear();
			
			var iter:SLLIterator = new SLLIterator(Collectables);
			var obj:Object;
			while ( iter.hasNext() )
			{
				obj = iter.next();
				obj.destroy();
			}
			Collectables.clear();
			
			iter = new SLLIterator(Bullets);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				obj.destroy();
			}
			Bullets.clear();
			
			iter = new SLLIterator(_balls);
			while ( iter.hasNext() )
			{
				obj = iter.next();
				obj.destroy();
			}
			_balls.clear();
		}//end resetGame()
		
		override public function update():void
		{	
			var delta:Number = getTimer() - _lastUpdate;
			_lastUpdate = getTimer();
			
			if ( _paused ) return;			
			
			_brickMultiplierManager.update(delta);
			_paddleMultiplierManager.update(delta);
			
			if ( _balls.isEmpty() ) ballLost();
			
			UpdateMouseWorld();
			
			if ( Input.mouseDown ) _paddle.releaseBall();
			
			_mouseJoint.SetTarget(new V2(_mouseXWorldPhys, AppSettings.instance.paddleStartY / PhysicsWorld.PhysScale));
			
			_lineJoint.SetLimits( -(330 - _paddle.width / 2) / PhysicsWorld.PhysScale, (330 - _paddle.width / 2) / PhysicsWorld.PhysScale );
			
			PhysicsWorld.UpdateWorld(delta);
		
			var iter:SLLIterator = new SLLIterator(Contacts);
			while( iter.hasNext() )
			{
				var c:Object = iter.next();
				
				if ( c == null ) continue;
				
				Contacts.remove(c);
				
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
				
				if ( c.fixtureA.GetUserData() is Beam )
				{
					handleBeamCollision(c.fixtureA, c.fixtureB);
					continue;
				}
				
				if ( c.fixtureB.GetUserData() is Beam )
				{
					handleBeamCollision(c.fixtureB, c.fixtureA);
					continue;
				}
			}
			
			iter = new SLLIterator(Bullets);
			while( iter.hasNext() )
			{
				var obj:Object = iter.next();
				
				if ( obj is Beam )
				{
					if( !obj.physicsBody )
						Bullets.remove(obj);
				}
			}
			
			iter = new SLLIterator(Emitters);
			while ( iter.hasNext() )
			{
				iter.next().update(delta/1000);
			}
			
			if ( _grid.isEmpty() ) 
			{
				iter = new SLLIterator(_balls);
				while ( iter.hasNext() )
				{
					obj = iter.next();
					(obj as Ball).physicsBody.SetActive(false);
				}
				_balls.clear();
				dispatchEvent(new ObjectEvent("levelFinished", { "blocksRemaining": _grid.gridObjectList.size() }));
			}
			
			//if ( stage ) stage.invalidate();
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

import Box2DAS.Collision.AABB;
import Box2DAS.Collision.b2AABB;
import Box2DAS.Collision.b2Manifold;
import Box2DAS.Collision.b2WorldManifold;
import Box2DAS.Collision.Shapes.b2CircleShape;
import Box2DAS.Collision.Shapes.b2PolygonShape;
import Box2DAS.Common.b2Def;
import Box2DAS.Common.b2Transform;
import Box2DAS.Common.V2;
import Box2DAS.Common.XF;
import Box2DAS.Dynamics.b2Body;
import Box2DAS.Dynamics.b2ContactImpulse;
import Box2DAS.Dynamics.b2ContactListener;
import Box2DAS.Dynamics.b2Fixture;
import Box2DAS.Dynamics.Contacts.b2Contact;
import Box2DAS.Dynamics.Joints.b2DistanceJointDef;
import com.bored.games.breakout.objects.Ball;
import com.bored.games.breakout.objects.Beam;
import com.bored.games.breakout.objects.bricks.Brick;
import com.bored.games.breakout.objects.bricks.SimpleBrick;
import com.bored.games.breakout.objects.Bullet;
import com.bored.games.breakout.objects.collectables.Collectable;
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
		
		var point:V2 = wm.points[0];
		
		if ( contact.IsEnabled() ) 
		{			
			GameView.Contacts.append( new GameContact(fixtureA, fixtureB, point) );
		}
	}//end BeginContact()
	
	override public function EndContact(contact:b2Contact):void
	{
		//var obj:GameContact = new GameContact(contact.GetFixtureA(), contact.GetFixtureB());
		
		//GameView.Contacts.remove(obj);		
	}//end EndContact()
	
	override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
	{
		var fixtureA:b2Fixture = contact.GetFixtureA();
		var fixtureB:b2Fixture = contact.GetFixtureB();
		
		if (!(fixtureA.GetUserData() is Paddle && fixtureB.GetUserData() is Ball))
			return;
		
		var paddle:V2 = contact.GetFixtureA().GetBody().GetPosition();
		var ball:V2 = contact.GetFixtureB().GetBody().GetPosition();
		
		var ballXDiff:Number = ball.x - paddle.x;
		
		var extent:Number = (fixtureA.GetUserData().width / 2) / PhysicsWorld.PhysScale;
				
		/*
		var rect:AABB = new AABB();
		_paddleJoint.GetBodyB().GetFixtureList().m_shape.ComputeAABB(rect, new XF());
		*/
			
		var ballXRatio:Number = ballXDiff / (extent * 2);
		
		if (ballXRatio < -0.95) ballXRatio = -0.95;
		if (ballXRatio > 0.95) ballXRatio = 0.95;
		
		var wm:b2WorldManifold = new b2WorldManifold();
		contact.GetWorldManifold(wm);
		
		var point:V2 = wm.points[0];
		
		var bodyB:b2Body = contact.GetFixtureB().GetBody();
		var vB:V2 = bodyB.GetLinearVelocityFromWorldPoint(point);
		
		var newVel:V2 = new V2();
		newVel.copy(vB);
		newVel.x = ballXRatio * AppSettings.instance.paddleReflectionMultiplier;
		
		var solvedYVel:Number = Math.sqrt(Math.abs(vB.lengthSquared() - (newVel.x * newVel.x)));
		
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
				//contact.SetSensor(true);
			}
		}
		
		if (!(fixtureA.GetUserData() is Paddle && fixtureB.GetUserData() is Ball))
			return;
		
		var positionPaddle:V2 = fixtureA.GetBody().GetPosition();
		var positionBall:V2 = fixtureB.GetBody().GetPosition();
		
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
	public var point:V2;
	
	public function GameContact( a_fixtureA:b2Fixture, a_fixtureB:b2Fixture, a_point:V2 = null )
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
	override public function remove(x:Object):Boolean
	{	
		var s:int = size();
		if (s == 0) return false;
		
		var node0:SLLNode = head;
		var node1:SLLNode = head.next;
		
		var NULL:Dynamic = null;
		
		while (node1 != null)
		{
			if (node1.val.equals(x))
			{
				if (node1 == tail) tail = node0;
				var node2:SLLNode = node1.next;
				node0.next = node2;
				
				node1.next = null;
				node1.val = NULL;
				__nullify(node1);
				_size--;
				
				node1 = node2;
			}
			else
			{
				node0 = node1;
				node1 = node1.next;
			}
		}
		
		if (head.val.equals(x))
		{
			var head1:SLLNode = head.next;
			
			head.val = NULL;
			__nullify(head);
			head.next = null;
			
			head = head1;
			
			if (head == null) tail = null;
			
			_size--;
		}
		
		return size() < s;
	}
}//end ContactLL