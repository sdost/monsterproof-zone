package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Paddle;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.counters.PerformanceAdjusted;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.LineZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CollectionFizzle extends Emitter2D
	{
		public function CollectionFizzle(a_paddle:Paddle) 
		{	
			counter = new Blast(15);
			
			addInitializer( new ImageClass( RadialDot, 5, 0xFFFFFF ) );
			addInitializer( new ColorInit( 0xffcc33, 0xffffcc ) );
			addInitializer( new Lifetime( 0.1, 1.1 ) );
			addInitializer( new Position( new LineZone( new Point(a_paddle.x, a_paddle.y), new Point(a_paddle.x + a_paddle.width, a_paddle.y) ) ) );
			addInitializer( new Velocity( new DiscSectorZone( new Point(), 50, 1, Math.PI, Math.PI * 2 ) ) );
			
			addAction( new Age() );
			addAction( new Fade() );
			addAction( new Move() );
		}//end constructor()
		
	}//end CollectionFizzle

}//end package