package com.bored.games.breakout.states.views
{
	import com.bored.games.breakout.factories.AnimationSetFactory;
	import com.bored.games.breakout.objects.AnimationSet;
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
			
			_textFormat = new TextFormat();
			_textFormat.color = 0xFFFFFF;
			_textFormat.size = 30;
			
			_textField = new TextField();
			_textField.setTextFormat(_textFormat);
			_textField.autoSize = TextFieldAutoSize.CENTER;
			_textField.x = Math.random() * stage.stageWidth;
			_textField.y = Math.random() * stage.stageHeight;
			_textField.text = "0%";
			this.addChild(_textField);
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
			_textField.text = Math.ceil(e.bytesLoaded / e.bytesTotal * 100) + "%";
			_textField.setTextFormat(_textFormat);
			//trace("LoadSoundsView::loadingProgress(" + Math.ceil(e.bytesLoaded / e.bytesTotal * 100) + ")");
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