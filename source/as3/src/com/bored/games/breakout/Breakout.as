package com.bored.games.breakout
{
	import com.bored.services.BoredServices;
	import com.inassets.statemachines.Finite.FiniteStateMachine;
	import com.jac.fsm.StateMachine;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
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
	public class Breakout extends Panel
	{
		private var _sm:StateMachine;
		
		public function Breakout() 
		{		
			super();
			
			_sm = new StateMachine();
				
		}//end BasicPreloader() constructor.
		
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
		}//end addedToStage()		
		
		private function onConfigReady(a_evt:Event):void
		{
			AppSettings.instance.removeEventListener(Event.COMPLETE, onConfigReady);
			
			// our flashVars were set before we were added to the stage, so, now that we're on the stage, we can start.
			_myStateMachine.start();
			
			trace("Added to Stage.");
			
		}//end addedToStage()
		
		protected function addStates():void
		{	
			_fsm.
		}//end addStates()
		
	}//end class Breakout
	
}//end package com.bored.games.darts