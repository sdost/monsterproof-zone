package com.bored.games.breakout.objects.hud 
{
	import com.inassets.sound.MightySoundManager;
	import com.sven.text.BitmapFont;
	import com.sven.text.GameChar;
	import com.sven.text.GameWord;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PauseDisplay extends GameWord
	{		
		private var _title:GameWord;
		private var _pausedHeader:GameWord;
		private var _muteLabel:GameWord;
		
		private var _muteValue:GameWord;
		
		private var _quit:GameWord;
		private var _click:GameWord;
		
		public function PauseDisplay(a_font:BitmapFont) 
		{
			super("", a_font);
			
			_title = new GameWord("PAUSED (P)", a_font);
			_title.x = 672 / 2 - _title.width / 2;
			_title.y = 150;
			
			_muteLabel = new GameWord("SOUND/MUSIC (M):", a_font);
			_muteLabel.x = 200;
			_muteLabel.y = _title.y + _title.height + 25;
			
			_muteValue = new GameWord(MightySoundManager.instance.mute ? "OFF" : "ON", a_font);
			_muteValue.y = _muteLabel.y;
			
			_quit = new GameWord("QUIT (Q) to Level Select.", a_font);
			_quit.x = 672 / 2 - _quit.width / 2;
			_quit.y = _muteLabel.y + _muteLabel.height + 50;
			
			_click = new GameWord("Click to Resume.", a_font);
			_click.x = 672 / 2 - _click.width / 2;
			_click.y = _quit.y + _quit.height + 25;
		}//end constructor()
				
		override public function update(t:Number = 0):void 
		{
		}//end update()
		
		override public function draw(a_bmd:BitmapData, a_color:uint = 0xFFFFFF, a_scale:Number = 1.0, a_alpha:Number = 1.0):void 
		{
			a_bmd.fillRect(a_bmd.rect, 0x66000000);
			
			_title.draw(a_bmd, 0xFFFFFF, 1);
			
			_muteLabel.draw(a_bmd, 0xFFFFFF, 1);
			
			_muteValue.text = MightySoundManager.instance.mute ? "OFF" : "ON";
			_muteValue.x = 472 - _muteValue.width;
			_muteValue.draw(a_bmd, 0xFFFFFF, 1);
			
			_quit.draw(a_bmd, 0xFFFFFF, 1);
			
			_click.draw(a_bmd, 0xFFFFFF, 1);
		}//end draw()
		
	}//end PauseDisplay

}//end package