package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoveGridObjectAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.RemoveGridObjectAction";
		
		public function RemoveGridObjectAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			
		}//end initParams()

		override public function startAction():void
		{
			var grid:Grid = (_gameElement as GridObject).grid;
			
			if ( grid ) 
			{
				grid.removeGridObject( _gameElement as GridObject );
			}
			
			this._finished = true;
		}//end startAction()

		override public function update(a_time:Number):void
		{
			
		}//end update()
		
	}//end RemoveGridObjectAction

}//end package