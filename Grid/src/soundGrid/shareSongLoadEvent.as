package soundGrid 
{
	
	/**
	 * ...
	 * @author sd
	 */
	
	import flash.events.*;
	
	public class shareSongLoadEvent extends Event
	{
		public static const CODE_EVENT:String = "codeEvent";
		
		public var song:String;
		
		
		public function shareSongLoadEvent(c:String) 
		{
			super(CODE_EVENT);
			song = c;
		}
		
	}

}