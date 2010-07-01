package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickExplosion;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.bricks.NanoBrick;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class NanoManagerAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.NanoManagerAction";

		private var _delay:uint;
		
		private var _lastUpdate:uint;
		private var _delta:uint;
		
		private var _nanoList:Vector.<NanoBrick>;
		
		private var _dormantList:Vector.<NanoBrick>;
		private var _reviveList:Vector.<NanoBrick>;
		
		public function NanoManagerAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);	
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
			_delay = a_params.delay;
		}//end initParams()
		
		override public function startAction():void 
		{
			_finished = false;
			
			_nanoList = new Vector.<NanoBrick>();
			
			_dormantList = new Vector.<NanoBrick>();
			_reviveList = new Vector.<NanoBrick>();
		}//end startAction()
		
		public function addNanoBrick(a_brick:NanoBrick):void
		{
			_nanoList.push(a_brick);
		}//end addBricks()
		
		override public function update(a_time:Number):void 
		{			
			_delta += a_time - _lastUpdate;
			_lastUpdate = a_time;
			
			if ( _delta < _delay ) return;
			
			_delta = 0;
			
			var nano:NanoBrick;
			
			for each( nano in _dormantList )
			{
				var neighbors:Vector.<Brick> = (_gameElement as Grid).getAllNeighbors(nano);
				var b:Brick;
				for each( b in neighbors )
				{
					if ( b is NanoBrick && (b as NanoBrick).alive )
					{
						var ind:uint = _dormantList.indexOf(nano);
						_dormantList.splice(ind, 1);
						_reviveList.push(nano);
						break;
					}
				}
			}
			
			while( _reviveList.length > 0 )
			{
				nano = _reviveList.pop();
				nano.revive();
			}
			
			for each( nano in _nanoList )
			{
				if ( !nano.alive )
				{
					_dormantList.push(nano);
				}
			}
		}//end update()
		
	}//end NanoManagerAction

}//end package