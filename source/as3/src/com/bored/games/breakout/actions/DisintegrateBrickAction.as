package com.bored.games.breakout.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.BrickCrumbs;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.objects.GameElement;
	import flash.events.Event;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DisintegrateBrickAction extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.DisintegrateBrickAction";
		
		private var _renderer:Renderer;
		private var _x:Number;
		private var _y:Number;
		private var _speed:Number;
	
		public function DisintegrateBrickAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
			_renderer = a_params.renderer as Renderer;
			_x = a_params.ballX;
			_y = a_params.ballY;
			_speed = a_params.ballSpeed;
		}//end initParams()
		
		override public function startAction():void 
		{
			_finished = false;
			
			var emitter:BrickCrumbs = new BrickCrumbs( (_gameElement as Brick), _x, _y, _speed);
			emitter.addEventListener( EmitterEvent.EMITTER_EMPTY, finishAction, false, 0, true );
			_renderer.addEmitter(emitter);
			emitter.start();
		}//end startAction()
		
		private function finishAction(e:Event):void
		{
			Emitter2D(e.currentTarget).removeEventListener( EmitterEvent.EMITTER_EMPTY, finishAction);
			
			_finished = true;
			
			_renderer.removeEmitter(Emitter2D(e.currentTarget));
			_renderer = null;
		}//end finishAction()
		
	}//end DisintegrateBrickAction

}//end package