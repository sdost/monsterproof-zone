package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Grid extends GameElement
	{
		public static const GridWidth:int = AppSettings.instance.defaultGridWidth;
		public static const GridHeight:int = AppSettings.instance.defaultGridHeight;
		public static const Shift:int = 7; // 2^7 == 128
		
		private var _gridObjectList:Vector.<GridObject>;
		private var _grid:Vector.<int>;
		
		public function Grid() 
		{
			super();
			
			_gridObjectList = new Vector.<GridObject>();
		
			generate();			
		}//end constructor()
		
		private function generate():void
		{
			_grid = new Vector.<int>(100 << Shift, true);
			
			for ( var x:int = 0; x < GridWidth; x++)
			{
				for ( var y:int = 0; y < GridHeight; y++)
				{
					_grid[(x << Shift) | y] = 0;
				}
			}
		}//end generate()
		
		public function addGridObject( a_obj:GridObject, a_x:int, a_y:int ):Boolean
		{			
			var rightBounds:int = a_x + a_obj.gridWidth;
			var bottomBounds:int = a_y + a_obj.gridHeight;
			
			if ( a_x < 0 ) return false;
			
			if ( a_y < 0 ) return false;
			
			if ( rightBounds > GridWidth ) return false;
			
			if ( bottomBounds > GridHeight ) return false;
			
			var ind:uint = _gridObjectList.push(a_obj);
			
			for ( var x:int = a_x; x < rightBounds; x++ )
			{
				for ( var y:int = a_y; y < bottomBounds; y++ )
				{
					_grid[(x << Shift) | y] = ind;
				}
			}
			
			return true;
		}//end addGridObject()
		
		public function retrieve( a_x:int, a_y:int ):int
		{
			return _grid[(x << Shift) | y];
		}//end retrieve()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			for each( var obj:GridObject in _gridObjectList )
			{
				obj.update(t);
			}
		}//end update()
		
	}//end Grid

}//end package