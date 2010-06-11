package com.bored.games.breakout
{
	import com.bored.games.breakout.states.controllers.GameplayController;
	import com.bored.services.BoredServices;
	import com.inassets.statemachines.Finite.FiniteStateMachine;
	import com.jac.fsm.StateController;
	import com.jac.fsm.StateMachine;
	import com.jac.fsm.StateViewController;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
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
		private var _sc:StateController;
		
		private var _screen:MovieClip;
		
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
			
			addStates();
			
			stage.align = StageAlign.TOP_LEFT;
			
			AppSettings.instance.load("development.config");
			
			AppSettings.instance.addEventListener(Event.COMPLETE, onConfigReady);
			
			addChild(_screen);
		}//end addedToStage()		
		
		private function onConfigReady(a_evt:Event):void
		{
			AppSettings.instance.removeEventListener(Event.COMPLETE, onConfigReady);
			
			_sm.changeState(_sc);			
		}//end addedToStage()
		
		protected function addStates():void
		{
			_screen = new MovieClip();
			
			_sc = new GameplayController(_screen);
		}//end addStates()
		
	}//end class GPBreakout
	
}//end package com.bored.games.darts