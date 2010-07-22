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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.bytearray.explorer.events.SWFExplorerEvent;
	import org.bytearray.explorer.SWFExplorer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LoadBackgroundsView extends StateView
	{
		private var _loader:Loader;
		private var _explorer:SWFExplorer;
		
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		
		public function LoadBackgroundsView() 
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
			//trace("LoadBackgroundsView::enter()");
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadingProgress, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete, false, 0, true);
			_loader.load( new URLRequest("../assets/BackgroundLibrary.swf") );
			
			enterComplete();
		}//end enter()
		
		private function loadingProgress(e:ProgressEvent):void
		{
			_textField.text = Math.ceil(e.bytesLoaded / e.bytesTotal * 100) + "%";
			_textField.setTextFormat(_textFormat);
			//trace("LoadBackgroundsView::loadingProgress(" + Math.ceil(e.bytesLoaded / e.bytesTotal * 100) + ")");
		}//end loadingProgress()
		
		private function loadingComplete(e:Event):void
		{
			//trace("LoadBackgroundsView::loadingComplete()");
			_loader.removeEventListener(ProgressEvent.PROGRESS, loadingProgress);
			_loader.removeEventListener(Event.COMPLETE, loadingComplete);
			
			_explorer = new SWFExplorer();
			_explorer.addEventListener(SWFExplorerEvent.COMPLETE, assetsParsed, false, 0, true);
			_explorer.parse(_loader.contentLoaderInfo.bytes);
		}//end loadingComplete()
		
		private function assetsParsed(e:SWFExplorerEvent):void
		{
			//trace("LoadBackgroundsView::assetsParsed()");
			
			AppSettings.instance.backgrounds = new Vector.<MovieClip>(e.definitions.length);
			
			for ( var i:int = 0; i < e.definitions.length; i++ )
			{
				var cls:Class = _loader.contentLoaderInfo.applicationDomain.getDefinition(e.definitions[i]) as Class;
				
				AppSettings.instance.backgrounds[i] = new cls() as MovieClip;
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}//end assetsParsed()
		
	}//end LoadBackgroundsView

}//end package