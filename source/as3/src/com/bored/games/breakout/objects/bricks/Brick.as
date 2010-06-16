package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
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
		
		private var _brickBody:b2Body;
		
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
		
		override public function setGrid(a_grid:Grid):void 
		{
			super.setGrid(a_grid);
			
			if( this._grid )
				initializePhysics();
			else
				cleanup();
		}//end setGrid()
		
		private function initializePhysics():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var bodyWidth:int = this.gridWidth * _tileSet.tileWidth;
			var bodyHeight:int = this.gridHeight * _tileSet.tileHeight;
			
			shape.SetAsBox( (bodyWidth / PhysicsWorld.PhysScale) / 2,  (bodyHeight / PhysicsWorld.PhysScale) / 2 );
			
			_brickBody = PhysicsWorld.CreateBody(bd);
			_brickBody.CreateFixture2(shape);
		}//end initializePhysics()
		
		private function cleanup():void
		{
			PhysicsWorld.DestroyBody(_brickBody);
			
			_brickBody = null;
		}//end cleanup()
		
		override public function set gridX(value:uint):void 
		{
			super.gridX = value;
			
			var x:Number = (gridX * tileSet.tileWidth) - (gridWidth / 2 * tileSet.tileWidth);
			var y:Number = (gridY * tileSet.tileWidth) - (gridHeight / 2 * tileSet.tileHeight);
			
			updateBodyPosition( x, y );
		}//end set gridX()
		
		override public function set gridY(value:uint):void 
		{
			super.gridY = value;
			
			var x:Number = (gridX * tileSet.tileWidth) - (gridWidth / 2 * tileSet.tileWidth);
			var y:Number = (gridY * tileSet.tileWidth) - (gridHeight / 2 * tileSet.tileHeight);
			
			updateBodyPosition( x, y );
		}//end set gridY()
		
		private function updateBodyPosition( a_x:Number, a_y:Number ):void
		{
			_brickBody.SetPosition( new b2Vec2(a_x / PhysicsWorld.PhysScale, a_y / PhysicsWorld.PhysScale) );
		}//end updateBodyPosition()
		
		public function get tileSet():TileSet
		{
			return _tileSet;
		}//end get tileSet()
		
	}//end Brick

}//end package