package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sam
	 */
	public class TileSet extends GameElement
	{
		private var _tiles:Vector.<BitmapData>;
		
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		public function TileSet( a_bmp:Bitmap, a_tileWidth:uint, a_tileHeight:uint ) 
		{
			super();
			
			_tiles = new Vector.<BitmapData>();	
			_tileWidth = a_tileWidth;
			_tileHeight = a_tileHeight;
			
			/*
			if ( a_bmp.bitmapData.width % a_tileWidth == 0 || a_bmp.bitmapData.height % a_tileHeight == 0 )
				throw new Error("bmp data dimensions must be an even multiple of the tile width and height.");
			*/
			
			for ( var i:int = 0; i <= a_bmp.bitmapData.height; )
			{				
				for ( var j:int = 0; j <= a_bmp.bitmapData.width; )
				{
					//trace("i, j --> [" + i + ", " + j + "]");
					
					var bmd:BitmapData = new BitmapData(_tileWidth, _tileHeight);
					bmd.copyPixels(a_bmp.bitmapData, new Rectangle( j, i, _tileWidth, _tileHeight ), new Point());
					
					_tiles.push( bmd );
					
					j += _tileWidth;
				}
				
				i += _tileHeight;
			}
		}//end constructor()
		
		public function loadTile( a_ind:int ):BitmapData
		{
			return _tiles[a_ind];
		}//end loadTile()
		
		public function get tileWidth():uint
		{
			return _tileWidth;
		}//end tileWidth()
		
		public function get tileHeight():uint
		{
			return _tileHeight;
		}//end tileHeight()
		
	}//end TileSet

}//end package