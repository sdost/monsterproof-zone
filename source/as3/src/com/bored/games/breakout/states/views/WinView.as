package com.bored.games.breakout.states.views 
{
	import com.greensock.TweenMax;
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
		
		override public function enter():void 
		{			
			TweenMax.fromTo(this, 1.0, { "alpha": 0.0 }, { "alpha": 1.0 } );
			
			enterComplete();
		}//end enter()
		
		private function clickComplete(e:MouseEvent):void
		{			
			removeEventListener(MouseEvent.CLICK, clickComplete);
			
			TweenMax.fromTo(this, 1.0, { "alpha": 1.0 }, { "alpha": 0.0, "onComplete": dispatchWinComplete } );
		}//end clickToPlay()
		
		private function dispatchWinComplete():void
		{
			dispatchEvent(new Event(WIN_COMPLETE));
		}//end dispatchGameStart
		
	}//end WinView

}//end package