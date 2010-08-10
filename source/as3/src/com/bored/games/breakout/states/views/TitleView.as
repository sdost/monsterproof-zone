package com.bored.games.breakout.states.views 
{
	import com.jac.fsm.StateView;
	import flash.events.Event;
	
	[Event(name = 'titleComplete', type = 'flash.events.Event')]
	
	/**
	 * ...
	 * @author sam
	 */
	public class TitleView extends StateView
	{		
		public function TitleView() 
		{
			super();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
		}//end addedToStageHandler()
		
	}//end TitleView

}//end package