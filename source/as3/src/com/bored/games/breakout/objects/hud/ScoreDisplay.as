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
	public class ScoreDisplay extends GameWord
	{		
		private var _score:int;		
		
		public function ScoreDisplay(a_score:int, a_font:BitmapFont) 
		{
			_score = a_score;
			
			super(String(_score), a_font);
		}//end constructor()
		
		public function set score(a_str:int):void
		{
			_score = a_str;
			
			this.text = String(_score);
		}//end score()
		
	}//end ScoreDisplay

}//end package