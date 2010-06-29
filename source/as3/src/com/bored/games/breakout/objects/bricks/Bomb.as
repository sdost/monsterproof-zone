package com.bored.games.breakout.objects.bricks 
{
	import com.bored.games.breakout.actions.ExplodeBrickAction;
	import com.bored.games.breakout.emitters.BrickExplosion;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.states.views.GameView;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.renderers.Renderer;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Bomb extends Brick
	{
		public function Bomb(a_width:int, a_height:int, a_sprite:AnimatedSprite) 
		{
			super(a_width, a_height, a_sprite);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override public function notifyHit():void 
		{			
			grid.explodeBricks(getAllNeighbors());
			
			addAction(new ExplodeBrickAction(this));
			activateAction(ExplodeBrickAction.NAME);
			
			super.notifyHit();
		}//end notifyHit()
		
		public function getAllNeighbors():Vector.<Brick>
		{
			var neighbors:Vector.<Brick> = new Vector.<Brick>();
			var go:Brick;
			
			for ( var i:uint = this.gridX - 1; i <= this.gridX + this.gridWidth; i++ )
			{
				for ( var j:uint = this.gridY - 1; j <= this.gridY + this.gridHeight; j++ )
				{
					go = this.grid.getGridObjectAt(i, j) as Brick;
					if ( go && go != this )
					{
						neighbors.push(go);
					}
				}
			}
			
			return neighbors;
		}//end getAllNeighbors()
		
		override public function update(t:Number = 0):void 
		{			
			super.update(t);
			
			_brickSprite.update(t);
		}//end update()
		
		override public function destroy():void 
		{
			removeAction(ExplodeBrickAction.NAME);
			
			super.destroy();
		}//end destroy()

	}//end Bomb

}//end package