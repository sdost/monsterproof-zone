package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.sven.utils.AppSettings;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.TargetColor;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.Line;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.displayObjects.Star;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.DeathZone;
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
	public class BrickMelt extends Emitter2D
	{
		
		public function BrickMelt( a_brick:Brick )
		{		
			counter = new Blast(6);
			
			var xOffset:Number = a_brick.gridX * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = a_brick.gridY * AppSettings.instance.defaultTileHeight;
			
			addInitializer( new ImageClass( Dot, 2, 0x57d8dd, BlendMode.SCREEN ) );
			addInitializer( new Lifetime( 0.5, 0.8 ) );
			addInitializer( new Position( new BitmapDataZone( a_brick.currFrame, xOffset, yOffset ) ) );
			
			addAction( 
				new Explosion( 
					Math.random() * 3 + 1,
					(a_brick.gridX + a_brick.gridWidth / 2) * AppSettings.instance.defaultTileWidth,
					(a_brick.gridY + a_brick.gridHeight) * AppSettings.instance.defaultTileHeight,
					1000
				)
			);
			
			addAction( new Fade(0.8, 0.4) );
			addAction( new Age() );
			addAction( new Move() );
			addAction( new Accelerate(0, 200) );
		}//end constructor()
		
	}//end BrickMelt

}//end package