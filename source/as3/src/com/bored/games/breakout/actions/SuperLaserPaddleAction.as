package com.bored.games.breakout.actions 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.emitters.UltimatePower;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Beam;
	import com.bored.games.breakout.objects.Bullet;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.input.Input;
	import com.bored.games.objects.GameElement;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SuperLaserPaddleAction extends Action
	{		
		public static const NAME:String = "com.bored.games.breakout.actions.SuperLaserPaddleAction";
		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.SuperLaserBeam_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		private var _sprite:AnimatedSprite;
		private var _emitter:Emitter2D;
		
		public function SuperLaserPaddleAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			_sprite = sprite;
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
		}//end initParams()
		
		override public function startAction():void 
		{		
			_emitter = new UltimatePower(_gameElement as Paddle);
			_emitter.useInternalTick = false;
			GameView.ParticleRenderer.addEmitter(_emitter);
			GameView.Emitters.append(_emitter);
			_emitter.start();
			
			this.finished = false;
		}//end startAction()
	
		override public function update(a_time:Number):void 
		{
			if ( _emitter )
			{
				_emitter.x = _gameElement.x;
				_emitter.y = _gameElement.y;
			}
			
			if ( Input.mouseDown )
			{					
				var beam:Beam = new Beam(_sprite);
				var offsetX:Number = (_gameElement as Paddle).physicsBody.GetPosition().x;
				var offsetY:Number = 0;
				beam.physicsBody.SetTransform( new V2( offsetX, offsetY ), 0 );
					
				GameView.Bullets.append(beam);
				
				this.finished = true;
			}			
		}//end update()
		
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				//(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_SLASER_OUT);
				if ( _emitter )
				{
					_emitter.stop();
					GameView.ParticleRenderer.removeEmitter(_emitter);
					GameView.Emitters.remove(_emitter);
					_emitter = null;
				}
			}
			else
			{
				//(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_SLASER_IN);
			}
		}//end set finished()
		
	}//end SuperLaserPaddleAction

}//end package