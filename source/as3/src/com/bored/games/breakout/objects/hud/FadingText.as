package com.bored.games.breakout.objects.hud 
{
	import com.sven.text.BitmapFont;
	import com.sven.text.GameWord;
	import com.sven.utils.AppSettings;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FadingText extends GameWord
	{
		private var _fadeTime:int;
		private var _startTime:int;
		
		private var _complete:Boolean;
		
		public function FadingText(a_str:String, a_font:BitmapFont) 
		{
			super(a_str, a_font);
			
			_startTime = getTimer();
			_complete = false;
			_fadeTime = AppSettings.instance.popupTextLifetime;
		}//end constructor()
		
		public function get complete():Boolean
		{
			return _complete;
		}//end get complete()
		
		override public function update(t:Number = 0):void 
		{
			if ( (getTimer() - _startTime) > _fadeTime )
			{				
				_complete = true;
			}
		}//end update()
		
	}//end FadingText()

}//end package