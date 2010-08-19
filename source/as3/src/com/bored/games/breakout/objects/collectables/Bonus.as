package com.bored.games.breakout.objects.collectables 
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
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
			b2Def.body.type = b2Body.b2_dynamicBody;
			b2Def.body.fixedRotation = true;
			b2Def.body.allowSleep = true;
			b2Def.body.userData = this;
			b2Def.body.linearDamping = 0.0;
			b2Def.body.inertiaScale
			
			var b2Width:Number = _animatedSprite.currFrame.width;
			var b2Height:Number = _animatedSprite.currFrame.height;
			
			b2Def.polygon.SetAsBox( (b2Width / PhysicsWorld.PhysScale) / 2,  (b2Height / PhysicsWorld.PhysScale) / 2 );
			
			/*
			var filter:b2FilterData = new b2FilterData();
			filter.categoryBits = GameView.id_Collectable;
			filter.maskBits = GameView.id_Paddle | GameView.id_Brick;
			*/
			
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.filter.categoryBits = GameView.id_Collectable;
			b2Def.fixture.filter.maskBits = GameView.id_Paddle | GameView.id_Brick;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.friction = 0.0;
			b2Def.fixture.restitution = 0.0;
			b2Def.fixture.userData = this;
			b2Def.fixture.isSensor = false;
			
			_collectableBody = PhysicsWorld.CreateBody(b2Def.body);
			var fixture:b2Fixture = b2Def.fixture.create(_collectableBody);
			fixture.m_reportBeginContact = true;
			fixture.m_reportEndContact = true;
		}//end initializePhysics()
		
		override public function get actionName():String 
		{
			return "bonus";
		}//end get actionName()
		
	}//end Bonus

}//end package