package com.bored.games.breakout.states.controllers
{
	import com.bored.games.breakout.objects.hud.ResultsDisplay;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.breakout.states.views.HUDView;
	import com.bored.games.breakout.states.views.TitleView;
	import com.bored.games.input.Input;
	import com.inassets.events.ObjectEvent;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[Event(name = 'returnToLevelSelect', type = 'flash.events.Event')]
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameplayController extends StateViewController
	{
		private var _period:Number;
		private var _beforeTime:int = 0;
		private var _afterTime:int = 0;
		private var _timeDiff:int = 0;
		private var _sleepTime:int = 0;
		private var _overSleepTime:int = 0;
		private var _excess:int = 0;
		
		private var _gameView:StateView;
		private var _hudView:StateView;
		private var _input:Input;
		
		private var _paused:Boolean;
		private var _timerRunning:Boolean;
		
		private var _updateTimer:Timer;
		
		private var _timeLeft:Number;
		private var _lastUpdate:Number;
		
		private var _theme:MightySound;
		
		private var _callback:Function;
		
		public function GameplayController(a_container:MovieClip) 
		{	
			_period = 1000 / a_container.stage.frameRate;
			
			_input = new Input(a_container);
			
			_paused = true;
			_timerRunning = false;
			
			a_container.stage.quality = StageQuality.BEST;
			
			_gameView = new GameView();
			_hudView = new HUDView();
			
			_gameView.addEventListener("levelLoaded", levelLoaded, false, 0, true);
			_hudView.addEventListener("gameStartComplete", gameStartComplete, false, 0, true);
			
			super([_gameView, _hudView], a_container);
		}//end constructor()
		
		private function startGame():void
		{
			container.stage.quality = StageQuality.LOW;
			
			container.addEventListener(Event.ENTER_FRAME, frameUpdate, false, 0, true);
			
			container.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
									
			AppSettings.instance.currentLevel = AppSettings.instance.levelList.getLevel(AppSettings.instance.currentLevelInd);
			
			(_gameView as GameView).loadNextLevel(AppSettings.instance.currentLevel.levelDataURL);
			(_gameView as GameView).setBackground(AppSettings.instance.backgrounds[AppSettings.instance.currentLevel.backgroundIndex]);
		}//end startGame()
		
		override protected function notifyEnterComplete(e:StateEvent):void 
		{
			super.notifyEnterComplete(e);
			
			startGame();
		}//end notifyEnterComplete()
		
		private function levelLoaded(e:Event):void
		{
			_paused = false;
			
			(_hudView as HUDView).show();
			(_hudView as HUDView).showGameStart();
			(_gameView as GameView).show();
			(_gameView as GameView).resetPaddle();
			(_gameView as GameView).showPaddle();
		}//end levelLoaded()
		
		private function gameStartComplete(e:Event):void
		{
			_theme = MightySoundManager.instance.getMightySoundByName("musLevelTheme");
			_theme.infiniteLoop = true;
			if (_theme) _theme.play();
			
			(_gameView as GameView).newBall();
			
			_timeLeft = AppSettings.instance.currentLevel.timeLimit;
			_lastUpdate = getTimer();
			
			_timerRunning = true;
			
			(_hudView as HUDView).showHUD();
			
			(_gameView as GameView).addEventListener("ballLost", ballLost, false, 0, true);
			(_gameView as GameView).addEventListener("levelFinished", levelFinished, false, 0, true);
			(_gameView as GameView).addEventListener("addPoints", addUserPoints, false, 0, true);
			(_gameView as GameView).addEventListener("ballGained", ballGained, false, 0, true);
		}//end gameStartComplete()
		
		private function restart():void
		{
			container.removeEventListener(Event.ENTER_FRAME, frameUpdate);	
			
			container.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			(_gameView as GameView).hide();
			(_gameView as GameView).resetGame();
			
			startGame();
		}//end restart()
		
		private function returnToLevelSelect():void
		{
			container.removeEventListener(Event.ENTER_FRAME, frameUpdate);	
			
			container.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			(_gameView as GameView).hide();
			(_gameView as GameView).resetGame();
			(_hudView as HUDView).pause(true);			
			
			dispatchEvent(new Event('returnToLevelSelect'));
		}//end restart()
		
		private function proceedToWinScreen():void
		{
			container.removeEventListener(Event.ENTER_FRAME, frameUpdate);	
			
			container.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			(_gameView as GameView).hide();
			(_gameView as GameView).resetGame();
			(_hudView as HUDView).pause(true);			
			
			dispatchEvent(new Event('proceedToWinScreen'));
		}//end restart()
		
		private function resultsComplete(e:Event):void
		{
			(_hudView as HUDView).removeEventListener("resultsComplete", resultsComplete);
			
			_callback();
		}//end resultsComplete()
		
		private function ballLost(e:Event):void
		{
			(_gameView as GameView).resetPaddle(); 
			AppSettings.instance.userProfile.decrementLives();
			
			if (AppSettings.instance.userProfile.lives > 0)
			{
				(_gameView as GameView).newBall();
			}
			else
			{
				endGame();
			}
		}//end ballLost()
		
		private function ballGained(e:Event):void
		{
			AppSettings.instance.userProfile.incrementLives();
		}//end ballGained()
		
		private function addUserPoints(e:ObjectEvent):void
		{
			AppSettings.instance.userProfile.addPoints( e.obj.basePoints * e.obj.brickMult + (5 * e.obj.paddleMult) );
			
			(_hudView as HUDView).addPopupText( e.obj.basePoints, e.obj.brickMult, e.obj.paddleMult, e.obj.x, e.obj.y );
		}//end ballGained()
		
		private function endGame():void
		{
			_timerRunning = false;
			
			if (_theme) _theme.stop();
			
			(_gameView as GameView).removeEventListener("ballLost", ballLost);
			(_gameView as GameView).removeEventListener("levelFinished", levelFinished);
			(_gameView as GameView).removeEventListener("addPoints", addUserPoints);
			(_gameView as GameView).removeEventListener("ballGained", ballGained);
			
			(_hudView as HUDView).hideHUD();
			(_hudView as HUDView).showResults(ResultsDisplay.GAME_OVER, AppSettings.instance.userProfile.score, _timeLeft, 0);
			(_hudView as HUDView).addEventListener("resultsComplete", resultsComplete, false, 0, true);
			
			_callback = returnToLevelSelect;
			
			AppSettings.instance.userProfile.reset();
		}//end endGame()
		
		private function advanceLevel():void
		{
			(_gameView as GameView).resetGame();
			
			AppSettings.instance.currentLevelInd++;
			
			AppSettings.instance.userProfile.unlockLevel(AppSettings.instance.currentLevelInd);
			
			if (AppSettings.instance.currentLevelInd >= AppSettings.instance.levelList.levelCount)
			{
				proceedToWinScreen();
			}
			else
			{
				AppSettings.instance.currentLevel = AppSettings.instance.levelList.getLevel(AppSettings.instance.currentLevelInd);
			
				(_gameView as GameView).loadNextLevel(AppSettings.instance.currentLevel.levelDataURL);
				(_gameView as GameView).setBackground(AppSettings.instance.backgrounds[AppSettings.instance.currentLevel.backgroundIndex]);
			}
		}//end advanceLevel()
				
		private function levelFinished(e:ObjectEvent = null):void
		{	
			if (_theme) _theme.stop();
			
			(_gameView as GameView).hidePaddle();			
			(_gameView as GameView).removeEventListener("ballLost", ballLost);
			(_gameView as GameView).removeEventListener("levelFinished", levelFinished);
			(_gameView as GameView).removeEventListener("addPoints", addUserPoints);
			(_gameView as GameView).removeEventListener("ballGained", ballGained);
			
			var blockRemaining:int = e == null ? 0 : e.obj.blocksRemaining;
			
			(_hudView as HUDView).hideHUD();
			(_hudView as HUDView).showResults(ResultsDisplay.LEVEL_COMPLETE, AppSettings.instance.userProfile.score, _timeLeft, blockRemaining);
			(_hudView as HUDView).addEventListener("resultsComplete", resultsComplete, false, 0, true);
			
			_callback = advanceLevel;
			
			_timerRunning = false;
		}//end gridEmpty()
				
		private function frameUpdate(e:Event):void
		{	
			updateInputState();
			
			this.update();
			container.stage.invalidate();
			
			var delta:Number = getTimer() - _lastUpdate;
			_lastUpdate = getTimer();
			
			if (_timerRunning && _timeLeft > 0)
			{
				_timeLeft -= delta;
				
				(_hudView as HUDView).scoreDisp = AppSettings.instance.userProfile.score;
				(_hudView as HUDView).timerDisp = _timeLeft;
				(_hudView as HUDView).livesDisp = AppSettings.instance.userProfile.lives;
				
				if ( _timeLeft <= 0 )
				{
					endGame();
				}
			}
			
			(_hudView as HUDView).pause(_paused);
			(_gameView as GameView).pause(_paused);
			MightySoundManager.instance.pause(_paused);
				
			if (_paused)
			{
				if (Input.mouseDown) 
				{
					_paused = false;			
					_timerRunning = !_paused;
				}
			}
			else
			{
				_timerRunning = !_paused;
			}
		}//end frameUpdate()
		
		private function updateInputState():void
		{
			Input.update();
			
			_paused = _paused || Input.mouseLeftStage;
		}//end UpdateInputState()
		
		private function keyUp(e:KeyboardEvent):void
		{
			switch(e.charCode)
			{
				case ("s".charCodeAt(0)):
					if ( _paused )
					{
						levelFinished();
						_paused = false;
					}
					break;
				case ("p".charCodeAt(0)):
					_paused = !_paused;
					_timerRunning = !_paused;
					break;
				case ("m".charCodeAt(0)):
					MightySoundManager.instance.mute = !MightySoundManager.instance.mute;
					break;
				case ("q".charCodeAt(0)):
					if ( _paused )
					{
						returnToLevelSelect();
					}
					break;
			}
		}//end keyUp()
		
	}//end GameplayController

}//end package