package com.bored.games.breakout.states.controllers 
{
	import com.bored.games.breakout.states.views.LoadBackgroundsView;
	import com.bored.games.breakout.states.views.LoadBrickAssetsView;
	import com.bored.games.breakout.states.views.LoadSoundsView;
	import com.bored.games.breakout.states.views.TitleView;
	import com.bored.games.breakout.states.views.WinView;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class WinController extends StateViewController
	{	
		[Event(name = 'returnToLevelSelect', type = 'flash.events.Event')]
		
		private var _winScreen:StateView;
		
		public function WinController(a_container:MovieClip) 
		{		
			a_container.stage.quality = StageQuality.HIGH;
			
			_winScreen = new WinView();
			_winScreen.addEventListener(WinView.WIN_COMPLETE, winComplete, false, 0, true);
			
			super([_winScreen], a_container);
		}//end constructor()
		
		private function winComplete(e:Event):void
		{
			dispatchEvent(new Event('returnToLevelSelect'));
		}//end startGame()
						
		override protected function exitComplete(e:StateEvent):void 
		{			
			super.exitComplete(e);
			
			_winScreen = null;
		}//end exitComplete()
		
	}//end WinController

}//end package