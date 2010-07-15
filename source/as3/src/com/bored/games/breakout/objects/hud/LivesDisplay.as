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
	public class LivesDisplay extends GameWord
	{		
		private var _livesRemaining:int;		
		
		public function LivesDisplay(a_lives:int, a_font:BitmapFont) 
		{
			_livesRemaining = a_lives;
			
			super("Lives:" + _livesRemaining, a_font);
		}//end constructor()
		
		public function increaseLives():void
		{
			_livesRemaining++;
		}//end increaseLives()
		
		public function decreaseLives():void
		{
			_livesRemaining--;
		}//end increaseLives()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			this.text = "Lives:" + _livesRemaining;
		}//end update()
		
	}//end LivesDisplay

}//end package