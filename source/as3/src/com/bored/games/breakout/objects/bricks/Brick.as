package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.actions.SpawnCollectable;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.BitmapData;
	import org.flintparticles.common.renderers.Renderer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Brick extends GridObject
	{
		// Animation State
		public static const DEFAULT:String = "default";
		
		protected var _brickFixture:b2Fixture;
		
		protected var _animatedSprite:AnimatedSprite;
		
		protected var _animationSet:AnimationSet;
		
		public function Brick(a_width:int, a_height:int, a_set:AnimationSet)
		{
			super(a_width, a_height);
			
			_animationSet = a_set;
			
			_animatedSprite = _animationSet.getAnimation(DEFAULT);
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
		
		override protected function initializeActions():void
		{
			super.initializeActions();
			
			//addAction(new SpawnPointBubbles(this));
		}//end initializeActions
				
		protected function initializePhysics():void
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
		
		public function isCollidable():Boolean
		{
			return !_brickFixture.IsSensor();
		}//end isCollidable()
		
		private function cleanupPhysics():void
		{
			if ( _grid ) 
			{				
				_grid.gridBody.DestroyFixture(_brickFixture);
				_brickFixture = null;
			}
		}//end cleanupPhysics()
		
		public function get currFrame():BitmapData
		{
			return _animatedSprite.currFrame;
		}//end get currFrame()
		
		public function notifyHit():void
		{
			activateAction(RemoveGridObjectAction.NAME);
			
			if ( Math.random() < 0.3 )
			{
				addAction(new SpawnCollectable(this));
				activateAction(SpawnCollectable.NAME);
			}
		}//end notifyHit()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			_animatedSprite.update(t);
		}//end update()
		
		override public function destroy():void 
		{
			super.destroy();
		}//end destroy()
			
	}//end Brick

}//end package