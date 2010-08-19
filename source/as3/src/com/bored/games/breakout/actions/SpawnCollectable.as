package com.bored.games.breakout.actions 
{
	import Box2DAS.Common.V2;
	import com.bored.games.actions.Action;
	import com.bored.games.breakout.objects.bricks.Brick;
	import com.bored.games.breakout.objects.collectables.BlockBonus;
	import com.bored.games.breakout.objects.collectables.CatchPowerup;
	import com.bored.games.breakout.objects.collectables.Collectable;
	import com.bored.games.breakout.objects.collectables.DestructoballPowerup;
	import com.bored.games.breakout.objects.collectables.ExtendPowerup;
	import com.bored.games.breakout.objects.collectables.ExtraLifePowerup;
	import com.bored.games.breakout.objects.collectables.InvinciballPowerup;
	import com.bored.games.breakout.objects.collectables.LaserPowerup;
	import com.bored.games.breakout.objects.collectables.MultiballPowerup;
	import com.bored.games.breakout.objects.collectables.SuperLaserPowerup;
	import com.bored.games.breakout.physics.PhysicsWorld;
	import com.bored.games.breakout.states.views.GameView;
	import com.bored.games.objects.GameElement;
	import com.inassets.sound.MightySound;
	import com.inassets.sound.MightySoundManager;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SpawnCollectable extends Action
	{
		public static const NAME:String = "com.bored.games.breakout.actions.SpawnCollectable";
		
		private var _type:String;
		
		public function SpawnCollectable(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void 
		{
			_type = a_params.type;
		}//end initParams()
		
		override public function startAction():void 
		{	
			var brick:Brick = (_gameElement as Brick);
					
			var xOffset:Number = (brick.gridX + brick.gridWidth/2) * AppSettings.instance.defaultTileWidth;
			var yOffset:Number = (brick.gridY + brick.gridHeight/2) * AppSettings.instance.defaultTileHeight;
			
			var die:Number = Math.random();
			
			var pb:Collectable;
			
			switch(_type)
			{
				case "bonus":
					pb = new BlockBonus();
					break;
				case "extend":
					pb = new ExtendPowerup();
					break;
				case "catch":
					pb = new CatchPowerup();
					break;
				case "laser":
					pb = new LaserPowerup();
					break;
				case "superlaser":
					pb = new SuperLaserPowerup();
					break;
				case "multiball":
					pb = new MultiballPowerup();
					break;
				case "invinciball":
					pb = new InvinciballPowerup();
					break;
				case "destructoball":
					pb = new DestructoballPowerup();
					break;
				case "extralife":
					pb = new ExtraLifePowerup();
					break;
			}
			
			pb.physicsBody.SetTransform( new V2( xOffset / PhysicsWorld.PhysScale, yOffset / PhysicsWorld.PhysScale ), 0 );
			
			var snd:MightySound = MightySoundManager.instance.getMightySoundByName("sfxSpawnCollectable");
			if (snd) snd.play();
			
			GameView.Collectables.append(pb);
			
			_finished = true;
		}//end startAction()
		
	}//end SpawnCollectable

}//end package