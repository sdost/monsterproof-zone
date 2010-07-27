package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Paddle;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.PerformanceAdjusted;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.threeD.actions.ScaleAll;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.MutualGravity;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.PointZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class InvinciballTrail extends Emitter2D
	{
		public function InvinciballTrail(a_ball:Ball) 
		{	
			counter = new PerformanceAdjusted( 15, 50, 24 );
			
			addInitializer( new ImageClass( RadialDot, 3 * a_ball.width / 4, 0xFFFFCC, BlendMode.SCREEN ) );
			addInitializer( new Lifetime( 0.5, 0.7 ) );
			addInitializer( new Position( new PointZone( new Point(a_ball.width / 2, a_ball.height / 2) ) ) );
			
			addAction( new ColorChange( 0xFFFFCC, 0xFF0000 ) );
			addAction( new Age() );
			addAction( new Fade() );
			addAction( new Move() );
			addAction( new ScaleAll(1, 0) );
		}//end constructor()
		
	}//end InvinciballTrail

}//end package