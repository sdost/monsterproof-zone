package com.bored.games.breakout.states 
{
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LoadBrickAssetsState extends StateView
	{
		private var _loader:Loader;
		private var _explorer:SWFExplorer;
		
		public function LoadBrickAssetsState() 
		{
			super();
		}//end constructor()
		
		override public function enter():void 
		{
			trace("LoadBrickAssetsState::enter()");
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_loader.load( new URLRequest("../assets/BrickSpriteLibrary.swf") );
			
			enterComplete();
		}//end enter()
		
		private function loadingComplete(e:Event):void
		{
			trace("LoadBrickAssetsState::loadingComplete()");
			
			_explorer = new SWFExplorer();
			_explorer.addEventListener(SWFExplorerEvent.COMPLETE, assetsParsed, false, 0, true);
			_explorer.parse(_loader.contentLoaderInfo.bytes);
		}//end loadingComplete()
		
		private function assetsParsed(e:SWFExplorerEvent):void
		{
			trace("LoadBrickAssetsState::assetsParsed()");
			
			AppSettings.instance.brickAnimationSets = new Dictionary(true);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _loader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				var anims:AnimationSet = AnimationSetFactory.generateAnimationSet(new cls() as MovieClip);
				
				AppSettings.instance.brickAnimationSets[e.definitions[i]] = anims;
			}
		}//end assetsParsed()
		
	}//end LoadBrickAssetsState

}//end package