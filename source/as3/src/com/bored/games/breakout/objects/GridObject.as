package com.bored.games.breakout.objects 
{
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GridObject extends GameElement
	{
		protected var _grid:Grid;
		
		protected var _gridX:uint;
		protected var _gridY:uint;
		
		protected var _gridWidth:uint;
		protected var _gridHeight:uint;
		
		public function GridObject(a_width:int = 1, a_height:int = 1) 
		{
			super();
			
			_gridWidth = a_width;
			_gridHeight = a_height;
			
			initializeActions();
		}//end constructor()
		
		protected function initializeActions():void
		{
			addAction(new RemoveGridObjectAction(this));
		}//end initializeActions
		
		public function get gridWidth():uint
		{
			return _gridWidth;
		}//end get gridWidth()
		
		public function get gridHeight():uint
		{
			return _gridHeight;
		}//end get gridHeight()
		
		
		public function get gridX():uint
		{
			return _gridX;
		}//end get gridX()
		
		public function get gridY():uint
		{
			return _gridY;
		}//end get gridY()
		
		public function get grid():Grid
		{
			return _grid;
		}//end get grid()
		
		public function addToGrid(a_grid:Grid, a_x:uint, a_y:uint):void
		{
			_grid = a_grid;
			_gridX = a_x;
			_gridY = a_y;
			
			this.x = this.gridX * AppSettings.instance.defaultTileWidth + _grid.x;
			this.y = this.gridY * AppSettings.instance.defaultTileHeight + _grid.y;
		}//end addToGrid()
		
		public function removeFromGrid():void
		{
			_grid = null;
			_gridX = 0;
			_gridY = 0;
			
			this.x = 0;
			this.y = 0;
		}//end addToGrid()
		
		public function destroy():void
		{
			removeAction(RemoveGridObjectAction.NAME);
		}//end destroy()
		
	}//end GridObject

}//end package