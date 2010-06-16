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
		
		override public function initParams(a_params:Object):void
		{
			
		}//end initParams()

		override public function startAction():void
		{
			
		}//end startAction()

		override public function update(a_time:Number):void
		{
			
		}//end update()
		
	}//end RemoveGridObjectAction

}//end package