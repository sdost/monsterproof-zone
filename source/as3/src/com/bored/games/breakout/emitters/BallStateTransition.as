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
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.displayObjects.Star;
	import org.flintparticles.common.energyEasing.Quadratic;
	import org.flintparticles.common.initializers.AlphaInit;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ImageClass;
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
	public class BallStateTransition extends Emitter2D
	{
		public function BallStateTransition( a_ball:Ball, a_color1:uint, a_color2:uint )
		{	
			counter = new Blast(100);
			
			var pos:V2 = a_ball.physicsBody.GetPosition();
			
			var x:Number = (pos.x * PhysicsWorld.PhysScale - a_ball.initialFrame.width / 2);
			var y:Number = (pos.y * PhysicsWorld.PhysScale - a_ball.initialFrame.height / 2);
			
			addInitializer( new ImageClass( RadialDot, 2 ) );
			addInitializer( new ColorInit( a_color1, a_color2 ) );
			addInitializer( new Lifetime( 0.5, 0.75 ) );
			addInitializer( new Position( new DiscZone( new Point(x, y), a_ball.width / 2, a_ball.width / 2) ) );
			addInitializer( new Velocity( new DiscZone( new Point(), 200, 200 ) ) );
			
			addAction( new Fade() );
			addAction( new Age( Quadratic.easeOut ) );
			addAction( new Move() );
		}//end constructor()
		
	}//end BallStateTransition

}//end package