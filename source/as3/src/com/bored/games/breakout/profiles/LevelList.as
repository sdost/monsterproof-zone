package com.bored.games.breakout.profiles 
{
	/**
	 * ...
	 * @author sam
	 */
	public class LevelList
	{
		private var _levels:Vector.<LevelProfile>;
		
		public function LevelList(a_xml:XML) 
		{
			_levels = new Vector.<LevelProfile>();
			
			parse(a_xml);
		}//end constructor()
		
		private function parse(a_xml:XML):void
		{
			var list:XMLList = a_xml.children();
			
			for each( var xml:XML in list )
			{
				var limit:int = xml.@time;
				var url:String = xml.@src;
				var background:int = xml.@background;
				
				var profile:LevelProfile = new LevelProfile(limit, url, background);
				_levels.push(profile);
			}
		}//end parse()
		
		public function getLevel(a_lvl:int):LevelProfile
		{
			return _levels[a_lvl];
		}//end getLevel()
		
		public function get levelCount():int
		{
			return _levels.length;
		}//end get levelCount()
		
	}//end LevelList

}//end package