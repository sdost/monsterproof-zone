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
	import flash.sampler.NewObjectSample;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LoadBackgroundsState extends StateView
	{
		private var _loader:Loader;
		private var _explorer:SWFExplorer;
		
		public function LoadBackgroundsState() 
		{
			super();	
		}//end constructor()
		
		override public function enter():void 
		{
			trace("LoadBackgroundsState::enter()");
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_loader.load( new URLRequest("../assets/BackgroundLibrary.swf") );
			
			enterComplete();
		}//end enter()
		
		private function loadingComplete(e:Event):void
		{
			trace("LoadBackgroundsState::loadingComplete()");
			
			_explorer = new SWFExplorer();
			_explorer.addEventListener(SWFExplorerEvent.COMPLETE, assetsParsed, false, 0, true);
			_explorer.parse(_loader.contentLoaderInfo.bytes);
		}//end loadingComplete()
		
		private function assetsParsed(e:SWFExplorerEvent):void
		{
			trace("LoadBackgroundsState::assetsParsed()");
			
			AppSettings.instance.backgrounds = new Vector.<MovieClip>(e.definitions.length);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _loader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				AppSettings.instance.backgrounds[i] = new cls() as MovieClip;
			}
		}//end assetsParsed()
		
	}//end LoadBackgroundState

}//end package