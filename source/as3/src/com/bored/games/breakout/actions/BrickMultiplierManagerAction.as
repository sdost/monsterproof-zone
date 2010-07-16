package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BrickMultiplierManagerAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.BrickMultiplierManagerAction";
		
		private var _multiplierTimeout:int;
		
		private var _startTime:int;
		
		private var _multplier:int;
		
		public function BrickMultiplierManagerAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
	
		override public function initParams(a_params:Object):void 
		{
			_multiplierTimeout = a_params.timeout;
		}//end initParams()
		
		override public function startAction():void 
		{			
			_multplier = 0;
			
			this.finished = false;
		}//end startAction()
		
		public function increaseMultiplier():void
		{
			_multplier++;
			
			_startTime = getTimer();
		}//end increaseMultiplier()
		
		override public function update(a_time:Number):void 
		{
			if ( (getTimer() - _startTime) > _multiplierTimeout )
			{				
				this.finished = true;
			}
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