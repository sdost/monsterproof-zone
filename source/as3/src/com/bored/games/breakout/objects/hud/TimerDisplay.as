package com.bored.games.breakout.objects.hud 
{
	import com.sven.text.BitmapFont;
	import com.sven.text.GameChar;
	import com.sven.text.GameWord;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class TimerDisplay extends GameWord
	{		
		private var _timeRemaining:Number;
		
		private var _minutes:int;
		private var _seconds:int;
		
		public function TimerDisplay(a_time:Number, a_font:BitmapFont) 
		{
			_timeRemaining = a_time;
						
			_minutes = (_timeRemaining % (1000 * 60 * 60)) / (1000 * 60);
			_seconds = ((_timeRemaining % (1000 * 60 * 60)) % (1000 * 60)) / 1000;
			
			super(_minutes + ":" + ((_seconds < 10) ? "0" : "") + _seconds, a_font);
		}//end constructor()
		
		public function set time(a_time:Number):void
		{
			_timeRemaining = a_time;
			
			_minutes = (_timeRemaining % (1000 * 60 * 60)) / (1000 * 60);
			_seconds = ((_timeRemaining % (1000 * 60 * 60)) % (1000 * 60)) / 1000;
			
			this.text = _minutes + ":" + ((_seconds < 10) ? "0" : "") + _seconds;
		}//end set time()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
		}//end update()
		
	}//end TimerDisplay

}//end package