package com.bored.games.breakout.states.views 
{
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.jac.fsm.StateView;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name = 'start', type = 'flash.events.Event')]
	[Event(name = 'continue', type = 'flash.events.Event')]
	[Event(name = 'options', type = 'flash.events.Event')]
	
	/**
	 * ...
	 * @author sam
	 */
	public class TitleView extends StateView
	{	
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.TitleScreen_MC')]
		private static var mcCls:Class;
		
		private var _titleMC:Sprite;
		
		public static const START_GAME:String = "start";
		public static const CONTINUE_GAME:String = "continue";
		public static const SHOW_OPTIONS:String = "options";
		
		public function TitleView() 
		{
			super();
			
			_titleMC = new mcCls();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			addChild(_titleMC);
			
			addEventListener(MouseEvent.CLICK, clickToPlay, false, 0, true);
		}//end addedToStageHandler()
		
		private function clickToPlay(e:MouseEvent):void
		{
			var msnd:MightySound = MightySoundManager.instance.getMightySoundByName("Title Theme or Intro Sound");
			if (msnd)
			{
				MightySoundManager.instance.playMusicByName("Title Theme or Intro Sound");
			}
			
			removeEventListener(MouseEvent.CLICK, clickToPlay);
			
			dispatchEvent(new Event(START_GAME));
			
		}//end clickToPlay()
		
	}//end TitleView

}//end package