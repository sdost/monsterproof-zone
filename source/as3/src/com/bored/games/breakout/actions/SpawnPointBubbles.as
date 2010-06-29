package com.bored.games.breakout.actions 
{
	import Box2D.Common.Math.b2Vec2;
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.PointBubble;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SpawnPointBubbles extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.SpawnPointBubbles";
		
		public function SpawnPointBubbles(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
		}//end initParams()
		
		override public function startAction():void 
		{	
			var count:uint = uint(Math.random() * 5);
			
			for ( var i:uint = 0; i < count; i++ )
			{
				var brick:Brick = (_gameElement as Brick);
					
				var xOffset:Number = (brick.gridX + brick.gridWidth/2) * AppSettings.instance.defaultTileWidth;
				var yOffset:Number = (brick.gridY + brick.gridHeight/2) * AppSettings.instance.defaultTileHeight;
				
				var pb:PointBubble = new PointBubble( xOffset, yOffset );
				pb.physicsBody.ApplyForce( new b2Vec2( (Math.random() * 40 - 20) * pb.physicsBody.GetMass(), (Math.random() * -20) * pb.physicsBody.GetMass()), pb.physicsBody.GetWorldCenter() );
			}
			
			_finished = true;
		}//end startAction()
		
	}//end SpawnPointBubbles

}//end package