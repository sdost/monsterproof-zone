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
	public class BlockBonus extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.BlockBonusBlue_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function BlockBonus() 
		{
			super(sprite);
			
			_collectableBody.ApplyImpulse( new b2Vec2( Math.random() * 30, -5 ), _collectableBody.GetWorldCenter() );			
		}//end constructor()
		
		override public function get actionName():String 
		{
			return "bonus";
		}//end get actionName()
		
		override public function update(t:Number = 0):void 
		{
			_animatedSprite.update(t);
			
			var pos:b2Vec2 = _collectableBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale - width / 2;
			this.y = pos.y * PhysicsWorld.PhysScale - height / 2;
		}//end update()
		
	}//end BlockBonus

}//end package