package com.bored.games.breakout.profiles 
{
	import com.sven.utils.AppSettings;
	/**
	 * ...
	 * @author sam
	 */
	public class UserProfile
	{
		private var _lives:int;
		private var _score:int;
		private var _levelsUnlocked:Array;
	
		public function UserProfile() 
		{			
			_lives = AppSettings.instance.defaultStartingLives;
			_score = 0;
			_levelsUnlocked = new Array();
		}//end constructor()
		
		public function addPoints(a_points:int):void
		{
			_score += a_points;
		}//end addPoints()
		
		public function get score():int
		{
			return _score;
		}//end get score()
		
		public function incrementLives():void
		{
			_lives++;
		}//end incrementLives()
		
		public function decrementLives():void
		{
			_lives--;
		}//end decrementLives()
		
		public function get lives():int
		{
			return _lives;
		}//end get lives()
		
		public function unlockLevel(a_lvl:int):void
		{
			if ( _levelsUnlocked.length > a_lvl )
			{
				_levelsUnlocked[a_lvl] = true;
			}
			else
			{
				_levelsUnlocked.push(true);
			}
		}//end unlockLevel()
		
		public function levelUnlocked(a_lvl:int):Boolean
		{
			if ( _levelsUnlocked.length > a_lvl )
			{
				return _levelsUnlocked[a_lvl];
			}
			
			return false;
		}//end levelUnlocked()
		
		public function reset():void
		{
			_lives = AppSettings.instance.defaultStartingLives;
			_score = 0;
		}//end reset()
		
	}//end UserProfile

}//end package