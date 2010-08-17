package com.bored.games.breakout.states.controllers 
{
	import com.bored.games.breakout.states.views.LoadBackgroundsView;
	import com.bored.games.breakout.states.views.LoadBrickAssetsView;
	import com.bored.games.breakout.states.views.LoadingBarView;
	import com.bored.games.breakout.states.views.LoadSoundsView;
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
	public class LoadingController extends StateViewController
	{		
		private var _loadingBar:LoadingBarView;
		private var _brickLoader:StateView;
		private var _backgroundLoader:StateView;
		private var _soundLoader:StateView;
		
		private var _brickProgress:Number;
		private var _backgroundProgress:Number;
		private var _soundProgress:Number;
		
		private var _totalLoaded:int;
		
		public function LoadingController(a_container:MovieClip) 
		{						
			_loadingBar = new LoadingBarView();
			_brickLoader = new LoadBrickAssetsView();
			_backgroundLoader = new LoadBackgroundsView();
			_soundLoader = new LoadSoundsView();
			
			_brickProgress = 0;
			_backgroundProgress = 0;
			_soundProgress = 0;
			
			_totalLoaded = 1;
			
			_brickLoader.addEventListener(ProgressEvent.PROGRESS, loadingProgress, false, 0, true);
			_brickLoader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_backgroundLoader.addEventListener(ProgressEvent.PROGRESS, loadingProgress, false, 0, true);
			_backgroundLoader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_soundLoader.addEventListener(ProgressEvent.PROGRESS, loadingProgress, false, 0, true);
			_soundLoader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			
			super([_loadingBar, _brickLoader, _backgroundLoader, _soundLoader], a_container);
		}//end constructor()
		
		private function loadingProgress(e:ProgressEvent):void
		{
			if ( e.currentTarget == _brickLoader )
			{
				_brickProgress = e.bytesLoaded / e.bytesTotal;
			}
			
			if ( e.currentTarget == _backgroundLoader )
			{
				_backgroundProgress = e.bytesLoaded / e.bytesTotal;
			}
			
			if ( e.currentTarget == _soundLoader )
			{
				_soundProgress = e.bytesLoaded / e.bytesTotal;
			}
						
			var perc:Number = (_brickProgress + _backgroundProgress + _soundProgress) / 3;
			
			_loadingBar.progress = perc;
		}//end loadingProgress()
		
		private function loadingComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
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
			_soundLoader = null;
			_loadingBar = null;
		}//end exitComplete()
		
	}//end LoadingController

}//end package