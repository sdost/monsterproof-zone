package com.bored.games.breakout.objects.bricks 
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.sven.animation.AnimationController;
	import com.sven.animation.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Portal extends Brick
	{
		// Animation States
		public static const PORTAL_CLOSED:String = "portal_closed";
		public static const PORTAL_OPEN:String = "portal_open";
		public static const PORTAL_LOOP:String = "portal_loop";
		
		private var _animController:AnimationController;
		
		private var _open:Boolean;
		
		private var _sndLoop:MightySound;
		
		public function Portal(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
			
			_animatedSprite = _animationSet.getAnimation(PORTAL_CLOSED);
			
			_animController = new AnimationController(_animatedSprite);
			
			this.hitPoints = 9999;
			
			_open = false;
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override protected function initializePhysics():void
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = this.gridWidth * AppSettings.instance.defaultTileWidth;
			var b2Height:Number = this.gridHeight * AppSettings.instance.defaultTileHeight;
			
			var b2X:Number = this.gridX * AppSettings.instance.defaultTileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * AppSettings.instance.defaultTileHeight + b2Height / 2;			
			
			b2Def.polygon.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2, new V2( b2X / PhysicsWorld.PhysScale, b2Y / PhysicsWorld.PhysScale ) );
			
			/*
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Brick;
			filter.maskBits = GameView.id_Ball;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Brick;
			b2Def.fixture.filter.maskBits = GameView.id_Ball;
			b2Def.fixture.density = 0.0;
			b2Def.fixture.friction = 0.0;
			b2Def.fixture.restitution = 0.0;
			b2Def.fixture.userData = this;
			b2Def.fixture.isSensor = true;
			
			_brickFixture = b2Def.fixture.create(_grid.gridBody);
		}//end initializePhysics()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animController.update(t);
		}//end update()
		
		public function openPortal():void
		{
			if ( !_open )
			{	
				_open  = true;
				
				var snd:MightySound = MightySoundManager.instance.getMightySoundByName("sfxPortalOpen");
				if (snd) snd.play();
				
				_animatedSprite = _animationSet.getAnimation(PORTAL_OPEN)
			
				_animController = new AnimationController(_animatedSprite);
				_animController.addEventListener(AnimationController.ANIMATION_COMPLETE, animationComplete, false, 0, true);
			}
		}//end openPortal()
		
		public function get open():Boolean
		{
			return _open;
		}//end get open()
		
		override public function notifyHit(a_damage:int):Boolean
		{			
			return false;
		}//end notifyHit()
		
		override public function get currFrame():BitmapData
		{
			return _animController.currFrame;
		}//end currFrame()
		
		private function animationComplete(e:Event):void
		{
			_animController.removeEventListener(AnimationController.ANIMATION_COMPLETE, animationComplete);
			
			_sndLoop = MightySoundManager.instance.getMightySoundByName("sfxPortalLoop");
			if (_sndLoop)
			{
				_sndLoop.infiniteLoop = true;
				_sndLoop.play();
			}
			
			_animatedSprite = _animationSet.getAnimation(PORTAL_LOOP);
			_animController.setAnimation(_animatedSprite, true);
		}//end animationComplete()
		
		override public function destroy():void 
		{			
			super.destroy();
		}//end destroy()
		
	}//end Portal

}//end package