package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Paddle;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
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
	public class UltimatePower extends Emitter2D
	{
		public function UltimatePower(a_paddle:Paddle) 
		{	
			counter = new PerformanceAdjusted( 15, 50, 24 );
			
			addInitializer( new ImageClass( RadialDot, 5, 0xFFFFFF ) );
			addInitializer( new ColorInit( 0x00ffff, 0x80ffff ) );
			addInitializer( new Lifetime( 0.5, 2.0 ) );
			addInitializer( new Position( new LineZone( new Point(), new Point(a_paddle.width, 0) ) ) );
			addInitializer( new Velocity( new DiscSectorZone( new Point(), 20, 10, Math.PI, Math.PI * 2 ) ) );
			
			addAction( new Age() );
			addAction( new Fade() );
			addAction( new Move() );
		}//end constructor()
		
	}//end UltimatePower

}//end package