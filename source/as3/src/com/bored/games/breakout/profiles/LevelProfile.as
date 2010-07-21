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
		private var _backgroundIndex:int;
				
		public function LevelProfile(a_limit:int, a_url:String, a_background:int) 
		{			
			_timeLimit = a_limit;
			_levelDataURL = a_url;
			_backgroundIndex = a_background;
		}//end constructor()
		
		public function get timeLimit():int
		{
			return _timeLimit;
		}//end get timeLimit()
		
		public function get levelDataURL():String
		{
			return _levelDataURL;
		}//end get levelDataURL()
		
		public function get backgroundIndex():int
		{
			return _backgroundIndex;
		}//end get backgroundIndex()
		
	}//end LevelProfile

}//end package