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
	public class GameOverDisplay extends GameWord
	{		
		public function GameOverDisplay(a_font:BitmapFont) 
		{
			super("Game Over", a_font);
		}//end constructor()
		
		public function show(a_animate:Boolean = false):void
		{
			
		}//end show()

		override public function update(t:Number = 0):void 
		{
			super.update(t);
		}//end update()
		
	}//end GameOverDisplay

}//end package