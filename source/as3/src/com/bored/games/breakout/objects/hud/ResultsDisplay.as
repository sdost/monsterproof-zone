package com.bored.games.breakout.objects.hud 
{
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
	public class ResultsDisplay extends GameWord
	{		
		public static const LEVEL_COMPLETE:int = 1;
		public static const GAME_OVER:int = 2;
		
		private var _title:GameWord;
		
		private var _timeLabel:GameWord;
		private var _blockLabel:GameWord;
		private var _totalLabel:GameWord;
		
		private var _timeValue:GameWord;
		private var _blockValue:GameWord;
		private var _totalValue:GameWord;
		
		private var _score:int;
		private var _timeLeft:int;
		private var _blocksLeft:int;
		
		private var _minutes:int;
		private var _seconds:int;
		
		private var _fadeTime:int;
		private var _startTime:int;
		
		private var _alpha:Number;
		
		private var _complete:Boolean;
		
		public function ResultsDisplay(a_type:int, a_score:int, a_time:int, a_blocks:int, a_font:BitmapFont) 
		{
			super("", a_font);
			
			_alpha = 1.0;
			
			_startTime = getTimer();
			_complete = false;
			_fadeTime = AppSettings.instance.resultsTextLifetime;
			
			_score = a_score;
			_timeLeft = a_time;
			_blocksLeft = a_blocks;
			
			if( a_type == LEVEL_COMPLETE )
				_title = new GameWord("LEVEL COMPLETE", a_font);
			else if ( a_type == GAME_OVER )
				_title = new GameWord("GAME OVER", a_font);
			_title.x = 672 / 2 - _title.width / 2;
			_title.y = 150;
			
			_timeLabel = new GameWord("Time Bonus:", a_font);
			_timeLabel.x = 200;
			_timeLabel.y = _title.y + _title.height + 25;
			
			_blockLabel = new GameWord("Block Bonus:", a_font);
			_blockLabel.x = 200;
			_blockLabel.y = _timeLabel.y + _timeLabel.height + 25;
			
			_totalLabel = new GameWord("TOTAL", a_font);
			_totalLabel.x = 200;
			_totalLabel.y = _blockLabel.y + _blockLabel.height + 25;
			
			_minutes = Math.ceil(_timeLeft / 60) / 1000;
			_seconds = Math.floor((_timeLeft - _minutes * 60 * 1000) / 1000);
			
			_timeValue = new GameWord(_minutes + ":" + ((_seconds < 10) ? "0" : "") + _seconds, a_font);
			_timeValue.y = _timeLabel.y;
			
			_blockValue = new GameWord(_blocksLeft + " left", a_font);
			_blockValue.y = _blockLabel.y;
			
			_totalValue = new GameWord(new String(_score), a_font);
			_totalValue.y = _totalLabel.y;
		}//end constructor()
				
		override public function update(t:Number = 0):void 
		{
			_timeValue.x = 472 - _timeValue.width;
			_blockValue.x = 472 - _blockValue.width;
			_totalValue.x = 472 - _totalValue.width;
			
			if ( (getTimer() - _startTime) > _fadeTime )
			{	
				_alpha += (0.0 - _alpha) / 4;
				
				if ( _alpha < 0.1 )
				{
					_complete = true;	
				}
			}
		}//end update()
		
		public function get complete():Boolean
		{
			return _complete;
		}//end get complete()
		
		override public function draw(a_bmd:BitmapData, a_color:uint = 0xFFFFFF, a_scale:Number = 1.0, a_alpha:Number = 1.0):void 
		{
			var color:uint = (0x66 * _alpha) << 24;
			
			a_bmd.fillRect(a_bmd.rect, color);
			
			_title.draw(a_bmd, 0xFFFFFF, 1, _alpha);
			
			_timeLabel.draw(a_bmd, 0xFFFFFF, 1, _alpha);
			_blockLabel.draw(a_bmd, 0xFFFFFF, 1, _alpha);
			_totalLabel.draw(a_bmd, 0xFFFFFF, 1, _alpha);
			
			_timeValue.draw(a_bmd, 0x00AA00, 1, _alpha);
			_blockValue.draw(a_bmd, 0x00AA00, 1, _alpha);
			_totalValue.draw(a_bmd, 0xFFFFFF, 1, _alpha);
		}//end draw()
		
	}//end ResultsDisplay

}//end package