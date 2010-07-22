package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.objects.hud.LivesDisplay;
	import com.bored.games.breakout.objects.hud.ScoreDisplay;
	import com.bored.games.breakout.objects.hud.TimerDisplay;
	import com.bored.games.breakout.profiles.LevelProfile;
	import com.bored.games.breakout.profiles.UserProfile;
	import com.jac.fsm.StateView;
	import com.sven.text.BitmapFont;
	import com.sven.text.BitmapFontFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class HUDView extends StateView
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', fontFamily='04b31')]
		private static var fontCls:Class;
		
		private var _lastUpdate:Number;
		
		private var _livesDisp:LivesDisplay;
		private var _timeDisp:TimerDisplay;
		private var _scoreDisp:ScoreDisplay;		
		
		private var _backBuffer:BitmapData;
		private var _mainBuffer:BitmapData;
		
		private var _time:int;
		
		private var _bmp:Bitmap;
		
		private var _paused:Boolean;
		
		public function HUDView() 
		{
			super();
			
			_paused = true;
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			//trace("HUDView::addedToStageHandler()");
			
			super.addedToStageHandler(e);
			
			var bitmapFont:BitmapFont = BitmapFontFactory.generateBitmapFont(new fontCls());
						
			AppSettings.instance.userProfile = new UserProfile();
			AppSettings.instance.currentLevel = new LevelProfile(150000, "../assets/TestLevel.swf", Math.floor(Math.random() * 10));
			
			AppSettings.instance.userProfile.time = AppSettings.instance.currentLevel.timeLimit;
			
			_livesDisp = new LivesDisplay(AppSettings.instance.userProfile.lives, bitmapFont);
			_timeDisp = new TimerDisplay(AppSettings.instance.userProfile.time, bitmapFont);
			_scoreDisp = new ScoreDisplay(AppSettings.instance.userProfile.score, bitmapFont);
			
			_timeDisp.x = stage.stageWidth / 2;
			
			_backBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			_mainBuffer = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000);
			
			_bmp = new Bitmap(_mainBuffer);
			addChild(_bmp);
			
			stage.invalidate();
			
			this.addEventListener(Event.RENDER, renderFrame, false, 0, true);
			
			_lastUpdate = getTimer();
			
			_paused = false;
		}//end addedToStageHandler()
		
		override public function enter():void 
		{
			//trace("HUDView::enter()");
			
			enterComplete();
		}//end enter()
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}//end removedFromStageHandler()
		
		override public function update():void 
		{
			if (_paused) return;
			
			var delta:Number = getTimer() - _lastUpdate;
			
			_lastUpdate = getTimer();
			
			AppSettings.instance.userProfile.decreaseTime(delta);
			
			_scoreDisp.score = AppSettings.instance.userProfile.score;
			_timeDisp.time = AppSettings.instance.userProfile.time;
			_livesDisp.lives = AppSettings.instance.userProfile.lives;
			
			_livesDisp.update(delta);
			_timeDisp.update(delta);
			_scoreDisp.update(delta);
			
			if (stage) stage.invalidate();
		}//end update()
		
		public function renderFrame(e:Event):void
		{
			_backBuffer.fillRect(_backBuffer.rect, 0x00000000);
			
			_scoreDisp.x = stage.stageWidth - _scoreDisp.width;
			
			_livesDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
			_timeDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
			_scoreDisp.draw(_backBuffer, 0x33FFFFFF, 1.0);
						
			_mainBuffer.copyPixels(_backBuffer, _backBuffer.rect, new Point());
		}//end draw()
		
	}//end HUDView

}//end package