package com.bored.games.breakout.states.views 
{
	import com.bored.games.breakout.profiles.LevelList;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
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
		
		private var _list:Array;
		
		public function LevelListView() 
		{
			super();
			
			_lvlSelectMC = new mcCls();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			addChild(_lvlSelectMC);
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
			
			enterComplete();
		}//end levelListComplete()
		
		private function onClick(e:MouseEvent):void
		{
			var tokens:Array = (e.currentTarget as MovieClip).name.split("_");
			
			var ind:int = int(tokens[2]);
			
			AppSettings.instance.currentLevelInd = ind;
			
			dispatchEvent(new Event(LEVEL_SELECTED));
		}//end onClick()
		
		private function refresh():void
		{			
			var len:int = AppSettings.instance.levelList.levelCount;
			var mc:MovieClip;
			
			_list = new Array(len);
			
			for ( var i:int = 0; i < 54; i++ )
			{
				mc = _lvlSelectMC.getChildByName("lvl_icon_" + i) as MovieClip;
				
				if( i < len )
				{
					mc.visible = true;
					mc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				}
				else
				{
					mc.visible = false;
					mc.removeEventListener(MouseEvent.CLICK, onClick);
				}
			}
		}//end refresh()
		
	}//end LevelListView

}//end package