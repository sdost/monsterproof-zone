package com.bored.games.breakout.objects 
{
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.objects.GameElement;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GridObject extends GameElement
	{
		private var _gridSize:Vector3D;
		
		public function GridObject() 
		{
			super();
			
			_gridSize = new Vector3D(1, 1, 1);
		}//end constructor()
		
		private function initializeActions():void
		{
			addAction(new RemoveGridObjectAction(this));
		}//end initializeActions
	
		override public function update(t:Number = 0):void
		{
			super.update(t);
		}//end update()
				
	}//end GridObject

}//end package