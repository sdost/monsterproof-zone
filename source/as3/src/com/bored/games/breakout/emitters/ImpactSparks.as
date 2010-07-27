package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Ball;
	import com.greensock.easing.Quad;
	import com.greensock.layout.ScaleMode;
	import com.sven.utils.AppSettings;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.TargetScale;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.Pulse;
	import org.flintparticles.common.counters.Random;
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.displayObjects.Star;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.ScaleImageInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Explosion;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.actions.ScaleAll;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.common.actions.ColorChange;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ImpactSparks extends Emitter2D
	{
		
		public function ImpactSparks(a_pos:Point, a_angle:Number) 
		{
			this.counter = new Blast( 5 );
			
			addInitializer( new ImageClass( RadialDot, 3, 0xFFFFFFFF ) );
			addInitializer( new Lifetime( 0.275, 0.329 ) );			
			addInitializer( new Position( new PointZone( a_pos ) ) );
			addInitializer( new Velocity( new DiscSectorZone( new Point(0,0), 100, 0, a_angle - Math.PI/2, a_angle + Math.PI/2  ) ) );
			addInitializer( new ScaleImageInit( 0.5, 1.0 ) );
			
			addAction( new ScaleAll( 1, 0.8 ) );
			addAction( new ColorChange( 0xFFFF88, 0xFFCC00 ) );
			addAction( new Move() );
			addAction( new Age() );
			addAction( new Fade(0.8, 0.5) );
			addAction( new Accelerate( 0, 200 ) );
			addAction( new RandomDrift( 300.0, 300.0 ) );
		}//end constructor()
		
	}//end ImpactSparks

}//end package