package com.bored.games.breakout.actions 
{
	import com.greensock.TweenMax;
	import flash.geom.ColorTransform;
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.interpolateColors;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MultiColorChange extends ActionBase
	{
		private var _colors:Array = [];
		private var _interval:Number;
		
		public function MultiColorChange(a_colors:Array) 
		{
			super();
			
			this.colors = a_colors;
		}//end constructor()
		
		/**
		 * The color of the particle when its energy is 1.
		 */
		public function get colors():Array
		{
			return _colors;
		}
		public function set colors( a_colors:Array ):void
		{
			_colors = a_colors;
			
			_interval = 1 / _colors.length;
		}

		/**
		 * Sets the color of the particle based on the colors and the particle's 
		 * energy level.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter that created the particle.
		 * @param particle The particle to be updated.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Action#update()
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{		
			var ind1:uint = Math.floor( (1 - particle.energy) / _interval);
			var ind2:uint = Math.ceil( (1 - particle.energy) / _interval);
			
			var amt:Number = ( (1 - particle.energy) - (_interval * ind1) ) / _interval;
			
			particle.color = interpolateColors( _colors[ind1], _colors[ind2], amt );
		}
		
	}//end MultiColorChange

}//end package