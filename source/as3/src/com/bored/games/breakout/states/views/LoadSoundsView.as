package com.bored.games.breakout.states.views
{
	import com.sven.factories.AnimationSetFactory;
	import com.sven.animation.AnimationSet;
	import com.inassets.sound.MightySoundManager;
	import com.jac.fsm.StateView;
	import com.sven.utils.AppSettings;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.sampler.NewObjectSample;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
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
		
		private var _urlLdr:URLLoader;
		
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
			
			//stateFinished();
			
			loadXmlSoundList();
			
		}//end loadingComplete()
		
		private function loadXmlSoundList():void
		{
			_urlLdr = new URLLoader();
			
			var urlReq:URLRequest = new URLRequest();
			urlReq.method = URLRequestMethod.GET;
			urlReq.url = "sound_list.xml";
			
			
			_urlLdr.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLdr.addEventListener(Event.COMPLETE, onXmlLoadingComplete);
			_urlLdr.load(urlReq);
			
		}//end loadXmlSoundList()
		
		private function onXmlLoadingComplete(a_evt:Event):void
		{
			// parse the xml that was loaded.
			
			var fileXml:XML;
			
			fileXml = new XML(_urlLdr.data);
			
			var mp3sXML:XMLList = fileXml.descendants("sound");
			
			for (var node:String in mp3sXML)
			{
				var sndXml:XML = new XML(mp3sXML[node]);
				var soundID:String = sndXml.@id;
				var soundURL:String = sndXml.@url;
				
				if (soundURL && soundURL.length && soundURL != "" && soundID && soundID != "" && soundID.length)
				{
					var snd:Sound = new Sound(new URLRequest(soundURL));
					MightySoundManager.instance.addSound(snd, soundID);
				}
			}
			
			stateFinished();
			
		}//end onXmlLoadingComplete()
		
		private function stateFinished():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
			
		}//end stateFinished()
		
	}//end LoadSoundsView

}//end package