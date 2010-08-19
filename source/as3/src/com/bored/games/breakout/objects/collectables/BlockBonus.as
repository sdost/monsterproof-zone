package com.bored.games.breakout.objects.collectables 
{
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.actions.CatchPaddleAction;
	import com.sven.factories.AnimatedSpriteFactory;
	import com.sven.animation.AnimatedSprite;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.sven.utils.AppSettings;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BlockBonus extends Collectable
	{
		[Embed(source='../../../../../../../assets/GameAssets.swf', symbol='breakout.assets.BlockBonus_MC')]
		private static var mcCls:Class;
		private static var sprite:AnimatedSprite = AnimatedSpriteFactory.generateAnimatedSprite(new mcCls());
		
		public function BlockBonus() 
		{
			super(sprite);
			
			var angle:Number = Math.random() * (2 * Math.PI);
						
			var speed:Number = Math.random() * (AppSettings.instance.bonusSpeedMax - AppSettings.instance.bonusSpeedMin) + AppSettings.instance.bonusSpeedMin; 
			
			var vx:Number = speed * Math.cos(angle);
			var vy:Number = speed * Math.sin(angle);
			
			_collectableBody.ApplyImpulse( new V2( vx, vy ), _collectableBody.GetWorldCenter() );			
		}//end constructor()
		
		override public function get actionName():String 
		{
			return "bonus";
		}//end get actionName()
				
		override public function update(t:Number = 0):void 
		{
			_animationController.update(t);
			
			var pos:V2 = _collectableBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale - width / 2;
			this.y = pos.y * PhysicsWorld.PhysScale - height / 2;
			
			var bodyVelocity:V2 = _collectableBody.GetLinearVelocity();
			
			if (Math.abs(bodyVelocity.x) <= AppSettings.instance.ballTrajectoryThreshold)
			{
				_collectableBody.ApplyForce(new V2(AppSettings.instance.ballTrajectoryAdjustFactor * _collectableBody.GetMass(), 0), _collectableBody.GetWorldCenter());
			}
			
			if (Math.abs(bodyVelocity.y) <= AppSettings.instance.ballTrajectoryThreshold)
			{
				_collectableBody.ApplyForce(new V2(0, AppSettings.instance.ballTrajectoryAdjustFactor * _collectableBody.GetMass()), _collectableBody.GetWorldCenter());
			}
		}//end update()
		
	}//end BlockBonus

}//end package