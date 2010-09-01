package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.profiles.LevelList;
	import com.greensock.events.TweenEvent;
	import com.greensock.TweenMax;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.jac.fsm.StateView;
	import com.sven.factories.MovieClipFactory;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name = 'lvlSelected', type = 'flash.events.Event')]
		
	/**
	 * ...
	 * @author sam
	 */
	public class LevelListView extends StateView
	{	
		public static const LEVEL_SELECTED:String = 'lvlSelected';
		
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.LevelSelectScreen_MC')]
		private static var mcCls:Class;
		
		private var _loader:URLLoader;
		
		private var _lvlSelectMC:Sprite;
		
		private var _levelButtons:Array;
		
		public function LevelListView() 
		{
			super();
			
			_lvlSelectMC = new mcCls();
			_levelButtons = new Array(20);
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			addChild(_lvlSelectMC);
			
			var mc:MovieClip;
			
			for ( var i:int = 1; i <= 20; i++ )
			{
				mc = _lvlSelectMC.getChildByName("lvl_icon_" + i) as MovieClip;
				var mb:MightyButton = new MightyButton(mc, false);
				mb.pause(false);
				_levelButtons[i-1] = mb;
			}
			
			this.alpha = 0;
		}//end addedToStageHandler()
		
		override public function enter():void 
		{			
			_loader = new URLLoader( new URLRequest(AppSettings.instance.levelListURL) );
			_loader.addEventListener(Event.COMPLETE, levelListComplete, false, 0, true);
		}//end enter()
		
		private function levelListComplete(e:Event):void
		{
			AppSettings.instance.levelList = new LevelList(XML(_loader.data));
			
			refresh();
			
			TweenMax.fromTo(this, 1.0, { "alpha": 0.0 }, { "alpha": 1.0 });
			
			enterComplete();
		}//end levelListComplete()
		
		private function onClick(e:ButtonEvent):void
		{
			var tokens:Array = (e.mightyButton.buttonContents as MovieClip).name.split("_");
			
			var ind:int = int(tokens[2]);
			
			AppSettings.instance.currentLevelInd = ind - 1;
			
			for ( var i:int = 0; i < _levelButtons.length; i++ )
			{
				(_levelButtons[i] as MightyButton).removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onClick);
			}
			
			TweenMax.fromTo(this, 1.0, { "alpha": 1.0 }, { "alpha": 0.0, "onComplete": dispatchLevelSelected } );
		}//end onClick()
		
		private function dispatchLevelSelected():void
		{
			dispatchEvent(new Event(LEVEL_SELECTED));
		}//end dispatchLevelSelected()
		
		private function refresh():void
		{			
			var len:int = AppSettings.instance.levelList.levelCount;
			
			for ( var i:int = 0; i < _levelButtons.length; i++ )
			{
				if( i < len )
				{
					(_levelButtons[i] as MightyButton).buttonContents.visible = true;
					if ( AppSettings.instance.userProfile.levelUnlocked(i) )
					{
						(_levelButtons[i] as MightyButton).pause(false);
					}
					else
					{
						(_levelButtons[i] as MightyButton).pause(true);
					}
					(_levelButtons[i] as MightyButton).addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onClick, false, 0, true);
				}
				else
				{
					(_levelButtons[i] as MightyButton).buttonContents.visible = false;
					(_levelButtons[i] as MightyButton).pause(true);
					(_levelButtons[i] as MightyButton).removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onClick);
				}
			}
		}//end refresh()
		
	}//end LevelListView

}//end package