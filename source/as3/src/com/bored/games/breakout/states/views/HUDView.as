package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.objects.hud.PauseDisplay;
	import com.bored.games.breakout.objects.hud.PopupText;
	import com.bored.games.breakout.objects.hud.GameOverDisplay;
	import com.bored.games.breakout.objects.hud.GameStartDisplay;
	import com.bored.games.breakout.objects.hud.LivesDisplay;
	import com.bored.games.breakout.objects.hud.ReadyDisplay;
	import com.bored.games.breakout.objects.hud.ResultsDisplay;
	import com.bored.games.breakout.objects.hud.ScoreDisplay;
	import com.bored.games.breakout.objects.hud.TimerDisplay;
	import com.bored.games.breakout.profiles.LevelList;
	import com.bored.games.breakout.profiles.LevelProfile;
	import com.bored.games.breakout.profiles.UserProfile;
	import com.jac.fsm.StateView;
	import com.sven.text.BitmapFont;
	import com.sven.text.BitmapFontFactory;
	import com.sven.text.GameWord;
	import com.sven.utils.AppSettings;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLIterator;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.utils.getTimer;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.Counter;
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
	import org.flintparticles.twoD.zones.RectangleZone;
	
	/**
	 * Dispatched when game start has finished showing
	 *
 	 */
	[Event(name = 'gameStartComplete', type = 'flash.events.Event')]
	
	[Event(name = 'gameOverComplete', type = 'flash.events.Event')]
	
	[Event(name = 'resultsComplete', type = 'flash.events.Event')]
	
	/**
	 * ...
	 * @author sam
	 */
	public class HUDView extends StateView
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.BreakoutFont')]
		private static var fontCls:Class;
		
		private static var bitmapFont:BitmapFont = BitmapFontFactory.generateBitmapFont(new fontCls());
		
		private var _lastUpdate:Number;
		
		private var _presentEmitter:Emitter2D;
		private var _holdEmitter:Emitter2D;
		private var _transitionEmitter:Emitter2D;
		private var _holdEmitter2:Emitter2D;
		private var _fadeEmitter:Emitter2D;
		
		private var _livesDisp:LivesDisplay;
		private var _timeDisp:TimerDisplay;
		private var _scoreDisp:ScoreDisplay;
		private var _resultsDisp:ResultsDisplay;
		private var _pauseDisp:PauseDisplay;
		
		private var _gameStart:GameStartDisplay;
		private var _gameOver:GameOverDisplay;
		private var _ready:ReadyDisplay;
		
		private var _popups:SLL;
		
		private var _backBuffer:BitmapData;
		private var _mainBuffer:BitmapData;
		
		private var _time:int;
		
		private var _bmp:Bitmap;
		
		private var _loader:URLLoader;
		
		private var _paused:Boolean;
		
		private var _renderer:PixelRenderer;
		
		private var _hideHUD:Boolean;
		private var _hideResults:Boolean;
		
		public function HUDView() 
		{
			super();
			
			_hideHUD = true;
			_hideResults = true;
			
			_paused = true;
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
								
			AppSettings.instance.userProfile = new UserProfile();			
			
			_livesDisp = new LivesDisplay(0, bitmapFont);
			_timeDisp = new TimerDisplay(0, bitmapFont);
			_scoreDisp = new ScoreDisplay(0, bitmapFont);
			
			_popups = new SLL();
			
			_timeDisp.x = stage.stageWidth / 2;
			
			_backBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_mainBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			
			_bmp = new Bitmap(_mainBuffer);
			addChild(_bmp);
			
			stage.invalidate();
			
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
						
			_renderer = new PixelRenderer(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_renderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			_renderer.addFilter( new ColorMatrixFilter( [ 1, 0, 0, 0, 0,
														  0, 1, 0, 0, 0,
														  0, 0, 1, 0, 0,
														  0, 0, 0, 0.95, 0 ] ) );
														  
			_lastUpdate = getTimer();
			
			_paused = false;
		}//end addedToStageHandler()
		
		public function showGameStart():void
		{
			addChild(_renderer);
			
			_presentEmitter = new Emitter2D();
			
			_presentEmitter.counter = new Blast(5000);
			_presentEmitter.useInternalTick = false;
			_presentEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToHold );
			_presentEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			_presentEmitter.addInitializer( new ColorInit( 0xFFFFFF00, 0xFFFFFFFF ) );
			_presentEmitter.addInitializer( new Lifetime( 1.0 ) );
			_presentEmitter.addInitializer( new Position( new RectangleZone( 0, 0, stage.stageWidth, stage.stageHeight ) ) );
			
			_presentEmitter.addAction( new Age( Quadratic.easeOut ) );
			_presentEmitter.addAction( new TweenToZone( new BitmapDataZone(readyBMP, stage.stageWidth / 2 - readyBMP.width / 2, stage.stageHeight / 2 - readyBMP.height / 2) ) );
			_renderer.addEmitter(_presentEmitter);
			
			_holdEmitter = new Emitter2D();
			
			_holdEmitter.useInternalTick = false;
			_holdEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToTransition );	
			_holdEmitter.addInitializer( new Lifetime( 1.0 ) );
			
			_holdEmitter.addAction( new Age() );
			_renderer.addEmitter(_holdEmitter);
			
			_transitionEmitter = new Emitter2D();
			_transitionEmitter.useInternalTick = false;
			_transitionEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToHold2 );			
			_transitionEmitter.addInitializer( new Lifetime( 0.9 ) );
			
			_transitionEmitter.addAction( new Age( Quadratic.easeOut ) );
			_transitionEmitter.addAction( new TweenToZone( new BitmapDataZone(gameStartBMP, stage.stageWidth / 2 - gameStartBMP.width / 2, stage.stageHeight / 2 - gameStartBMP.height / 2) ) );
			_renderer.addEmitter(_transitionEmitter);
			
			_holdEmitter2 = new Emitter2D();
			
			_holdEmitter2.useInternalTick = false;
			_holdEmitter2.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToFade );	
			_holdEmitter2.addInitializer( new Lifetime( 1.0 ) );
			
			_holdEmitter2.addAction( new Age() );
			_renderer.addEmitter(_holdEmitter2);
			
			_fadeEmitter = new Emitter2D();
			_fadeEmitter.useInternalTick = false;
			_fadeEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, gameStartComplete );			
			_fadeEmitter.addInitializer( new Lifetime( 0.5 ) );
		
			_fadeEmitter.addAction( new Age() );
			_fadeEmitter.addAction( new Fade() );
			//_fadeEmitter.addAction( new Accelerate( 0, 100 ) );
			_renderer.addEmitter(_fadeEmitter);
				
			_presentEmitter.start();
		}//end showGameStart()
		
		public function showGameOver():void
		{
			/*
			_presentEmitter = new Emitter2D();
			_presentEmitter.useInternalTick = false;
			_presentEmitter.counter = new Blast(5000);
			
			_presentEmitter.addEventListener( ParticleEvent.PARTICLE_DEAD, moveToFade );
			_presentEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			_presentEmitter.addInitializer( new ColorInit( 0xFFFFFF00, 0xFFFFCC66 ) );
			_presentEmitter.addInitializer( new Lifetime( 3.0 ) );
			_presentEmitter.addInitializer( new Position( new RectangleZone( 0, 0, stage.stageWidth, stage.stageHeight ) ) );
			
			_presentEmitter.addAction( new Age( Quadratic.easeInOut ) );
			_presentEmitter.addAction( new TweenToZone( new BitmapDataZone(gameOverBMP, stage.stageWidth / 2 - gameOverBMP.width / 2, stage.stageHeight / 2 - gameOverBMP.height / 2) ) );
			_renderer.addEmitter(_presentEmitter);
			
			_fadeEmitter = new Emitter2D();
			_fadeEmitter.useInternalTick = false;
			_fadeEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, gameOverComplete );	
			_fadeEmitter.addInitializer( new Lifetime( 1.0, 3.0 ) );
			
			_fadeEmitter.addAction( new Age( Quadratic.easeIn ) );
			_fadeEmitter.addAction( new Fade() );
			_fadeEmitter.addAction( new Move() );
			//_fadeEmitter.addAction( new Accelerate( 0, 100 ) );
			_renderer.addEmitter(_fadeEmitter);
				
			_presentEmitter.start();
			*/
		}//end showGameStart()
		
		private function moveToHold(e:ParticleEvent):void
		{
			e.particle.revive();
			_holdEmitter.addExistingParticles( [ e.particle ], true );
			_holdEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			if( !_holdEmitter.running ) _holdEmitter.start();
		}//end moveToTransition()
		
		private function moveToHold2(e:ParticleEvent):void
		{
			e.particle.revive();
			_holdEmitter2.addExistingParticles( [ e.particle ], true );
			_holdEmitter2.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			if( !_holdEmitter2.running ) _holdEmitter2.start();
		}//end moveToTransition()
		
		private function moveToTransition(e:ParticleEvent):void
		{
			e.particle.revive();
			_transitionEmitter.addExistingParticles( [ e.particle ], true );
			_transitionEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			if( !_transitionEmitter.running ) _transitionEmitter.start();
		}//end moveToTransition()
		
		private function moveToFade(e:ParticleEvent):void
		{
			e.particle.revive();
			_fadeEmitter.addExistingParticles( [ e.particle ], true );
			_fadeEmitter.addEventListener( EmitterEvent.EMITTER_EMPTY, removeEmitter );
			if( !_fadeEmitter.running ) _fadeEmitter.start();
		}//end moveToFade()
		
		private function removeEmitter(e:Event):void
		{
			Emitter2D(e.currentTarget).stop();
			Emitter2D(e.currentTarget).removeEventListener(EmitterEvent.EMITTER_EMPTY, removeEmitter);
			_renderer.removeEmitter(Emitter2D(e.currentTarget));
		}//end trasitionComplete()
		
		private function gameStartComplete(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener(EmitterEvent.EMITTER_EMPTY, gameStartComplete);
			
			_presentEmitter.killAllParticles();
			_presentEmitter = null;
			
			_holdEmitter.killAllParticles();
			_holdEmitter = null;
			
			_transitionEmitter.killAllParticles();
			_transitionEmitter = null;
			
			_holdEmitter2.killAllParticles();
			_holdEmitter2 = null;
			
			_fadeEmitter.killAllParticles();
			_fadeEmitter = null;
			
			Emitter2D.defaultParticleFactory.clearAllParticles();
			
			removeChild(_renderer);
			
			dispatchEvent(new Event("gameStartComplete"));
		}//end gameStartComplete()
		
		private function gameOverComplete(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener(EmitterEvent.EMITTER_EMPTY, gameOverComplete);
			dispatchEvent(new Event("gameOverComplete"));
		}//end gameStartComplete()
		
		public function get readyBMP():BitmapData
		{
			var ready:ReadyDisplay = new ReadyDisplay(bitmapFont);
			
			var bmd:BitmapData = new BitmapData(ready.width * 3, ready.height * 3, true, 0x00000000)
			ready.draw(bmd, 0xFFFFFF, 3);
			
			return bmd;
		}//end get GameOverBMP()
		
		public function get gameStartBMP():BitmapData
		{
			var gameStart:GameStartDisplay = new GameStartDisplay(bitmapFont);
						
			var bmd:BitmapData = new BitmapData(gameStart.width * 3, gameStart.height * 3, true, 0x00000000)
			gameStart.draw(bmd, 0xFFFFFF, 3);
			
			return bmd;
		}//end get GameStartBMP()
		
		public function get gameOverBMP():BitmapData
		{
			var gameOver:GameOverDisplay = new GameOverDisplay(bitmapFont);
			
			var bmd:BitmapData = new BitmapData(gameOver.width * 3, gameOver.height * 3, true, 0x00000000)
			gameOver.draw(bmd, 0xFFFFFF, 3);
			
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
			
			enterComplete();
		}//end levelListComplete()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		public function addPopupText(a_base:int, a_brickMult:int, a_paddleMult:int, a_x:Number, a_y:Number):void
		{
			var popup:PopupText = new PopupText( new String(a_base * a_brickMult + (5 * a_paddleMult)), bitmapFont, a_brickMult / 10);
			popup.x = a_x;
			popup.y = a_y;
			popup.centered = true;
			
			_popups.append(popup);
		}//end addPopupText()
		
		public function showResults(a_type:int, a_finalScore:int, a_timeRemaining:int, a_blocksRemaining:int):void
		{
			_resultsDisp = new ResultsDisplay(a_type, a_finalScore, a_timeRemaining, a_blocksRemaining, bitmapFont);
			_hideResults = false;
		}//end showResults()
		
		public function set scoreDisp(a_num:Number):void
		{
			_scoreDisp.score = a_num;
		}//end set scoreDisp()
		
		public function set timerDisp(a_num:Number):void
		{
			_timeDisp.time = a_num;
		}//end set scoreDisp()
		
		public function set livesDisp(a_num:Number):void
		{
			_livesDisp.lives = a_num;
		}//end set scoreDisp()
		
		public function pause(a_bool:Boolean):void
		{
			_paused = a_bool;
			_pauseDisp = new PauseDisplay(bitmapFont);
		}//end pause();
		
		override public function update():void 
		{
			var delta:Number = getTimer() - _lastUpdate;
			_lastUpdate = getTimer();
			
			if (_paused) return;
			
			_livesDisp.update();
			_timeDisp.update();
			_scoreDisp.update();
			
			var iter:SLLIterator = new SLLIterator(_popups);
			while ( iter.hasNext() )
			{
				var obj:Object = iter.next();
				obj.update();
				if (obj.complete) _popups.remove(obj);
			}
			
			if (_resultsDisp) 
			{
				_resultsDisp.update();
				if (_resultsDisp.complete)
				{
					dispatchEvent(new Event("resultsComplete"));
					_hideResults = true;
					_resultsDisp = null;
				}
			}
			
			var deltaSec:Number = delta / 1000;
			
			if ( _presentEmitter ) _presentEmitter.update(deltaSec);
			if ( _holdEmitter ) _holdEmitter.update(deltaSec);
			if ( _transitionEmitter ) _transitionEmitter.update(deltaSec);
			if ( _holdEmitter2 ) _holdEmitter2.update(deltaSec);
			if ( _fadeEmitter ) _fadeEmitter.update(deltaSec);
		
			//if (stage) stage.invalidate();
		}//end update()
		
		public function showHUD():void
		{
			_hideHUD = false;
		}//end showHUD()
		
		public function hideHUD():void
		{
			_hideHUD = true;
		}//end hideHUD()
		
		public function renderFrame(e:Event = null):void
		{	
			_mainBuffer.lock();
			
			_mainBuffer.fillRect(_backBuffer.rect, 0x00000000);
			
			if ( !_hideHUD ) {
				_scoreDisp.x = stage.stageWidth - _scoreDisp.width;
				
				_livesDisp.draw(_mainBuffer, 0xFFFFFF, 1.0);
				_timeDisp.draw(_mainBuffer, 0xFFFFFF, 1.0);
				_scoreDisp.draw(_mainBuffer, 0xFFFFFF, 1.0);
				
				var iter:SLLIterator = new SLLIterator(_popups);
				while ( iter.hasNext() )
				{
					var obj:Object = iter.next();
					obj.draw(_mainBuffer, 0xFFFFFF);
				}
			}
			
			if ( !_hideResults ) {
				_resultsDisp.draw(_mainBuffer);
			}
			
			if ( _paused )
			{
				_pauseDisp.draw(_mainBuffer);
			}
						
			_mainBuffer.unlock();
			
			//_mainBuffer.copyPixels(_backBuffer, _backBuffer.rect, new Point());
		}//end draw()
		
	}//end HUDView

}//end package