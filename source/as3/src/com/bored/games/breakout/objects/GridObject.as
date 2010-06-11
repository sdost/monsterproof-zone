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
		private var _gridWidth:int;
		private var _gridHeight:int;
		
		protected var _dispObj:DisplayObject;		
		
		public function GridObject() 
		{
			super();
			
			_gridWidth = 1;
			_gridHeight = 1;
			
			initializeActions();
			
			_dispObj = new Bitmap( ImageFactory.getBitmapDataByQualifiedName( AppSettings.instance.defaultBlockBitmap, AppSettings.instance.defaultBlockWidth, AppSettings.instance.defaultBlockHeight ) );
		}//end constructor()
		
		private function initializeActions():void
		{
			addAction(new RemoveGridObjectAction(this));
		}//end initializeActions
		
		public function get gridWidth():int
		{
			return _gridWidth;
		}//end get gridWidth()
		
		public function get gridHeight():int
		{
			return _gridHeight;
		}//end get gridHeight()
	
		override public function update(t:Number = 0):void
		{
			super.update(t);
		}//end update()
		
		public function get display():DisplayObject
		{
			return _dispObj;
		}//end get display()
				
	}//end GridObject

}//end package