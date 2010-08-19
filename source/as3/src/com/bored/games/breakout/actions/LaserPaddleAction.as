package com.bored.games.breakout.actions 
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Bullet;
	import com.bored.games.breakout.objects.Paddle;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.input.Input;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LaserPaddleAction extends Action
	{		
		public static const NAME:String = "com.bored.games.breakout.actions.LaserPaddleAction";
		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.LaserBullet_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		private var _sprite:AnimatedSprite;
		
		private var _startTime:int;
		private var _effectTime:int;
		
		private var _fireRate:int;
		private var _lastBullet:int;
		
		public function LaserPaddleAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			_sprite = sprite;
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
			_effectTime = a_params.time;
			_fireRate = a_params.fireRate;
		}//end initParams()
		
		override public function startAction():void 
		{			
			_startTime = getTimer();
			
			_lastBullet = 0;
			
			this.finished = false;
		}//end startAction()
		
		override public function update(a_time:Number):void 
		{
			if ( (getTimer() - _startTime) > _effectTime )
			{
				
				this.finished = true;
			}
			else	
			{
				if ( Input.mouseDown )
				{					
					if( getTimer() - _lastBullet > _fireRate )
					{
						var snd:MightySound = MightySoundManager.instance.getMightySoundByName("sfxPaddleLaserFire");
						if (snd) snd.play();
						
						var bullet:Bullet = new Bullet(_sprite);
						var offsetX:Number = (_gameElement.x + 4) / PhysicsWorld.PhysScale;
						var offsetY:Number = _gameElement.y / PhysicsWorld.PhysScale;
						bullet.physicsBody.SetTransform( new V2( offsetX, offsetY ), 0 );
						bullet.physicsBody.ApplyImpulse( new V2( 0, -30 * bullet.physicsBody.GetMass() ), bullet.physicsBody.GetWorldCenter() );
						
						GameView.Bullets.append(bullet);
						
						bullet = new Bullet(_sprite);
						offsetX = (_gameElement.x + _gameElement.width - 6) / PhysicsWorld.PhysScale;
						bullet.physicsBody.SetTransform( new V2( offsetX, offsetY ), 0 );
						bullet.physicsBody.ApplyImpulse( new V2( 0, -30 * bullet.physicsBody.GetMass() ), bullet.physicsBody.GetWorldCenter() );
						
						GameView.Bullets.append(bullet);
						
						_lastBullet = getTimer();
					}
				}
			}
			
		}//end update()
		
		override public function set finished(value:Boolean):void 
		{
			_finished = value;
			
			if (_finished)
			{
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_LASER_OUT);
			}
			else
			{
				(_gameElement as Paddle).switchAnimation(Paddle.PADDLE_LASER_IN);
			}
		}//end set finished()
		
	}//end LaserPaddleAction

}//end package