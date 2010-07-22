package com.bored.games.breakout.states.controllers 
{
	import com.bored.games.breakout.states.views.LoadBackgroundsView;
	import com.bored.games.breakout.states.views.LoadBrickAssetsView;
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
	public class LoadingController extends StateViewController
	{		
		private var _brickLoader:StateView;
		private var _backgroundLoader:StateView;
		
		private var _totalLoaded:int;
		
		public function LoadingController(a_container:MovieClip) 
		{
			_brickLoader = new LoadBrickAssetsView();
			_backgroundLoader = new LoadBackgroundsView();
			
			_totalLoaded = 0;
			
			_brickLoader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_backgroundLoader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			
			super([_brickLoader, _backgroundLoader], a_container);
		}//end constructor()
		
		private function loadingComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, loadingComplete);
			
			_totalLoaded++;
			
			if ( _totalLoaded == _subObjList.length )
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}//end loadingComplete()
		
		override protected function exitComplete(e:StateEvent):void 
		{
			super.exitComplete(e);
			
			_brickLoader = null;
			_backgroundLoader = null;
		}//end exitComplete()
		
	}//end LoadingController

}//end package