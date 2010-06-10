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
	public class GPBreakout extends Panel
	{
		private var _sm:StateMachine;
		
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
		}//end addedToStage()		
		
		private function onConfigReady(a_evt:Event):void
		{
			AppSettings.instance.removeEventListener(Event.COMPLETE, onConfigReady);
			
			trace("Added to Stage.");
			
		}//end addedToStage()
		
		protected function addStates():void
		{
		}//end addStates()
		
	}//end class GPBreakout
	
}//end package com.bored.games.darts