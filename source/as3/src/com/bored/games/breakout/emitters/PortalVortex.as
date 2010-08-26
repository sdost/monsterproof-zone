package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.actions.MultiColorChange;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.bricks.Portal;
	import com.sven.utils.AppSettings;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.particles.Particle2DUtils;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.DiscZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PortalVortex extends Emitter2D
	{
		
		public function PortalVortex(a_screen:Bitmap, a_portal:Portal) 
		{
			addInitializer( new Lifetime( 10.0 ) );
			
			addAction( new Age() );
			addAction( new Move() );
						
			var particles:Array = Particle2DUtils.createRectangleParticlesFromBitmapData(a_screen.bitmapData, 16, this.particleFactory, 0, 0);
			addExistingParticles(particles, true);			
			
			var xOffset:Number = a_portal.x + a_portal.gridWidth / 2 * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = a_portal.y + a_portal.gridHeight / 2 * AppSettings.instance.defaultTileHeight;
			
			addAction( new GravityWell( 500, xOffset, yOffset, 250 ) );
			addAction( new DeathZone( new DiscZone( new Point( xOffset, yOffset ), a_portal.gridWidth / 2 * AppSettings.instance.defaultTileWidth ) ) );
		}//end constructor()
		
	}//end PortalVortex

}//end package