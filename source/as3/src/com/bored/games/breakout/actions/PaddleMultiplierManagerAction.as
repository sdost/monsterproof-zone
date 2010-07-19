package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PaddleMultiplierManagerAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.PaddleMultiplierManagerAction";
		
		private var _multiplierMax:int;
		
		private var _multiplier:int;
		
		public function PaddleMultiplierManagerAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
	
		override public function initParams(a_params:Object):void 
		{
			_multiplierMax = a_params.maxMultiplier;
		}//end initParams()
		
		override public function startAction():void 
		{
			_multiplier = 1;
			
			this.finished = false;
		}//end startAction()
		
		public function increaseMultiplier():void
		{
			_multiplier++;
			
			if ( _multiplier > _multiplierMax )
				_multiplier = _multiplierMax;
		}//end increaseMultiplier()
		
		public function get multiplier():int
		{
			return _multiplier;
		}//end get multiplier()
		
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
		
	}//end PaddleMultiplierManagerAction

}//end package