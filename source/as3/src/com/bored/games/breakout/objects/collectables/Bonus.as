package com.bored.games.breakout.objects.collectables 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.bored.games.breakout.factories.AnimatedSpriteFactory;
	import com.bored.games.breakout.objects.AnimatedSprite;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Bonus extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Bonus_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function Bonus() 
		{
			super(sprite);
		}//end constructor()
		
		override protected function initializePhysics():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.allowSleep = false;
			bd.userData = this;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			var b2Width:Number = _animatedSprite.currFrame.width;
			var b2Height:Number = _animatedSprite.currFrame.height;
			
			shape.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2 );
			
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Collectable;
			filter.maskBits = GameView.id_Paddle | GameView.id_Brick;
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.filter = filter;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 0.0;
			fd.userData = this;
			
			_collectableBody = PhysicsWorld.CreateBody(bd);
			_collectableBody.CreateFixture(fd);
		}//end initializePhysics()
		
		override public function get actionName():String 
		{
			return "bonus";
		}//end get actionName()
		
	}//end Bonus

}//end package