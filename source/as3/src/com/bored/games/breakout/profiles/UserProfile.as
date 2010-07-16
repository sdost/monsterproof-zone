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
		
		private var _timeRemaining:int;
		
		public function UserProfile() 
		{			
			_lives = AppSettings.instance.defaultStartingLives;
			_score = 0;
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
		
		public function set time(a_time:int):void
		{
			_timeRemaining = a_time;
		}//end set time()
		
		public function get time():int
		{
			return _timeRemaining;
		}//end get time()
		
		public function decreaseTime(a_delta:int):void
		{
			_timeRemaining -= a_delta;
			
			if ( _timeRemaining <= 0 )
				_timeRemaining = 0;
		}//end decreaseTime()
		
		public function get lives():int
		{
			return _lives;
		}//end get lives()
		
	}//end UserProfile

}//end package