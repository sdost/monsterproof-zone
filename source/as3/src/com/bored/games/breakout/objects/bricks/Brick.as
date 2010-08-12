package com.bored.games.breakout.objects.bricks 
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Filter;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.RemoveGridObjectAction;
	import com.bored.games.breakout.actions.SpawnCollectable;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.objects.Ball;
	import com.bored.games.breakout.objects.Grid;
	import com.bored.games.breakout.objects.GridObject;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
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
		
		private var _hitPoints:int;
		
		public function Brick(a_width:int, a_height:int, a_set:AnimationSet)
		{
			super(a_width, a_height);
			
			_animationSet = a_set;
			
			_animatedSprite = _animationSet.getAnimation(DEFAULT);
			
			_hitPoints = 1;
		}//end constructor()
		
		public function get hitPoints():int
		{
			return _hitPoints;
		}//end hitPoint()
		
		public function set hitPoints(a_hp:int):void
		{
			_hitPoints = a_hp;
		}//end set hitPoint()
		
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
			var b2Width:Number = this.gridWidth * AppSettings.instance.defaultTileWidth;
			var b2Height:Number = this.gridHeight * AppSettings.instance.defaultTileHeight;
			
			this.width = b2Width;
			this.height = b2Height;
			
			var b2X:Number = this.gridX * AppSettings.instance.defaultTileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * AppSettings.instance.defaultTileHeight + b2Height / 2;			
			
			b2Def.polygon.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2, new V2( b2X / PhysicsWorld.PhysScale, b2Y / PhysicsWorld.PhysScale ) );
			
			/*
			var filter:b2Filter = new b2Filter();
			filter.categoryBits = GameView.id_Brick;
			filter.maskBits = GameView.id_Ball | GameView.id_Bullet | GameView.id_Collectable;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Brick;
			b2Def.fixture.filter.maskBits = GameView.id_Ball | GameView.id_Bullet | GameView.id_Collectable;
			b2Def.fixture.density = 0.0;
			b2Def.fixture.userData = this;
			b2Def.fixture.isSensor = false;
			
			_brickFixture = b2Def.fixture.create(_grid.gridBody);
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
		
		public function notifyHit(a_damage:int):Boolean
		{
			_hitPoints -= a_damage;
			
			if ( _hitPoints <= 0 )
			{
				activateAction(RemoveGridObjectAction.NAME);			
				return true;
			}
			
			return false;
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