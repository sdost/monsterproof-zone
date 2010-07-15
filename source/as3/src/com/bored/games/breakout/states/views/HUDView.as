package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.objects.hud.LivesDisplay;
	import com.bored.games.breakout.objects.hud.ScoreDisplay;
	import com.bored.games.breakout.profiles.UserProfile;
	import com.jac.fsm.StateView;
	import com.sven.text.BitmapFont;
	import com.sven.text.BitmapFontFactory;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class HUDView extends StateView
	{
		public static var Profile:UserProfile;
		
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.BreakoutFont')]
		private static var fontCls:Class;
		
		private var _livesDisp:LivesDisplay;
		private var _scoreDisp:ScoreDisplay;		
		
		private var _backBuffer:BitmapData;
		private var _mainBuffer:BitmapData;
		
		private var _score:int;
		private var _lives:int;
		
		private var _bmp:Bitmap;
		
		private var _paused:Boolean;
		
		public function HUDView() 
		{
			super();
			
			_paused = true;
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			var bitmapFont:BitmapFont = BitmapFontFactory.generateBitmapFont(new fontCls());
			
			Profile = new UserProfile();
			
			_livesDisp = new LivesDisplay(Profile.lives, bitmapFont);
			_scoreDisp = new ScoreDisplay(Profile.score, bitmapFont);
			
			_backBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_mainBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			
			_bmp = new Bitmap(_mainBuffer);
			addChild(_bmp);
			
			stage.invalidate();
			
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
			
			_paused = false;
		}//end addedToStageHandler()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		override public function update():void 
		{
			if (_paused) return;
			
			_scoreDisp.score = Profile.score;
			_livesDisp.lives = Profile.lives;
			
			_livesDisp.update();
			_scoreDisp.update();
			
			if (stage) stage.invalidate();
		}//end update()
		
		public function renderFrame(e:Event):void
		{
			_backBuffer.fillRect(_backBuffer.rect, 0x00000000);
			
			_scoreDisp.x = stage.stageWidth - _scoreDisp.width;
			
			_livesDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
			_scoreDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
						
			_mainBuffer.copyPixels(_backBuffer, _backBuffer.rect, new Point());
		}//end draw()
		
	}//end HUDView

}//end package