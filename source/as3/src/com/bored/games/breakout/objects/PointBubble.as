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
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import org.flintparticles.common.displayObjects.RadialDot;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PointBubble extends GameElement
	{		
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Sparkle_BMP')]
		private static var imgCls:Class;
		
		private static var _bubbleBmp:Bitmap = new imgCls();
		
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
			fd.shape = new b2CircleShape( (_bubbleBmp.bitmapData.width / 2) / PhysicsWorld.PhysScale );
			fd.density = 1.0;
			fd.friction = 0.3;
			fd.restitution = 0.2;
			fd.isSensor = true;
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
		
		public function get bitmap():Bitmap
		{
			return _bubbleBmp;
		}//end get bitmap()
		
		override public function get width():Number
		{
			return _bubbleBmp.bitmapData.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _bubbleBmp.bitmapData.height;
		}//end get height()
		
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