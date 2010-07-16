package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BrickMultiplierManagerAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.BrickMultiplierManagerAction";
		
		public function BrickMultiplierManagerAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
	
		override public function initParams(a_params:Object):void 
		{
		
		}//end initParams()
		
		override public function startAction():void 
		{
			this.finished = false;
		}//end startAction()
		
		override public function update(a_time:Number):void 
		{
			
		}//end update()
				
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				
			}
			else
			{
				
			}
			
		}//end set finished() 
		
	}//end BrickMultiplierManagerAction

}//end package