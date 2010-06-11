package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.jac.fsm.StateView;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameView extends StateView
	{
		private var _grid:Grid;
		
		public function GameView() 
		{
			super();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
		}//end addedToStageHandler()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		override public function reset():void
		{
			_grid = new Grid();
		}//end reset()
		
		override public function enter():void
		{						
			_grid.addGridObject(new GridObject(), 0, 0);
			
			enterComplete();
		}//end enter()
		
		override public function exit():void
		{
			_grid = null;
			
			exitComplete();
		}//end exit()
		
		override public function update():void
		{
			if (_grid) _grid.update();
			
			
		}//end update()
		
	}//end GameView

}//end package