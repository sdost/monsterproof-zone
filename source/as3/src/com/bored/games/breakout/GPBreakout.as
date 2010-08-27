﻿package com.bored.games.breakout
{
	import com.bored.games.breakout.profiles.UserProfile;
	import com.bored.games.breakout.states.controllers.GameplayController;
	import com.bored.games.breakout.states.controllers.LevelSelectController;
	import com.bored.games.breakout.states.controllers.LoadingController;
	import com.bored.games.breakout.states.controllers.TitleController;
	import com.bored.games.breakout.states.controllers.WinController;
	import com.bored.games.breakout.states.views.TitleView;
	import com.bored.games.input.Input;
	import com.bored.services.BoredServices;
	import com.jac.fsm.StateController;
	import com.jac.fsm.stateEvents.StateEvent;
	import com.jac.fsm.StateMachine;
	import com.jac.fsm.StateViewController;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GPBreakout extends Panel
	{
		private var _sm:StateMachine;
		
		private var _loader:StateController;
		private var _title:StateController;
		private var _levelSelect:StateController;
		private var _gameplay:StateController;
		private var _win:StateController;
		
		public function GPBreakout() 
		{		
			super();
			
			_sm = new StateMachine();
				
		}//end constructor.
		
		public function init(a_params:Object):void
		{
			
		}//end init()
		
		public function setBoredServices(a_servicesObj:Object):void
		{
			BoredServices.servicesObj = a_servicesObj;
			
		}//end setBoredServices()
		
		override protected function addedToStage(a_evt:Event = null):void
		{
			super.addedToStage();
			
			stage.align = StageAlign.TOP_LEFT;
			
			var appSetting:AppSettings = AppSettings.instance;		
			
			AppSettings.instance.load("development.config");
			
			AppSettings.instance.addEventListener(Event.COMPLETE, onConfigReady);
		}//end addedToStage()		
		
		private function onConfigReady(a_evt:Event):void
		{
			AppSettings.instance.removeEventListener(Event.COMPLETE, onConfigReady);
			
			AppSettings.instance.userProfile = new UserProfile();
			AppSettings.instance.userProfile.unlockLevel(0);
			
			_loader = new LoadingController(this);
			_loader.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_sm.changeState(_loader);
		}//end addedToStage()
		
		private function loadingComplete(e:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, loadingComplete);
			_loader = null;
			
			_title = new TitleController(this);
			_title.addEventListener('startGame', titleComplete, false, 0, true);
			_sm.changeState(_title);
		}//end loadingComplete()
		
		private function titleComplete(e:Event):void
		{
			_title.removeEventListener('startGame', titleComplete);
			_title = null;
			
			_levelSelect = new LevelSelectController(this);
			_levelSelect.addEventListener('levelSelect', levelSelectComplete, false, 0, true);
			_sm.changeState(_levelSelect);
		}//end titleComplete()
		
		private function returnToLevelSelect(e:Event):void
		{
			if (_win)
			{
				_win.removeEventListener('returnToLevelSelect', returnToLevelSelect);
				_win = null;
			}
			
			if (_gameplay)
			{			
				_gameplay.removeEventListener('returnToLevelSelect', returnToLevelSelect);
				_gameplay.removeEventListener('proceedToWinScreen', proceedToWinScreen);
				_gameplay = null;
			}
			
			_levelSelect = new LevelSelectController(this);
			_levelSelect.addEventListener('levelSelect', levelSelectComplete, false, 0, true);
			_sm.changeState(_levelSelect);
		}//end titleComplete()
		
		private function levelSelectComplete(e:Event):void
		{
			_levelSelect.removeEventListener('levelSelect', levelSelectComplete);
			_levelSelect = null;
			
			_gameplay = new GameplayController(this);
			_gameplay.addEventListener('returnToLevelSelect', returnToLevelSelect, false, 0, true);
			_gameplay.addEventListener('proceedToWinScreen', proceedToWinScreen, false, 0, true);
			_sm.changeState(_gameplay);
		}//end levelSelectComplete()
		
		private function proceedToWinScreen(e:Event):void
		{
			_gameplay.removeEventListener('returnToLevelSelect', returnToLevelSelect);
			_gameplay.removeEventListener('proceedToWinScreen', proceedToWinScreen);
			_gameplay = null;
			
			_win = new WinController(this);
			_win.addEventListener('returnToLevelSelect', returnToLevelSelect, false, 0, true);
			_sm.changeState(_win);
		}//end titleComplete()
		
	}//end class GPBreakout
	
}//end package com.bored.games.darts