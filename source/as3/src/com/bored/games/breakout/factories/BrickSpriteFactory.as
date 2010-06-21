package com.bored.games.breakout.factories 
{
	import com.bored.games.breakout.objects.BrickSprite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author sam
	 */
	public class BrickSpriteFactory
	{
		
		public static function generateBrickSprite( clip:MovieClip ):BrickSprite
		{
			var sprite:BrickSprite = new BrickSprite();
			
			var bmd:BitmapData = new BitmapData(clip.width, clip.height);
			
			for ( var i:uint = 1; i <= clip.totalFrames; i++ )
			{
				clip.gotoAndStop(i);
				
				bmd.fillRect(bmd.rect, 0x00000000);
				bmd.draw(clip);
				
				sprite.addFrame(bmd.clone());
			}
			
			bmd.dispose();
			bmd = null;
			
			return sprite;
		}//end generateBrickSprite()
		
	}//end BrickSpriteFactory

}//end package