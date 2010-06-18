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
	
	/**
	 * ...
	 * @author sam
	 */
	public class Paddle extends GameElement
	{
		[Embed(source='../../../../../../assets/GameAssets.swf', symbol='breakout.assets.Paddle_BMP')]
		private var imgCls:Class;
		
		private var _paddleBmp:Bitmap;
		
		private var _paddleBody:b2Body;
		
		public function Paddle() 
		{
			super();
			
			initializePhysicsBody();
			initializeActions();			
		}//end constructor()
		
		private function createArc(centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:Number):Array
		{
			var arr:Array = new Array();
			//
			// For convenience, store the number of radians in a full circle.
			var twoPI:Number = 2 * Math.PI;
			//
			// To determine the size of the angle between each point on the
			// arc, divide the overall angle by the total number of points.
			var angleStep:Number = arcAngle/steps;
			//
			// Determine coordinates of first point using basic circle math.
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			//
			// Move to the first point.
			arr.push( new b2Vec2(xx, yy) );
			//
			// Draw a line to each point on the arc.
			for(var i:uint = 1; i<=steps; i++){
				//
				// Increment the angle by "angleStep".
				var angle:Number = startAngle + i * angleStep;
				//
				// Determine next point's coordinates using basic circle math.
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				//
				// Draw a line to the next point.
				arr.push( new b2Vec2(xx, yy) );
			}
			
			return arr;
		}//end drawArc()
		
		private function initializePhysicsBody():void
		{
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.fixedRotation = true;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			
			//var arr:Array = createArc( 250, 250, 200, 45/360, -90/360, 20 ) 
			//shape.SetAsArray( arr, arr.length );
			
			shape.SetAsBox( 50 / PhysicsWorld.PhysScale, 8 / PhysicsWorld.PhysScale );
			
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.shape = shape;
			fd.density = 1.0;
			fd.friction = 1.0;
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
		
	}//end Paddle

}//end package