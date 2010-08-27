package com.bored.games.breakout.states.views 
{
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.jac.fsm.StateView;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author sam
	 */
	public class WinView extends StateView
	{	
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.WinScreen_MC')]
		private static var mcCls:Class;
		
		private var _winMC:Sprite;
		
		public static const WIN_COMPLETE:String = "winComplete";
				
		public function WinView() 
		{
			super();
			
			_winMC = new mcCls();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			addChild(_winMC);
			
			addEventListener(MouseEvent.CLICK, clickComplete, false, 0, true);
		}//end addedToStageHandler()
		
		private function clickComplete(e:MouseEvent):void
		{			
			removeEventListener(MouseEvent.CLICK, clickComplete);
			
			dispatchEvent(new Event(WIN_COMPLETE));
		}//end clickToPlay()
		
	}//end WinView

}//end package