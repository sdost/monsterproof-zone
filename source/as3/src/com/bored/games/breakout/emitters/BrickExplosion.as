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
	import org.flintparticles.common.initializers.ImageClass;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
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
			
			var wOffset:Number = a_brick.gridWidth * AppSettings.instance.defaultTileWidth;
			var hOffset:Number = a_brick.gridHeight * AppSettings.instance.defaultTileHeight;
			
			addInitializer( new ImageClass( RadialDot, 20 ) );
			addInitializer( new Lifetime( 0.2, 0.5 ) );
			addInitializer( new Position( new RectangleZone(xOffset, yOffset, xOffset + wOffset, yOffset + hOffset) ) );
			
			addAction( new MultiColorChange([0xFFFF00, 0xFF8200, 0xc00000]) );
			addAction( new Fade(0.8, 0.4) );
			addAction( new Age() );
		}//end constructor()
		
	}//end BrickExplosion

}//end package