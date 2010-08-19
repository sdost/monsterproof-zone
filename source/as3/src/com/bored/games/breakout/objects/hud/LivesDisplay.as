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
	public class LivesDisplay extends GameWord
	{		
		private var _livesRemaining:int;
		
		public function LivesDisplay(a_lives:int, a_font:BitmapFont) 
		{
			_livesRemaining = a_lives;
			
			super("Lives:" + _livesRemaining, a_font);
		}//end constructor()
		
		public function set lives(a_lives:int):void
		{
			_livesRemaining = a_lives;
		}//end increaseLives()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			this.text = "Lives:" + _livesRemaining;
		}//end update()
		
	}//end LivesDisplay

}//end package