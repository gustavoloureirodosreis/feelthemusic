package auxiliares {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	public class BestMusicScore extends MovieClip {
		//Variáveis no MC:
		public var yourPosition:TextField;
		public var userMaxRecordYou:TextField;
		public var maxRecordYou:TextField;
		public var yourPositionRel:TextField;
		
		public function BestMusicScore() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this["ranking1Txt"].text = FeelMusic._("ranking1Txt");
			this["ranking2Txt"].text = FeelMusic._("ranking2Txt");
		}
	}
	
}
