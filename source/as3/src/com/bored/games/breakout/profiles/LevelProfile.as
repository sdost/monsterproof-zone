package com.bored.games.breakout.profiles 
{
	import com.sven.utils.AppSettings;
	/**
	 * ...
	 * @author sam
	 */
	public class LevelProfile
	{
		private var _timeLimit:int;
		private var _levelDataURL:String;
				
		public function LevelProfile(a_limit:int, a_url:String) 
		{			
			_timeLimit = a_limit;
			_levelDataURL = a_url;
		}//end constructor()
		
		public function get timeLimit():int
		{
			return _timeLimit;
		}//end get timeLimit()
		
		public function get levelDataURL():String
		{
			return _levelDataURL;
		}//end get levelDataURL()
		
	}//end LevelProfile

}//end package