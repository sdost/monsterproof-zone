package com.bored.games.breakout.objects 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Paddle extends GameElement
	{
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Paddle_BMP')]
		private static var imgCls:Class;
		
		private static var _paddleBmp:Bitmap = new imgCls();
		
		private var _paddleBody:b2Body;
		
		public function Paddle() 
		{
			super();
			
			_paddleBmp = new imgCls();
			
			initializePhysicsBody();
			initializeActions();			
		}//end constructor()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			bd.allowSleep = false;
			bd.userData = this;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox( (_paddleBmp.bitmapData.width / 2) / PhysicsWorld.PhysScale, (_paddleBmp.bitmapData.height / 2) / PhysicsWorld.PhysScale );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.density = 1.0;
			fd.friction = 0.0;
			fd.restitution = 1.0;
			fd.userData = this;
			
			_paddleBody = PhysicsWorld.CreateBody(bd);
			_paddleBody.CreateFixture(fd);
		}//end initializePhysicsBody()
		
		private function initializeActions():void
		{
			
		}//end intializeActions()
		
		public function get physicsBody():b2Body
		{
			return _paddleBody;
		}//end get physicsBody()
		
		public function get bitmap():Bitmap
		{
			return _paddleBmp;
		}//end get bitmap()
		
		override public function get width():Number
		{
			return _paddleBmp.bitmapData.width;
		}//end get width()
		
		override public function get height():Number
		{
			return _paddleBmp.bitmapData.height;
		}//end get height()
		
		override public function update(t:Number = 0):void 
		{
			super.update(t);
			
			var pos:b2Vec2 = _paddleBody.GetPosition();
			
			this.x = pos.x * PhysicsWorld.PhysScale;
			this.y = pos.y * PhysicsWorld.PhysScale;
		}//end update()
		
	}//end Paddle

}//end package