package com.bored.games.breakout.states.views 
{
	import com.greensock.TweenMax;
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
		
		private var _theme:MightySound;
		
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
			
			_theme = MightySoundManager.instance.getMightySoundByName("musTitleTheme");
			_theme.infiniteLoop = true;
			if (_theme) _theme.play();
			
			this.alpha = 0;
		}//end addedToStageHandler()
		
		override public function enter():void 
		{			
			TweenMax.fromTo(this, 1.0, { "alpha": 0.0 }, { "alpha": 1.0 } );
			
			enterComplete();
		}//end enter()
		
		private function clickToPlay(e:MouseEvent):void
		{			
			removeEventListener(MouseEvent.CLICK, clickToPlay);
			
			if(_theme) _theme.stop();
			
			TweenMax.fromTo(this, 1.0, { "alpha": 1.0 }, { "alpha": 0.0, "onComplete": dispatchGameStart } );
		}//end clickToPlay()
		
		private function dispatchGameStart():void
		{
			dispatchEvent(new Event(START_GAME));
		}//end dispatchGameStart
		
	}//end TitleView

}//end package