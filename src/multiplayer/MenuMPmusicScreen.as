package multiplayer  {
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	
	import flox_entities.GameMatch;
	
	
	public class MenuMPmusicScreen extends MovieClip {
		//Variáveis já no MC
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var music1:MovieClip;
		public var music2:MovieClip;
		public var music3:MovieClip;
		
		//Outras variáveis
		public var match:GameMatch = new GameMatch();
		public var tresMusicas:Array = new Array();
		
		public function MenuMPmusicScreen(_match:GameMatch, _tresMusicas:Array) {
			match = _match;
			tresMusicas = _tresMusicas;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			music1.addEventListener(MouseEvent.MOUSE_OVER, onGlow);
			music2.addEventListener(MouseEvent.MOUSE_OVER, onGlow);
			music3.addEventListener(MouseEvent.MOUSE_OVER, onGlow);
			music1.addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);
			music2.addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);
			music3.addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);				
		}
		
		protected function onUnGlow(event:MouseEvent):void {
			TweenMax.to(event.currentTarget,0.1,{glowFilter:{remove:true}});			
		}
		
		protected function onGlow(event:MouseEvent):void {
			TweenMax.to(event.currentTarget,0.2,{glowFilter:{color:0x0000FF, blurX:10, blurY:10, alpha:1, strength:2, quality:2}});
		}
		
		protected function onAddedToStage(event:Event):void {
			//Pega as tres musicas aleatorias do estilo 
			for(var i:int=0; i<=2; i++) {
				this["music"+(i+1)].musicSinger.text = tresMusicas[i].split(" - ")[0];
				this["music"+(i+1)].musicSong.text = tresMusicas[i].split(" - ")[1];  
			}
						
			//Poe os listeners para escolha de qual musica
			for(var j:int=1; j<=3; j++) {
				this["music"+j].mouseChildren = false;
				this["music"+j].buttonMode = true;
				this["music"+j].addEventListener(MouseEvent.CLICK, onChooseMusic);
			}
		}
		
		public function onChooseMusic(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);
			
			match._estilo = event.currentTarget.musicSinger.text;
			match._musica = event.currentTarget.musicSinger.text+" - "+event.currentTarget.musicSong.text;
			parent.removeChild(this);
		}
	}
	
}