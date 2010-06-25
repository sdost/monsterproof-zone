package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import org.flintparticles.common.renderers.Renderer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Brick extends GridObject
	{
		private var _brickFixture:b2Fixture;
		
		private var _brickSprite:AnimatedSprite;
		
		public function Brick(a_width:int, a_height:int, a_sprite:AnimatedSprite)
		{
			super(a_width, a_height);
			
			_brickSprite = a_sprite;
		}//end constructor()
		
		override public function addToGrid(a_grid:Grid, a_x:uint, a_y:uint):void 
		{
			super.addToGrid(a_grid, a_x, a_y);
			
			initializePhysics();
		}//end addToGrid()
		
		override public function removeFromGrid():void
		{
			cleanupPhysics();
			
			super.removeFromGrid();
		}//end removeFromGrid()
				
		private function initializePhysics():void
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = this.gridWidth * AppSettings.instance.defaultTileWidth;
			var b2Height:Number = this.gridHeight * AppSettings.instance.defaultTileHeight;
			
			var b2X:Number = this.gridX * AppSettings.instance.defaultTileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * AppSettings.instance.defaultTileHeight + b2Height / 2;			
			
			shape.SetAsOrientedBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2, new b2Vec2( b2X / PhysicsWorld.PhysScale, b2Y / PhysicsWorld.PhysScale ) );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.density = 0.0;
			fd.userData = this;
			
			_brickFixture = _grid.gridBody.CreateFixture(fd);
		}//end initializePhysics()
		
		private function cleanupPhysics():void
		{
			if ( _grid ) 
			{
				_grid.gridBody.DestroyFixture(_brickFixture);
				_brickFixture = null;
			}
		}//end cleanupPhysics()
		
		public function get brickSprite():AnimatedSprite
		{
			return _brickSprite;
		}//end get brickSprite()
		
		public function notifyHit():void
		{
			activateAction(RemoveGridObjectAction.NAME);
		}//end notifyHit()
		
	}//end Brick

}//end package