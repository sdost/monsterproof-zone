package com.bored.games.breakout.states.controllers 
{
	import com.bored.games.breakout.states.views.LevelListView;
	import com.bored.games.breakout.states.views.LoadBackgroundsView;
	import com.bored.games.breakout.states.views.LoadBrickAssetsView;
	import com.bored.games.breakout.states.views.LoadSoundsView;
	import com.bored.games.breakout.states.views.TitleView;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LevelSelectController extends StateViewController
	{	
		//[Event(name = 'levelSelect', type = 'flash.events.Event')]
		
		private var _levelList:StateView;
		
		public function LevelSelectController(a_container:MovieClip) 
		{						
			_levelList = new LevelListView();
			_levelList.addEventListener(LevelListView.LEVEL_SELECTED, levelSelect, false, 0, true);
			
			super([_levelList], a_container);
		}//end constructor()
		
		private function levelSelect(e:Event):void
		{
			dispatchEvent(new Event('levelSelect'));
		}//end startGame()
	
		/*
		private function continueGame(e:Event):void
		{
			
		}//end startGame()
		
		private function showOptions(e:Event):void
		{
			
		}//end startGame()
		*/
				
		override protected function exitComplete(e:StateEvent):void 
		{			
			super.exitComplete(e);
			
			_levelList = null;
		}//end exitComplete()
		
	}//end LevelSelectController

}//end package