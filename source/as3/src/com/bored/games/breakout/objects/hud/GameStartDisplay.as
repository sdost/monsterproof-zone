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
	public class GameStartDisplay extends GameWord
	{		
		public function GameStartDisplay(a_font:BitmapFont) 
		{
			super("Game Start", a_font);
			
			
		}//end constructor()
		
		public function show(a_animate:Boolean = false):void
		{
			
		}//end show()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
		}//end update()
		
	}//end GameStartDisplay

}//end package