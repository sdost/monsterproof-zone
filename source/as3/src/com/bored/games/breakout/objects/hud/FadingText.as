package com.bored.games.breakout.objects.hud 
{
	import com.sven.text.BitmapFont;
	import com.sven.text.GameWord;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FadingText extends GameWord
	{
		private var _fadeTime:int;
		private var _startTime:int;
		private var _color:uint;
		
		private var _strength:Number;
		
		private var _complete:Boolean;
		
		public function FadingText(a_str:String, a_font:BitmapFont, a_strength:Number) 
		{
			super(a_str, a_font);
			
			_strength = a_strength;
			
			var intensity:int = 255 / 3 * _strength + (2 * 255 / 3);
			
			if( _strength < 1 )
				_color = intensity << 16 | intensity << 8 | intensity;
			else 
				_color = Math.random() * 0xFFFFFF;
			
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
		
		override public function draw(a_bmd:BitmapData, a_color:uint, a_scale:Number = 1):void 
		{
			var intensity:int = 255 / 3 * _strength + (2 * 255 / 3);
			
			if( _strength < 1 )
				_color = intensity << 16 | intensity << 8 | intensity;
			else 
				_color = Math.random() * 0xFFFFFF;
			
			super.draw(a_bmd, _color, a_scale);
		}//end draw()
		
	}//end FadingText()

}//end package