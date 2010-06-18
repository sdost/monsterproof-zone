package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.objects.TileSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Brick extends GridObject
	{
		[Embed(source = '../../../../../../../assets/GameAssets.swf', symbol = 'breakout.assets.BlockTiles_BMP')]
		private var imgCls:Class;
		
		private var _tileSet:TileSet;
		
		private var _brickFixture:b2Fixture;
		
		public function Brick(a_width:int = 1, a_height:int = 1, a_tileSet:TileSet = null)
		{
			super(a_width, a_height);
			
			if (a_tileSet)
				_tileSet = a_tileSet;
			else 
				_tileSet = new TileSet( 
					new imgCls(),
					AppSettings.instance.defaultTileWidth,
					AppSettings.instance.defaultTileHeight);
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
			
			var b2Width:Number = this.gridWidth * _tileSet.tileWidth;
			var b2Height:Number = this.gridHeight * _tileSet.tileHeight;
			
			var b2X:Number = this.gridX * _tileSet.tileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * _tileSet.tileHeight + b2Height / 2;			
			
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
		
		public function get tileSet():TileSet
		{
			return _tileSet;
		}//end get tileSet()
		
		public function notifyHit():void
		{
			activateAction(RemoveGridObjectAction.NAME);
		}//end notifyHit()
		
	}//end Brick

}//end package