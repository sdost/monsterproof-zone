package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.objects.hud.GameOverDisplay;
	import com.bored.games.breakout.objects.hud.GameStartDisplay;
	import com.bored.games.breakout.objects.hud.LivesDisplay;
	import com.bored.games.breakout.objects.hud.ReadyDisplay;
	import com.bored.games.breakout.objects.hud.ScoreDisplay;
	import com.bored.games.breakout.objects.hud.TimerDisplay;
	import com.bored.games.breakout.profiles.LevelList;
	import com.bored.games.breakout.profiles.LevelProfile;
	import com.bored.games.breakout.profiles.UserProfile;
	import com.jac.fsm.StateView;
	import com.sven.text.BitmapFont;
	import com.sven.text.BitmapFontFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.utils.getTimer;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.energyEasing.Quadratic;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class HUDView extends StateView
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', fontFamily='Enter Sansman')]
		private static var fontCls:Class;
		
		private static var bitmapFont:BitmapFont = BitmapFontFactory.generateBitmapFont(new fontCls());
		
		private var _lastUpdate:Number;
		
		private var _presentEmitter:Emitter2D;
		private var _transitionEmitter:Emitter2D;
		private var _fadeEmitter:Emitter2D;
		
		private var _livesDisp:LivesDisplay;
		private var _timeDisp:TimerDisplay;
		private var _scoreDisp:ScoreDisplay;
		
		private var _gameStart:GameStartDisplay;
		private var _gameOver:GameOverDisplay;
		private var _ready:ReadyDisplay;
		
		private var _backBuffer:BitmapData;
		private var _mainBuffer:BitmapData;
		
		private var _time:int;
		
		private var _bmp:Bitmap;
		
		private var _loader:URLLoader;
		
		private var _paused:Boolean;
		
		private var _renderer:PixelRenderer;
		
		public function HUDView() 
		{
			super();
			
			_paused = true;
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
								
			AppSettings.instance.userProfile = new UserProfile();			
			
			_livesDisp = new LivesDisplay(0, bitmapFont);
			_timeDisp = new TimerDisplay(0, bitmapFont);
			_scoreDisp = new ScoreDisplay(0, bitmapFont);
			
			_timeDisp.x = stage.stageWidth / 2;
			
			_backBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_mainBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			
			_bmp = new Bitmap(_mainBuffer);
			addChild(_bmp);
			
			stage.invalidate();
			
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
			
			_lastUpdate = getTimer();
			
			_renderer = new PixelRenderer(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_renderer.addFilter( new BlurFilter( 5, 5, 5 ) );
			_renderer.addFilter( new ColorMatrixFilter( [ 1, 0, 0, 0, 0,
														  0, 1, 0, 0, 0,
														  0, 0, 1, 0, 0,
														  0, 0, 0, 0.95, 0 ] ) );
			addChild(_renderer);
			
			_paused = false;
		}//end addedToStageHandler()
		
		public function showGameStart():void
		{
			_presentEmitter = new Emitter2D();
			
			_presentEmitter.counter = new Blast(10000);
			
			_presentEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToTransition );
			_presentEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			_presentEmitter.addInitializer( new ColorInit( 0xFFFFFF00, 0xFFFFCC66 ) );
			_presentEmitter.addInitializer( new Lifetime( 2.0 ) );
			_presentEmitter.addInitializer( new Position( new BitmapDataZone(readyBMP, stage.stageWidth / 2 - readyBMP.width / 2, stage.stageHeight / 2 - readyBMP.height / 2) ) );
			
			_presentEmitter.addAction( new Age() );
			_renderer.addEmitter(_presentEmitter);
			
			_transitionEmitter = new Emitter2D();
			_transitionEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToFade );
			_transitionEmitter.addInitializer( new Lifetime( 0.9 ) );
			
			_transitionEmitter.addAction( new Age( Quadratic.easeOut ) );
			_transitionEmitter.addAction( new TweenToZone( new BitmapDataZone(gameStartBMP, stage.stageWidth / 2 - gameStartBMP.width / 2, stage.stageHeight / 2 - gameStartBMP.height / 2) ) );
			_renderer.addEmitter(_transitionEmitter);
			
			_fadeEmitter = new Emitter2D();
			_fadeEmitter.addInitializer( new Lifetime( 1.0, 3.0 ) );
			
			_fadeEmitter.addAction( new Age( Quadratic.easeIn ) );
			_fadeEmitter.addAction( new Fade() );
			_fadeEmitter.addAction( new Move() );
			//_fadeEmitter.addAction( new Accelerate( 0, 100 ) );
			_renderer.addEmitter(_fadeEmitter);
				
			_presentEmitter.start();
			_transitionEmitter.start();
			_fadeEmitter.start();
		}//end showGameStart()
		
		private function moveToTransition(e:ParticleEvent):void
		{
			e.particle.revive();
			_transitionEmitter.addExistingParticles( [ e.particle ], true );
			_transitionEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
		}//end moveToTransition()
		
		private function moveToFade(e:ParticleEvent):void
		{
			e.particle.revive();
			_fadeEmitter.addExistingParticles( [ e.particle ], true );
			_fadeEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
		}//end moveToFade()
		
		private function removeEmitter(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener(EmitterEvent.EMITTER_EMPTY, removeEmitter);
			_renderer.removeEmitter(Emitter2D(e.currentTarget));
			
			if ( e.currentTarget == _fadeEmitter )
				dispatchEvent(new Event(Event.COMPLETE));
		}//end trasitionComplete()
		
		public function get readyBMP():BitmapData
		{
			var ready:ReadyDisplay = new ReadyDisplay(bitmapFont);
			
			var bmd:BitmapData = new BitmapData(ready.width * 4, ready.height * 4, true, 0x00000000)
			ready.draw(bmd, 0xFFFFFF, 4);
			
			return bmd;
		}//end get GameOverBMP()
		
		public function get gameStartBMP():BitmapData
		{
			var gameStart:GameStartDisplay = new GameStartDisplay(bitmapFont);
						
			var bmd:BitmapData = new BitmapData(gameStart.width * 4, gameStart.height * 4, true, 0x00000000)
			gameStart.draw(bmd, 0xFFFFFF, 4);
			
			return bmd;
		}//end get GameStartBMP()
		
		public function get gameOverBMP():BitmapData
		{
			var gameOver:GameOverDisplay = new GameOverDisplay(bitmapFont);
			
			var bmd:BitmapData = new BitmapData(gameOver.width, gameOver.height, true, 0x00000000)
			gameOver.draw(bmd, 0xFFFFFF);
			
			return bmd;
		}//end get GameOverBMP()
		
		override public function enter():void 
		{			
			_loader = new URLLoader( new URLRequest(AppSettings.instance.levelListURL) );
			_loader.addEventListener(Event.COMPLETE, levelListComplete, false, 0, true);
		}//end enter()
		
		private function levelListComplete(e:Event):void
		{
			AppSettings.instance.levelList = new LevelList(XML(_loader.data));
			
			AppSettings.instance.currentLevelInd = 0;
			
			AppSettings.instance.currentLevel = AppSettings.instance.levelList.getLevel(AppSettings.instance.currentLevelInd);
			
			AppSettings.instance.userProfile.time = AppSettings.instance.currentLevel.timeLimit;
			
			enterComplete();
		}//end levelListComplete()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		override public function update():void 
		{
			if (_paused) return;
			
			var delta:Number = getTimer() - _lastUpdate;
			
			_lastUpdate = getTimer();
			
			AppSettings.instance.userProfile.decreaseTime(delta);
			
			_scoreDisp.score = AppSettings.instance.userProfile.score;
			_timeDisp.time = AppSettings.instance.userProfile.time;
			_livesDisp.lives = AppSettings.instance.userProfile.lives;
			
			_livesDisp.update(delta);
			_timeDisp.update(delta);
			_scoreDisp.update(delta);
			
			if (stage) stage.invalidate();
		}//end update()
		
		public function renderFrame(e:Event):void
		{
			_backBuffer.fillRect(_backBuffer.rect, 0x00000000);
			
			_scoreDisp.x = stage.stageWidth - _scoreDisp.width;
			
			_livesDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
			_timeDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
			_scoreDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
						
			_mainBuffer.copyPixels(_backBuffer, _backBuffer.rect, new Point());
		}//end draw()
		
	}//end HUDView

}//end package