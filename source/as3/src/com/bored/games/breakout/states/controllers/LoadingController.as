package com.bored.games.breakout.states.controllers 
{
	import com.bored.games.breakout.states.LoadBackgroundsState;
	import com.bored.games.breakout.states.LoadBrickAssetsState;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LoadingController extends StateViewController
	{		
		private var _brickLoader:StateView;
		private var _backgroundLoader:StateView;
		
		public function LoadingController(a_container:MovieClip) 
		{
			_brickLoader = new LoadBrickAssetsState();
			_backgroundLoader = new LoadBackgroundsState();
			
			super([_brickLoader, _backgroundLoader], a_container);
		}//end constructor()
		
	}//end LoadingController

}//end package