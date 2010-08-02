package com.bored.games.breakout.objects.bricks 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.MeltBrickAction;
	import com.bored.games.breakout.objects.AnimationSet;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.sven.utils.AppSettings;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LimpBrick extends Brick
	{
		public function LimpBrick(a_width:int, a_height:int, a_set:AnimationSet) 
		{
			super(a_width, a_height, a_set);
		}//end constructor()
		
		override protected function initializeActions():void 
		{
			super.initializeActions();
		}//end initializeActions()
		
		override protected function initializePhysics():void
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = this.gridWidth * AppSettings.instance.defaultTileWidth;
			var b2Height:Number = this.gridHeight * AppSettings.instance.defaultTileHeight;
			
			var b2X:Number = this.gridX * AppSettings.instance.defaultTileWidth + b2Width / 2;
			var b2Y:Number = this.gridY * AppSettings.instance.defaultTileHeight + b2Height / 2;			
			
			shape.SetAsOrientedBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2, new b2Vec2( b2X / PhysicsWorld.PhysScale, b2Y / PhysicsWorld.PhysScale ) );
			
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Brick;
			filter.maskBits = GameView.id_Ball | GameView.id_Bullet | GameView.id_Collectable;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.filter = filter;
			fd.userData = this;
			fd.isSensor = true;
			
			_brickFixture = _grid.gridBody.CreateFixture(fd);
		}//end initializePhysics()
		
		override public function notifyHit(a_damage:int):Boolean 
		{
			if ( super.notifyHit(a_damage) )
			{
				addAction(new MeltBrickAction(this));
				activateAction(MeltBrickAction.NAME);
				
				return true;
			}
			
			return false;
		}//end notifyHit()
		
		override public function destroy():void 
		{
			removeAction(MeltBrickAction.NAME);
			
			super.destroy();
		}//end destroy()
		
	}//end LimpBrick

}//end package