package auxiliares  
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event 
	{
		public static const PLAYAGAIN:String = "playagain";
		public static const SINGLEPLAY:String = "singleplay";
		public static const MULTIPLAY:String = "multiplay";
		public static const CURSOPLAY:String = "cursoplay";
		public static const QUITGAME:String = "quitgame";
		public static const UPDATECOINS:String = "updatecoins";
		public static const TEMPOEXEC:String = "tempoexec";
		public static const END:String = "end";
		public static const ENDLEAVING:String = "endleaving";
		public static const START:String = "start";
		public static const MASTERSTART:String = "masterstart";
		public static const AGAIN:String = "again";
		public static const DURATION:String = "duration";
		public static const BACKMENU:String = "backmenu";
		public static const MENU:String = "menu";
		public static const MUSICCHOOSEN:String = "musicchoosen";
		public static const PREVIOUSMENU:String = "previousmenu";
		public static const BACKEND:String = "backend";
		public static const MUSICCOMPLETE:String = "musiccomplete";
		public static const MAKELOGIN:String = "makelogin";
		public static const DONTMAKELOGIN:String = "dontmakelogin";
		public static const LEVELEDUP:String = "leveledup";
		public static const MULTIRANDOM:String = "multirandom";
		public static const MULTIFRIEND:String = "multifriend";
		public static const MULTIACCEPT:String = "multiaccept";
		public static const STARTMP:String = "startmp";
		public static const ENDMP:String = "endmp";
		public static const BROKEN:String = "broken";
		
		public var data:Object;
		
		public function NavigationEvent( type:String ) {
			super( type );
		}
		
	}
}