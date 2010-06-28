package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.actions.MultiColorChange;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.sven.utils.AppSettings;
	import flash.display.BlendMode;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BrickExplosion extends Emitter2D
	{
		
		public function BrickExplosion(a_brick:Brick) 
		{
			counter = new Blast(50);
			
			var xOffset:Number = a_brick.gridX * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = a_brick.gridY * AppSettings.instance.defaultTileHeight;
			
			addInitializer( new Lifetime( 0.2, 0.5 ) );
			addInitializer( new Position( new BitmapDataZone( a_brick.brickSprite.currFrame, xOffset, yOffset ) ) );
			addInitializer( new SharedImage( new RadialDot( 5, 0xFFFFFF, BlendMode.SCREEN ) ) );
			
			addAction( new MultiColorChange([0xFFFF00, 0xFF8200, 0xc00000]) );
			addAction( new Fade(1.0, 0.4) );
			addAction( new Age() );
			addAction( new Move() );
			addAction( new ScaleImage(1, 6) );
			addAction( new RandomDrift( 30.0, 30.0 ) );
		}//end constructor()
		
	}//end BrickExplosion

}//end package