package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.sven.utils.AppSettings;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.TargetColor;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.Line;
	import org.flintparticles.common.displayObjects.Star;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Explosion;
	import org.flintparticles.twoD.actions.RandomDrift;
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
	public class BrickCrumbs extends Emitter2D
	{
		
		public function BrickCrumbs( a_brick:Brick, a_x:Number, a_y:Number, a_speed:Number )
		{			
			addInitializer( new Lifetime( 0.0, 1.0 ) );
			
			addAction( new Fade(1.0, 0.2) );
			addAction( new Age() );
			addAction( new Move() );
			addAction( new Accelerate( 0, 200 ) );
			
			var xOffset:Number = a_brick.gridX * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = a_brick.gridY * AppSettings.instance.defaultTileHeight;
			
			var particles:Array = Particle2DUtils.createPixelParticlesFromBitmapData(a_brick.brickSprite.currFrame, this.particleFactory, xOffset, yOffset);
			addExistingParticles(particles, true);
			
			addAction( new Explosion( 2 * a_speed / Ball.SpeedLimit, a_x, a_y, 1000) );
			addAction( new RandomDrift( 30.0, 30.0 ) );
			addAction( new LinearDrag( 0.5 ) );
		}//end constructor()
		
	}//end BrickCrumbs

}//end package