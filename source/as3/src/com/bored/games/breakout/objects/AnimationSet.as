package com.bored.games.breakout.objects 
{
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimationSet extends GameElement
	{
		private var _activeAnimation:AnimatedSprite;
		private var _loopActive:Boolean;
		
		private var _animations:Dictionary;
		
		public function AnimationSet(a_obj:Object = null, a_defaultAnim:String = null)
		{
			super();
			
			_animations = new Dictionary();
			
			if (a_obj)
			{
				for ( var key:String in a_obj )
				{
					_animations[key] = a_obj;
				}
			}
			
			if (a_defaultAnim)
			{
				_activeAnimation = _animations[a_defaultAnim];
			}
			
		}//end constructor()
		
		public function addAnimation( a_name:String, a_anim:AnimatedSprite ):void
		{
			_animations[a_name] = a_anim;
		}//end addAnimation()
		
		public function getAnimation(a_str:String):AnimatedSprite
		{
			return _animations[a_str];
		}//end getAnimation()
		
	}//end AnimationSet

}//end package