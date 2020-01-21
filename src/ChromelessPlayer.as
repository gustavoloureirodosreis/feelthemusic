package {
	
	import auxiliares.NavigationEvent;
	
	import com.gamua.flox.utils.setTimeout;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	
	public class ChromelessPlayer extends Sprite {
		
		public static const PLAYER_READY:String = "playerReady";
		public static const VIDEO_BEGAN:String = "videobegan";
		
		private var loader:Loader;
		private var player:Object; // This will hold the API player instance once it is initialized.
		
		public function ChromelessPlayer() {
			// The player SWF file on www.youtube.com needs to communicate with your host
			// SWF file. Your code must call Security.allowDomain() to allow this
			// communication.
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("https://www.youtube.com/apiplayer?version=3"));			
		}
				
		public function loadVideoById(id:String):void {
			player.loadVideoById(id);
		}
		
		public function setPlaybackQuality(quality:String):void {
			player.setPlaybackQuality(quality);
		}
		
		public function setSize(width:Number, height:Number):void {
			player.setSize(width, height);
		}
		
		public function getDuration():Number {
			return player.getDuration();
		}
		
		public function getCurrentTime():Number {
			return player.getCurrentTime();
		}
		
		public function getVideoBytesLoaded():Number {
			return player.getVideoBytesLoaded();
		}

		public function playVideo():void {
			player.playVideo();
		}
		
		public function pauseVideo():void {
			player.pauseVideo();
		}
		
		public function stopVideo():void {
			player.stopVideo();
		}
		
		public function mute():void {
			player.mute();
		}
		
		public function unMute():void {
			player.unMute();
		}
		
		public function skipTo(step:Number):void {
			player.seekTo(step);
		}
		
		public function destroy():void {
			player.destroy();
		}
		
		public function isMuted():Boolean {
			return player.isMuted();
		}
				
		// Private Methods
		
		private function onLoaderInit(event:Event):void {
			addChild(loader);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
			
		private function onPlayerReady(event:Event):void {
			// Event.data contains the event parameter, which is the Player API ID
			//trace("player ready:", Object(event).data);
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			//Set size
			player.setSize(495, 365);
			
			dispatchEvent(new Event(PLAYER_READY));
		}
		
		private function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			// Só despacha se foi erro 100
			if(event["data"] == 100) {
				dispatchEvent(new NavigationEvent(NavigationEvent.BROKEN));
			}
			//trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			//trace("player state:", Object(event).data);
			if(Object(event).data == 0) {
				dispatchEvent(new NavigationEvent(NavigationEvent.END));
			} else if(Object(event).data == 1) {
				dispatchEvent(new Event(VIDEO_BEGAN));
			}
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			//trace("video quality:", Object(event).data);
		}
		
		//VARIÁVEIS E MÉTODOS PRAS CLASSES DE MENU, DIFICULDADES, E PLAYSCREENS
		public var initialVideoIdMenus:String = "";
		
		public function playSampleMenuEstilos(estilo:String, pai:MenuEstilos):void {
			if(estilo==null || pai==null) {
				return;
			}
			
			var musicasArray:Array = new Array();
			var musicaTocada:String;
			var indexMusica:Number;
			
			if(estilo.length<=2) {
				var musicasPorNivel:Array = new Array();
				for each (var quintuple:Array in FeelMusic.musicIDsArray) {
					if(quintuple[0]==estilo) {
						musicasPorNivel.push(quintuple[3]);		
					}
				}
				initialVideoIdMenus = musicasPorNivel[Math.floor(Math.random()*musicasPorNivel.length)];
			} else {
				for each(var artista:String in FeelMusic.artistas) {
					if(artista.split("&")[0]==estilo) {
						for(var j:int = 1; j<artista.split("&").length; j++) {
							musicasArray.push(artista.split("&")[j]);
						}
						break;
					}
				}
				for each(var genero:String in FeelMusic.generos) {
					if(genero.split("&")[0]==estilo) {
						for(var k:int = 1; k<genero.split("&").length; k++) {
							musicasArray.push(genero.split("&")[k]);
						}
						break;
					}
				}
				if(musicasArray.length>0) {
					indexMusica = Math.floor(Math.random()*musicasArray.length);
					pai.indexMusica = indexMusica;
					musicaTocada = musicasArray[indexMusica];
					//Ajusta o nome
					for each (var quintuple2:Array in FeelMusic.musicIDsArray) {
						if(quintuple2[2]==musicaTocada) {
							initialVideoIdMenus = quintuple2[3]; 
							break;
						}
					}
				}	
			}
			
			commonPlayMenus();
		}
				
		public function playSampleMenuMusicas(nomeCompletoMusica:String):void {
			var nomeSimples:String = (nomeCompletoMusica.split("-")[1]).substr(1,int.MAX_VALUE);
			
			//Ajusta o nome
			for each (var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[4].split(" - ")[1] == nomeSimples) {
					initialVideoIdMenus = quintuple[3]; 
					break;
				}
			}
	
			commonPlayMenus();
		}
		
		private function commonPlayMenus():void {
			player.loadVideoById(initialVideoIdMenus);
			player.setSize(100, 75);
			player.setPlaybackQuality("small");
			player.playVideo();
			var playBackSample:Timer = new Timer(10);
			playBackSample.addEventListener(TimerEvent.TIMER, onCheckPlayback);
			playBackSample.start();			
		}
		
		protected function onCheckPlayback(event:TimerEvent):void {
			if(initialVideoIdMenus!="" && player.getCurrentTime()>=30) {
				player.loadVideoById(initialVideoIdMenus);
				player.setSize(100, 75);
				player.setPlaybackQuality("small");
			}
		}
	}
}
