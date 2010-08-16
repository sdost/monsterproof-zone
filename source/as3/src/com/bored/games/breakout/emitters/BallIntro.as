package com.bored.games.breakout.emitters 
{
	import Box2DAS.Common.V2;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.sven.utils.AppSettings;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.TargetColor;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.Line;
	import org.flintparticles.common.displayObjects.Star;
	import org.flintparticles.common.energyEasing.Quadratic;
	import org.flintparticles.common.initializers.AlphaInit;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Explosion;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.RotateToDirection;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.particles.Particle2DUtils;
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.PointZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BallIntro extends Emitter2D
	{
		
		public function BallIntro( a_ball:Ball )
		{		
			var pos:V2 = a_ball.physicsBody.GetPosition();
			
			var x:Number = (pos.x * PhysicsWorld.PhysScale - a_ball.initialFrame.width / 2);
			var y:Number = (pos.y * PhysicsWorld.PhysScale - a_ball.initialFrame.height / 2);
						
			addInitializer( new Lifetime( 2.0 ) );
			addInitializer( new Position( new DiscZone( new Point(x, y), 200 ) ) );
			addInitializer( new AlphaInit( 0.5 ) );
			
			var particles:Array = Particle2DUtils.createRectangleParticlesFromBitmapData( a_ball.initialFrame, 1, this.particleFactory );
			addExistingParticles(particles, true);
			
			addAction( new Fade(0.5, 1.0) );
			addAction( new Age( Quadratic.easeIn ) );
			addAction( new Move() );
			//addAction( new Accelerate( 0, 200 ) );
		
			addAction( new TweenToZone( new BitmapDataZone( a_ball.initialFrame, x, y ) ) );
		
			//addAction( new RandomDrift( 30.0, 30.0 ) );
			//addAction( new LinearDrag( 0.5 ) );
		}//end constructor()
		
	}//end BallIntro

}//end package