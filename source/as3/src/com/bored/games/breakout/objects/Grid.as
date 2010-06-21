package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Grid extends GameElement
	{
		private static const MAX_GRID_OBJECTS:int = 100;
		
		private var _gridWidth:int;
		private var _gridHeight:int;
		
		private var _gridObjectList:Vector.<GridObject>;
		private var _gridRemoveList:Vector.<GridObject>;
		private var _grid:Vector.<int>;
		
		private var _gridBody:b2Body;
		
		private var _count:int;
			
		private var _shift:int;
		
		public function Grid( a_width:int, a_height:int ) 
		{
			_gridWidth = a_width;
			_gridHeight = a_height;
			
			_shift = 0;
			var minLength:int = _gridWidth * _gridHeight;
			var powOfTwo:int = 1;
			while ( powOfTwo < minLength )
			{
				powOfTwo *= 2;
				_shift++;
			}
			
			_gridObjectList = new Vector.<GridObject>(MAX_GRID_OBJECTS, true);
			_gridRemoveList = new Vector.<GridObject>();
			
			_count = 0;
		
			generate();
			
			initializePhysics();
		}//end constructor()
		
		private function initializePhysics():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_staticBody;
			
			_gridBody = PhysicsWorld.CreateBody(bd);
		}//end initializePhysics()
		
		public function get gridBody():b2Body
		{
			return _gridBody;
		}//end function get gridBody()
		
		public function get gridWidth():int
		{
			return _gridWidth;
		}//end get gridWidth()
		
		public function get gridHeight():int
		{
			return _gridHeight;
		}//end get gridHeight()
		
		private function generate():void
		{
			_grid = new Vector.<int>(100 << _shift, true);
			
			for ( var i:int = 0; i < _grid.length; i++)
			{
				_grid[i] = -1;
			}
		}//end generate()
		
		public function addGridObject( a_obj:GridObject, a_x:int, a_y:int ):Boolean
		{			
			var rightBounds:int = a_x + a_obj.gridWidth;
			var bottomBounds:int = a_y + a_obj.gridHeight;
			
			if ( a_x < 0 ) return false;
			
			if ( a_y < 0 ) return false;
			
			if ( rightBounds > _gridWidth ) return false;
			
			if ( bottomBounds > _gridHeight ) return false;
			
			var x:int, y:int;
			
			for ( x = a_x; x < rightBounds; x++ )
			{
				for ( y = a_y; y < bottomBounds; y++ )
				{
					if ( _grid[(x << _shift) | y] >= 0 )
						return false;
				}
			}
			
			var i:uint;
			for ( i = 0; i < MAX_GRID_OBJECTS; i++ )
			{
				if ( _gridObjectList[i] == null ) break;
			}
			_gridObjectList[i] = a_obj;
			a_obj.addToGrid(this, a_x, a_y);
			
			for ( x = a_x; x < rightBounds; x++ )
			{
				for ( y = a_y; y < bottomBounds; y++ )
				{
					_grid[(x << _shift) | y] = i;
				}
			}
			
			return true;
		}//end addGridObject()
		
		public function removeGridObject(a_go:GridObject):Boolean
		{
			var ind:uint = _gridObjectList.indexOf(a_go);
			if ( ind < 0 ) return false;
			
			var rightBounds:int = a_go.gridX + a_go.gridWidth;
			var bottomBounds:int = a_go.gridY + a_go.gridHeight;
			
			var x:int, y:int;
			
			for ( x = a_go.gridX; x < rightBounds; x++ )
			{
				for ( y = a_go.gridY; y < bottomBounds; y++ )
				{
					_grid[(x << _shift) | y] = -1; 
				}
			}			
			
			_gridRemoveList.push(a_go);
			
			return true;
		}//end removeGridObject()
		
		public function getGridObjectAt( a_x:int, a_y:int ):GridObject
		{
			if ( a_x < 0 || a_y < 0 ) return null;
			
			var ind:int = _grid[(a_x << _shift) | a_y];
			
			if( ind >= 0 )
				return _gridObjectList[ind];
			else 
				return null;
		}//end getGridObjectAt()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			var go:GridObject;
			while( _gridRemoveList.length > 0 )
			{
				go = _gridRemoveList.pop();
				var ind:uint = _gridObjectList.indexOf(go);
				_gridObjectList[ind] = null;
				go.removeFromGrid();
			}
			
			for ( var i:uint = 0; i < _gridObjectList.length; i++ )
			{
				if( _gridObjectList[i] )
					_gridObjectList[i].update(t);
			}
		}//end update()
		
	}//end Grid

}//end package