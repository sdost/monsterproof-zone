package com.bored.games.breakout.emitters 
{
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.sven.utils.AppSettings;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.RadialDot;
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
			counter = new Blast(20);
			
			var xOffset:Number = a_brick.gridX * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = a_brick.gridY * AppSettings.instance.defaultTileHeight;
			
			addInitializer( new Lifetime( 0.5, 1.5 ) );
			addInitializer( new Position( new BitmapDataZone( a_brick.brickSprite.currFrame, xOffset, yOffset ) ) );
			addInitializer( new SharedImage( new RadialDot( 10 ) ) );
			
			addAction( new Fade(1.0, 0.0) );
			addAction( new ColorChange(0xFFFFFF, 0x663300) );
			addAction( new Age() );
			addAction( new Move() );
			addAction( new ScaleImage(1, 5) );
			addAction( new RandomDrift( 30.0, 30.0 ) );
		}//end constructor()
		
	}//end BrickExplosion

}//end package