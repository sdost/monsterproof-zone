package com.bored.games.breakout.states.controllers
{
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.breakout.states.views.HUDView;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameplayController extends StateViewController
	{
		private var _gameView:StateView;
		private var _hudView:StateView;
		
		public function GameplayController(a_container:MovieClip) 
		{			
			_gameView = new GameView();
			_hudView = new HUDView();
			
			super([_gameView, _hudView], a_container);
			
			this.container.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}//end constructor()
		
		private function onEnterFrame(e:Event):void
		{
			this.update();
		}//end onEnterFrame()
		
	}//end GameplayController

}//end package