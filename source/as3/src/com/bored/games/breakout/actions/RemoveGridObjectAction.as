package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoveGridObjectAction extends Action
	{
		public static var NAME:String = "com.bored.games.breakout.actions.RemoveGridObjectAction";
		
		public function RemoveGridObjectAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		public function initParams(a_params:Object):void
		{
			
		}//end initParams()

		public function startAction():void
		{
			
		}//end startAction()

		public function update(a_time:Number):void
		{
			
		}//end update()
		
	}//end RemoveGridObjectAction

}//end package