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
	public class ExplosionManagerAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.ExplosionManagerAction";
		public static const EXPLODE_DAMAGE:int = 5;

		private var _delay:uint;
		
		private var _lastUpdate:uint;
		private var _delta:uint;
		
		private var _bombList:Vector.<Brick>;
		
		public function ExplosionManagerAction(a_gameElement:GameElement, a_params:Object = null) 
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
			
			_bombList = new Vector.<Brick>();
		}//end startAction()
		
		public function addBricks(a_bricks:Vector.<Brick>):void
		{
			var l:uint = a_bricks.length;
			for ( var i:int = 0; i < l; i++ )
			{
				if ( a_bricks[i] is NanoBrick )
				{
					if ( !(a_bricks[i] as NanoBrick).alive )
						continue;
				}
				
				if ( _bombList.indexOf(a_bricks[i]) < 0 )
				{
					_bombList.push(a_bricks[i]);
				}
			}
		}//end addBricks()
		
		override public function update(a_time:Number):void 
		{
			_delta += a_time;
			
			if ( _delta < _delay ) return;
			
			_delta = 0;
			
			var emitter:Emitter2D;
			
			if ( _bombList.length > 0 )
			{
				var go:Brick = _bombList.pop();
				
				if ( go && go.grid )
				{
					if ( go.isCollidable() )
					{
						go.addAction(new ExplodeBrickAction(go));
						go.activateAction(ExplodeBrickAction.NAME);
					}
					
					go.notifyHit(EXPLODE_DAMAGE);
				}
			}
			else
			{
				_finished = true;
			}
		}//end update()
		
	}//end ExplosionManagerAction

}//end package