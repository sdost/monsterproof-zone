package com.bored.games.breakout.states.controllers
{
	import away3dlite.events.Loader3DEvent;
	import com.bored.games.breakout.objects.hud.ResultsDisplay;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.breakout.states.views.HUDView;
	import com.bored.games.input.Input;
	import com.inassets.events.ObjectEvent;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameplayController extends StateViewController
	{
		private var _gameView:StateView;
		private var _hudView:StateView;
		private var _input:Input;
		
		private var _running:Boolean;
		
		private var _updateTimer:Timer;
		
		private var _timeLeft:Number;
		private var _lastUpdate:Number;
		
		private var _callback:Function;
		
		public function GameplayController(a_container:MovieClip) 
		{			
			_input = new Input(a_container);
			
			_running = false;
			
			_gameView = new GameView();
			_hudView = new HUDView();
			
			_gameView.addEventListener("levelLoaded", levelLoaded, false, 0, true);
			
			_hudView.addEventListener("gameStartComplete", gameStartComplete, false, 0, true);
			_hudView.addEventListener("gameOverComplete", gameOverComplete, false, 0, true);
			
			super([_gameView, _hudView], a_container);
		}//end constructor()
		
		public function startGame():void
		{
			_updateTimer = new Timer(16);
			_updateTimer.addEventListener(TimerEvent.TIMER, timerUpdate, false, 0, true);
			_updateTimer.start();
			
			AppSettings.instance.currentLevel = AppSettings.instance.levelList.getLevel(AppSettings.instance.currentLevelInd);
			
			(_gameView as GameView).loadNextLevel(AppSettings.instance.currentLevel.levelDataURL);
			(_gameView as GameView).setBackground(AppSettings.instance.backgrounds[AppSettings.instance.currentLevel.backgroundIndex]);
		}//end startGame()
		
		private function levelLoaded(e:Event):void
		{
			(_hudView as HUDView).showGameStart();
			(_gameView as GameView).resetPaddle();
		}//end levelLoaded()
		
		private function gameStartComplete(e:Event):void
		{
			(_gameView as GameView).newBall();
			_timeLeft = AppSettings.instance.currentLevel.timeLimit;
			_lastUpdate = getTimer();
			
			_running = true;
			
			(_hudView as HUDView).showHUD();
			
			(_gameView as GameView).addEventListener("ballLost", ballLost, false, 0, true);
			(_gameView as GameView).addEventListener("levelFinished", levelFinished, false, 0, true);
			(_gameView as GameView).addEventListener("addPoints", addUserPoints, false, 0, true);
			(_gameView as GameView).addEventListener("ballGained", ballGained, false, 0, true);
		}//end gameStartComplete()
		
		private function gameOverComplete(e:Event):void
		{
			_updateTimer.stop();
			_updateTimer.removeEventListener(TimerEvent.TIMER, timerUpdate);
			_updateTimer = null;
			
			startGame();
		}//end gameOverComplete()
		
		private function resultsComplete(e:Event):void
		{
			(_hudView as HUDView).removeEventListener("resultsComplete", resultsComplete);
			
			AppSettings.instance.currentLevelInd++;
			
			if (AppSettings.instance.currentLevelInd >= AppSettings.instance.levelList.levelCount)
			{
				AppSettings.instance.currentLevelInd = 0;
			}
			
			AppSettings.instance.currentLevel = AppSettings.instance.levelList.getLevel(AppSettings.instance.currentLevelInd);
			
			(_gameView as GameView).loadNextLevel(AppSettings.instance.currentLevel.levelDataURL);
			(_gameView as GameView).setBackground(AppSettings.instance.backgrounds[AppSettings.instance.currentLevel.backgroundIndex]);
			
			if ( _callback != null ) _callback();
		}//end resultsComplete()
		
		private function ballLost(e:Event):void
		{
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
			AppSettings.instance.userProfile.addPoints( e.obj.basePoints * e.obj.brickMult * e.obj.paddleMult );
			
			(_hudView as HUDView).addPopupText( e.obj.basePoints, e.obj.brickMult, e.obj.paddleMult, e.obj.x, e.obj.y );
		}//end ballGained()
		
		private function endGame():void
		{
			(_gameView as GameView).removeEventListener("ballLost", ballLost);
			(_gameView as GameView).removeEventListener("levelFinished", levelFinished);
			(_gameView as GameView).removeEventListener("addPoints", addUserPoints);
			(_gameView as GameView).removeEventListener("ballGained", ballGained);
			
			(_hudView as HUDView).hideHUD();
			(_hudView as HUDView).showResults(ResultsDisplay.GAME_OVER, AppSettings.instance.userProfile.score, _timeLeft, 0);
			
			_callback = null;
			
			_running = false;
			
			(_gameView as GameView).resetGame();
			
			//AppSettings.instance.userProfile.reset();
		}//end endGame()
				
		private function levelFinished(e:ObjectEvent):void
		{
			(_gameView as GameView).removeEventListener("ballLost", ballLost);
			(_gameView as GameView).removeEventListener("levelFinished", levelFinished);
			(_gameView as GameView).removeEventListener("addPoints", addUserPoints);
			(_gameView as GameView).removeEventListener("ballGained", ballGained);
			
			(_hudView as HUDView).hideHUD();
			(_hudView as HUDView).showResults(ResultsDisplay.LEVEL_COMPLETE, AppSettings.instance.userProfile.score, _timeLeft, e.obj.blocksRemaining);
			(_hudView as HUDView).addEventListener("resultsComplete", resultsComplete, false, 0, true);
			
			_callback = e.obj.callback;
			
			_running = false;
		}//end gridEmpty()
				
		private function timerUpdate(e:Event):void
		{
			this.update();
			
			Input.update();
			
			if (_running)
			{
				var delta:Number = getTimer() - _lastUpdate;
				_lastUpdate = getTimer();
				_timeLeft -= delta;
				
				(_hudView as HUDView).scoreDisp = AppSettings.instance.userProfile.score;
				(_hudView as HUDView).timerDisp = _timeLeft;
				(_hudView as HUDView).livesDisp = AppSettings.instance.userProfile.lives;
				
				if ( _timeLeft <= 0 )
				{
					endGame();
				}
			}
		}//end timerUpdate()
		
	}//end GameplayController

}//end package