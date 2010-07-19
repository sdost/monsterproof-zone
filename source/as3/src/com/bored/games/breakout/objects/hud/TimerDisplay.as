package com.bored.games.breakout.objects.hud 
{
	import com.bored.games.objects.GameElement;
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
		private var _timeRemaining:int;
		
		private var _minutes:int;
		private var _seconds:int;
		
		public function TimerDisplay(a_time:int, a_font:BitmapFont) 
		{
			_timeRemaining = a_time;
			
			_minutes = Math.floor((_timeRemaining / 1000) / 60);
			_seconds = Math.floor((_timeRemaining / 1000) % 60);
			
			super(_minutes + ":" + ((_seconds < 10) ? "0" : "") + _seconds, a_font);
		}//end constructor()
		
		public function set time(a_time:int):void
		{
			_timeRemaining = a_time;
			
			_minutes = Math.floor((_timeRemaining / 1000) / 60);
			_seconds = Math.floor((_timeRemaining / 1000) % 60);
		}//end set time()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			this.text = _minutes + ":" + ((_seconds < 10) ? "0" : "") + _seconds;
		}//end update()
		
	}//end TimerDisplay

}//end package