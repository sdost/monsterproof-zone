package com.bored.games.breakout.states.controllers
{
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.breakout.states.views.HUDView;
	import com.bored.games.input.Input;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameplayController extends StateViewController
	{
		private var _gameView:StateView;
		private var _hudView:StateView;
		private var _input:Input;
		
		private var _updateTimer:Timer;
		
		public function GameplayController(a_container:MovieClip) 
		{			
			_input = new Input(a_container);
			
			_gameView = new GameView();
			_hudView = new HUDView();
			
			super([_gameView, _hudView], a_container);
		}//end constructor()
		
		public function startGame():void
		{
			_updateTimer = new Timer(16);
			_updateTimer.addEventListener(TimerEvent.TIMER, timerUpdate, false, 0, true);
			_updateTimer.start();
			
			(_gameView as GameView).loadNextLevel();
		}//end startGame()
		
		private function timerUpdate(e:Event):void
		{
			this.update();
			
			Input.update();
		}//end timerUpdate()
		
	}//end GameplayController

}//end package