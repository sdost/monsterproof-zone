package com.bored.games.breakout.states.controllers
{
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.breakout.states.views.HUDView;
	import com.jac.fsm.StateView;
	import com.jac.fsm.StateViewController;
	import com.yogurt3d.presets.renderers.trianglesort.RendererTriangleSort;
	import com.yogurt3d.Yogurt3D;
	import flash.display.MovieClip;
	
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
			Yogurt3D.defaultSetup(700, 550);
			
			Yogurt3D.defaultContext.renderer = new RendererTriangleSort();
			Yogurt3D.defaultCamera.setProjectionPerspective( 50.0, 700.0 / 550.0, 1.0, 400.0 );
			Yogurt3D.defaultViewport.setViewport( 0.0, 0.0, 700.0, 550.0 );
			Yogurt3D.defaultCamera.transformation.positionZWrtParent = 150.0;
			
			a_container.addChild(Yogurt3D.defaultViewport);
			
			_gameView = new GameView();
			_hudView = new HUDView();
			
			super([_gameView, _hudView], a_container);
		}//end constructor()
		
	}//end GameplayController

}//end package