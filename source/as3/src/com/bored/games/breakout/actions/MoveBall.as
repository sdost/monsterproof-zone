package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.objects.GameElement;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MoveBall extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.MoveBall";
		
		private var _vx:Number;
		private var _vy:Number;
		
		private var _x0:Number;
		private var _y0:Number;
				
		public function MoveBall(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);			
		}//end constructor()

		public function set vx(a_vx:Number):void
		{
			_vx = a_vx;
		}//end set vx()
		
		public function set vy(a_vy:Number):void
		{
			_vy = a_vy;
		}//end set vy()
		
		public function get vx():Number
		{
			return _vx;
		}//end get vx()
		
		public function get vy():Number
		{
			return _vy;
		}//end get vy()
		
		override public function startAction():void
		{
			_finished = false;
			
			_x0 = (_gameElement as Ball).x;
			_y0 = (_gameElement as Ball).y;
		}//end startAction()

		override public function update(a_time:Number):void
		{			
			var x:Number = (_gameElement as Ball).x + _vx;
			var y:Number = (_gameElement as Ball).y + _vy;
			
			(_gameElement as Ball).moveTo(x, y);
		}//end update()
		
	}//end MoveBall

}//end package