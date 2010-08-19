package com.bored.games.breakout.states.views
{
	import com.sven.factories.AnimationSetFactory;
	import com.sven.animation.AnimationSet;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LoadSoundsView extends StateView
	{
		private var _loader:Loader;
		private var _explorer:SWFExplorer;
		
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		
		public function LoadSoundsView() 
		{
			super();	
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void 
		{
			super.addedToStageHandler(e);
		}//end addedToStageHandler()
		
		override public function enter():void 
		{
			//trace("LoadSoundsView::enter()");
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingProgress, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			_loader.load( new URLRequest(AppSettings.instance.soundLibraryURL), context);
			
			enterComplete();
		}//end enter()
		
		private function loadingProgress(e:ProgressEvent):void
		{
			dispatchEvent(e);
		}//end loadingProgress()
		
		private function loadingComplete(e:Event):void
		{
			//trace("LoadSoundsView::loadingComplete()");
			_loader.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
			_loader.removeEventListener(Event.COMPLETE, loadingComplete);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}//end loadingComplete()
		
	}//end LoadSoundsView

}//end package