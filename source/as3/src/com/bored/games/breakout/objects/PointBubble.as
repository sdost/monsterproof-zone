package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.adobe.utils.NumberFormatter;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PointBubble extends GameElement
	{
		private var _bubbleBody:b2Body;
				
		public function PointBubble(a_x:Number, a_y:Number)
		{
			initializePhysicsBody(a_x, a_y);
		}//end constructor()
		
		private function initializePhysicsBody(a_x:Number, a_y:Number):void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.allowSleep = true;
			bd.userData = this;
			bd.position.Set(a_x / PhysicsWorld.PhysScale, a_y / PhysicsWorld.PhysScale);
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = new b2CircleShape( 5 / PhysicsWorld.PhysScale );
			fd.density = 1.0;
			fd.friction = 0.3;
			fd.restitution = 0.2;
			//fd.isSensor = true;
			fd.userData = this;
			
			_bubbleBody = PhysicsWorld.CreateBody(bd);
			_bubbleBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		public function get physicsBody():b2Body
		{
			return _bubbleBody;
		}//end get physicsBody()
		
		public function cleanupPhysics():void
		{
			PhysicsWorld.DestroyBody(_bubbleBody);
			_bubbleBody = null;
		}//end cleanupPhysics()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			//_bubbleBody.ApplyForce( new b2Vec2(0.0, -20.0 * _bubbleBody.GetMass()), _bubbleBody.GetWorldCenter() );
			
			var pos:b2Vec2 = _bubbleBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
		}//end update()
		
	}//end PointBubble

}//end package