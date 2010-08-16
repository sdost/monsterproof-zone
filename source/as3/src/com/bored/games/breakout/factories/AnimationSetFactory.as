package com.bored.games.breakout.factories 
{
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationSet;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sam
	 */
	public class AnimationSetFactory
	{
		
		public static function generateAnimationSet( clip:MovieClip ):AnimationSet
		{
			var animSet:AnimationSet = new AnimationSet();
			
			var sprite:AnimatedSprite;
			var frameLabel:String;
			var bmd:BitmapData;
			
			for ( var i:uint = 1; i <= clip.totalFrames; i++ )
			{
				clip.gotoAndStop(i);
								
				var newFrameLabel:String = clip.currentFrameLabel;
				
				if ( newFrameLabel == null ) 
				{
					if( frameLabel )
						newFrameLabel = frameLabel;
					else
						newFrameLabel = "default";
				}
				
				if ( newFrameLabel != frameLabel )
				{
					if ( sprite )
					{
						animSet.addAnimation(frameLabel, sprite);
					}
					
					frameLabel = newFrameLabel;
					sprite = new AnimatedSprite(clip.totalFrames);
					
					bmd = new BitmapData(clip.width, clip.height);
					bmd.fillRect(bmd.rect, 0x00000000);
			
					sprite.addFrame(bmd);
				}
				
				bmd = new BitmapData(clip.width, clip.height);
				
				bmd.fillRect(bmd.rect, 0x00000000);
				bmd.draw(clip);
				
				sprite.addFrame(bmd);
			}
			
			if ( sprite )
			{
				animSet.addAnimation(frameLabel, sprite);
			}
			
			return animSet;
		}//end generateAnimationSet()
		
	}//end AnimationSetFactory

}//end package