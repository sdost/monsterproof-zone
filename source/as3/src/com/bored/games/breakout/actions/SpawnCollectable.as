package com.bored.games.breakout.actions 
{
	import Box2D.Common.Math.b2Vec2;
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.collectables.CatchPowerup;
	import com.bored.games.breakout.objects.collectables.Collectable;
	import com.bored.games.breakout.objects.collectables.ExtendPowerup;
	import com.bored.games.breakout.objects.collectables.LaserPowerup;
	import com.bored.games.breakout.objects.collectables.MultiballPowerup;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SpawnCollectable extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.SpawnCollectable";
		
		public function SpawnCollectable(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
		}//end initParams()
		
		override public function startAction():void 
		{	
			var brick:Brick = (_gameElement as Brick);
					
			var xOffset:Number = (brick.gridX + brick.gridWidth/2) * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = (brick.gridY + brick.gridHeight/2) * AppSettings.instance.defaultTileHeight;
			
			var die:Number = Math.random();
			
			var pb:Collectable;
			
			if( die < 0.25 )
				pb = new LaserPowerup();
			else if( die < 0.5 )
				pb = new ExtendPowerup();
			else if( die < 0.75 )
				pb = new MultiballPowerup();
			else 
				pb = new CatchPowerup();
			
			pb.physicsBody.ApplyImpulse( new b2Vec2( 0, 10 * pb.physicsBody.GetMass() ), pb.physicsBody.GetWorldCenter() );
			pb.physicsBody.SetPosition( new b2Vec2( (xOffset - pb.width / 2) / PhysicsWorld.PhysScale, (yOffset - pb.height / 2) / PhysicsWorld.PhysScale ) );
			
			GameView.Collectables.append(pb);
			
			_finished = true;
		}//end startAction()
		
	}//end SpawnCollectable

}//end package