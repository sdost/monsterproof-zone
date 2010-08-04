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
		
		private var _multiplier:int;
		private var _maxMultiplier:int;
		
		public function BrickMultiplierManagerAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			_multiplier = 1;
		}//end constructor()
	
		override public function initParams(a_params:Object):void 
		{			
			_multiplierTimeout = a_params.timeout;
			_maxMultiplier = a_params.maxMultiplier;
		}//end initParams()
		
		override public function startAction():void 
		{			
			_multiplier = 1;
			
			this.finished = false;
		}//end startAction()
		
		public function increaseMultiplier():void
		{
			_multiplier++;
			
			if ( _multiplier > _maxMultiplier )
				_multiplier = _maxMultiplier;
			
			_startTime = getTimer();
		}//end increaseMultiplier()
		
		public function get maxMultiplier():int
		{
			return _maxMultiplier;
		}//end get maxMultiplier()
		
		public function get multiplier():int
		{
			return _multiplier;
		}//end get multiplier()
		
		override public function update(a_time:Number):void 
		{
			if ( (a_time - _startTime) > _multiplierTimeout )
			{				
				this.finished = true;
			}
		}//end update()
				
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				_multiplier = 1;
			}
			
		}//end set finished() 
		
	}//end BrickMultiplierManagerAction

}//end package