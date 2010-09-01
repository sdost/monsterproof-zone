package com.bored.games.breakout.states.views
{
	import com.greensock.TweenMax;
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
	public class LoadingBarView extends StateView
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Loading_MC')]
		private static var mcCls:Class;
		
		private var _loadingMC:MovieClip;
		
		private var _loader:Loader;
		private var _explorer:SWFExplorer;
		
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		
		public function LoadingBarView() 
		{
			super();	
			
			_loadingMC = new mcCls();
		}//end constructor()
		
		override protected function addedToStageHandler(e:Event):void 
		{
			super.addedToStageHandler(e);
			
			_loadingMC.gotoAndStop(1);
			addChild(_loadingMC);
			
			TweenMax.fromTo(this, 1.0, { "alpha": 0.0 }, { "alpha": 1.0 } );
		}//end addedToStageHandler()
		
		public function set progress(a_perc:Number):void
		{
			var frame:int = uint(a_perc * _loadingMC.totalFrames);
			_loadingMC.gotoAndStop(frame);
		}//end set progress()
		
	}//end LoadingBarView

}//end package