package
{
	import auxiliares.BestMusicScore;
	import auxiliares.LevelBar;
	import auxiliares.NavigationEvent;
	import auxiliares.PopUp;
	import auxiliares.Settings;
	import auxiliares.SugerirMusica;
	import auxiliares.WordShuffler;
	
	import com.gamua.flox.Player;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.mixpanel.Mixpanel;
	
	import enums.MP_EVT;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import flox_entities.MyPlayer;
	
	public class MenuMusicas extends MovieClip {
		//Variáveis já no MC
		public var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var boughtRay:MovieClip;
		public var videoContainer:MovieClip;
		public var musicsList:MovieClip;
		public var backMenuEstilos:SimpleButton;
		public var nextBtn:SimpleButton;
		public var backBtn:SimpleButton;
		public var searchMusic:TextField;
		public var pages:TextField;
		
		//Outras variáveis
		public var bestMS:BestMusicScore = new BestMusicScore();
		public var audioTransform:SoundTransform = new SoundTransform();
		public var musicasArray:Array = new Array();
		public var playerTemasStringfied:Array = new Array();
		public var numerosNiveis:Array = new Array();
		public var tecladoLiberado:Array = [true, true];
		public var pointerGlobal:Number = -1;
		public var posicaoMenu:Number = 0;
		public var currentMusic:String = "";
		public var currentEstilo:String = "";
		public var nomeMusica:String = "";
		public var jaComprado:Boolean = false;
		public var playerReady:Boolean = false;
		public var youtubePlayer:ChromelessPlayer;
		
		// Mixpanel
		private var mixpanel:Mixpanel;
		
		public function MenuMusicas(estilo:String) {
			// Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			currentEstilo = estilo;
			
			//Prepara numerosNiveis
			for(var i:int=1; i<=99; i++) {
				numerosNiveis.push(i.toString());
			}
			
			//Preenche o musicasArray se for o caso
			if(numerosNiveis.indexOf(currentEstilo)==-1) { 
				for each(var artista:String in FeelMusic.artistas) {
					if(artista.split("&")[0]==estilo) {
						for(var j:int = 1; j<artista.split("&").length; j++) {
							musicasArray.push(["diff-antiga", artista.split("&")[j], "aqui-vai-vir-se-eh-premium"]);
						}
						break;
					}
				}
				for each(var genero:String in FeelMusic.generos) {
					if(genero.split("&")[0]==estilo) {
						for(var k:int = 1; k<genero.split("&").length; k++) {
							musicasArray.push(["diff-antiga", genero.split("&")[k], "aqui-vai-vir-se-eh-premium"]);
						}
						break;
					}
				}
				//Coloca os fuvogs aqui
				for each(var theme:Object in WordShuffler.themes) {
					if(theme.name==estilo) {
						for each(var musicPair:Array in theme.musics) {
							musicasArray.push(["diff-antiga", musicPair[0], "aqui-vai-vir-se-eh-premium"]);
						}
						break;
					}
				}
			} 
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//Seta texto
			searchMusic.text = FeelMusic._("Search...");
			
			//Prepara o tocador do youtube
			youtubePlayer = new ChromelessPlayer();
			youtubePlayer.addEventListener(ChromelessPlayer.VIDEO_BEGAN, checkStopVideo);
			youtubePlayer.addEventListener(ChromelessPlayer.PLAYER_READY, onPlayerReady);
			videoContainer.addChild(youtubePlayer);
			
			//Prepara o botão de retorno
			backMenuEstilos.addEventListener(MouseEvent.CLICK, backPrevious);
			
			var player:MyPlayer = Player.current as MyPlayer;
			if(currentEstilo!="especial" || currentEstilo.indexOf("$$$")>=0) {
				if(currentEstilo.indexOf("$$$")>=0) {
					//Se veio da busca
					searchMusic.text = currentEstilo.split("$$$")[0];
					for each(var quintuple5:Array in FeelMusic.musicIDsArray) {
						if(quintuple5[4].indexOf(searchMusic.text)>=0) { 
							musicasArray.push([Number(quintuple5[0]), quintuple5[4], FeelMusic.musicasPremium.indexOf(quintuple5[4])]);
						}
					}
				} else {
					if(numerosNiveis.indexOf(currentEstilo)==-1) { //Se é um estilo sem ser nível
						for each(var pair:Array in musicasArray) {
							for each(var quintuple:Array in FeelMusic.musicIDsArray) {
								if(quintuple[2]==pair[1]) { 
									pair[0] = Number(quintuple[0]);
									pair[1] = quintuple[4];
									pair[2] = FeelMusic.musicasPremium.indexOf(quintuple[4]);
									break;
								}
							}
						} 
					} else { //Se é nível
						for each(var quintuple2:Array in FeelMusic.musicIDsArray) {
							if(quintuple2[0]==currentEstilo) { 
								musicasArray.push([Number(quintuple2[0]), quintuple2[4], FeelMusic.musicasPremium.indexOf(quintuple2[4])]);
							}
						}
					}
				}
				//Ordena por ordem alfabética
				musicasArray.sortOn("1", Array.CASEINSENSITIVE);
				//Ordena por premiums ao final
				musicasArray.sortOn("2", Array.NUMERIC);
				
				//Ordena por, na frente de tudo, as desbloqueadas
				var compradasLength:Number = 0;
				for each(var temaComprado:String in player.temas) {
					for each(var quintuple3:Array in FeelMusic.musicIDsArray) {
						if(quintuple3[2]==temaComprado) {
							temaComprado = quintuple3[4]; 
							playerTemasStringfied.push(temaComprado);
							break;
						}
					}
					for each(var pairMusicas:Array in musicasArray) {
						if(temaComprado==pairMusicas[1]) {
							musicasArray.splice(musicasArray.indexOf(pairMusicas), 1);
							musicasArray.unshift(pairMusicas);
							compradasLength++;
							break;
						}
					}
				}

				//Agora ordena as compradas em ordem alfabética
				var auxArrayCompradas:Array = new Array();
				for(var o:int=0; o<compradasLength; o++) {
					auxArrayCompradas[o] = musicasArray[o];	
				}
				auxArrayCompradas.sortOn("1", Array.CASEINSENSITIVE);
				for(var p:int=auxArrayCompradas.length-1; p>=0; p--) {
					musicasArray.splice(musicasArray.indexOf(auxArrayCompradas[p]),1);
					musicasArray.unshift(auxArrayCompradas[p]);
				}
			} else {
				//Se é músicas compradas
				for each(var idDaMusica:String in player.temas) {
					for each(var quintuple4:Array in FeelMusic.musicIDsArray) {
						if(quintuple4[2]==idDaMusica) { 
							musicasArray.push([Number(quintuple4[0]), quintuple4[4], FeelMusic.musicasPremium.indexOf(quintuple4[4])]);
							playerTemasStringfied.push(quintuple4[4]);
						}
					}
				}
				
				//Ordena por ordem alfabética
				musicasArray.sortOn("1", Array.CASEINSENSITIVE);
			}
			
			searchMusic.addEventListener(MouseEvent.CLICK, onClickSearchBox);
			searchMusic.addEventListener(KeyboardEvent.KEY_DOWN, onCleanSearchBox);
			searchMusic.addEventListener(KeyboardEvent.KEY_UP, onSearchMusics);
			
			//Põe os listeners nos botões
			activateMouseOverListeners();
			nextBtn.addEventListener(MouseEvent.CLICK, onForwardList);
			backBtn.addEventListener(MouseEvent.CLICK, onBackwardList);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);
			
			if(musicasArray.length<8) {
				toggleVisibilityDiscs(musicasArray.length);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);
				nextBtn.visible = false; backBtn.visible = false;
			}
			
			//Retira Loading Screen se pôs e mostra as músicas enfim
			displayMusicas(pointerGlobal, true);	
		}
		
		public function guestScenario():void {
			backBtn.visible = false;
			nextBtn.visible = false;
			pages.visible = false;
			searchMusic.visible = false;
			backMenuEstilos.visible = false;
			this["searchBox"].visible = false; 
			this["searchSymbol"].visible = false;
			this["guestTxt"].text = FeelMusic._("guestTxt");
			this["guestSubTxt"].text = FeelMusic._("guestSubTxt");
		}
		
		protected function checkStopVideo(event:Event):void {
			if(parent==null) { youtubePlayer.stopVideo(); }
		}
		
		protected function onPlayerReady(event:Event):void {
			playerReady = true;
		}
		
		protected function onLoadSong(name:String):void {
			var index:Number = Number(name.substr(name.length-1, int.MAX_VALUE));
			if(indiceAtual<8) { youtubePlayer.playSampleMenuMusicas(musicasArray[index-1][1]); }
			else { youtubePlayer.playSampleMenuMusicas(musicasArray[indiceAtual-8+index][1]); }
		}
		
		private function activateMouseOverListeners():void {
			for(var i:int=1; i<=8; i++) {
				musicsList["music"+i].buttonMode = true;
				musicsList["music"+i].addEventListener(MouseEvent.MOUSE_OVER, onGlow);
				musicsList["music"+i].addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);	
			}
		}
		
		protected function onUnGlow(event:MouseEvent):void {
			if(playerReady) { 
				youtubePlayer.stopVideo(); 
				event.currentTarget["disco"]["loadingGif"].visible = false;
			}
			event.currentTarget["stroke"].gotoAndStop(1);
		}
		
		protected function onGlow(event:MouseEvent):void {
			if(playerReady) { 
				onLoadSong(event.currentTarget.name); 
				event.currentTarget["disco"]["loadingGif"].visible = true;
			}
			event.currentTarget["stroke"].gotoAndStop(2);
		}
		
		public function getMusic():String {
			return nomeMusica;
		}
		
		public function backPrevious(event:Event):void{
			backMenuEstilos.visible = false;
			//Para de tocar a música anterior
			youtubePlayer.stopVideo();
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			btnPressedSFX.play(0,0,st);
			dispatchEvent(new NavigationEvent(NavigationEvent.PREVIOUSMENU));
		}
		
		private function removeGlowListeners():void {
			for(var i:int=1; i<=8; i++) {
				musicsList["music"+i].removeEventListener(MouseEvent.MOUSE_OVER, onGlow);
				musicsList["music"+i].removeEventListener(MouseEvent.MOUSE_OUT, onUnGlow);	
			}
		}
		
		protected function onBackwardList(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			btnPressedSFX.play(0,0,st);
			pointerGlobal-=8;
			blurAndThenShow();
		}
				
		protected function onForwardList(event:MouseEvent):void	{
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			btnPressedSFX.play(0,0,st);
			pointerGlobal+=8;
			blurAndThenShow();
		}
		
		private function blurAndThenShow():void {
			for(var i:int = 1; i<=8; i++) {
				TweenMax.to(musicsList["music"+i], 0.2, {blurFilter:{blurX:30, remove:true}});
			}
			displayMusicas(pointerGlobal, true);			
		}
				
		private function keyDownMenus(k:KeyboardEvent){
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			switch(k.keyCode) {
				case 37: //Seta pra esquerda
					if(tecladoLiberado[0]) {
						btnPressedSFX.play(0,0,st);
						onBackwardList(null);
					}
					break;
				case 39: //Seta pra direita
					if(tecladoLiberado[1]) {
						btnPressedSFX.play(0,0,st);
						onForwardList(null);
					}
					break;
			}
		}
		
		public var indiceAtual:Number = 0;
		public function displayMusicas(pointer:Number, focaNoStage:Boolean):void {	
			if(focaNoStage) { stage.focus = searchMusic; }
			
			//Tira a pontuação máxima anterior
			if(this!=null && this.contains(bestMS)) { this.removeChild(bestMS); }
			
			//Põe os listeners de Mouse_Over em todos a princípio
			activateMouseOverListeners();
			
			//Preenche as músicas e o nível em cada música
			var player:MyPlayer = Player.current as MyPlayer;
			for(var i:int=1; i<=8; i++){
				//Ajusta o índice em caso negativo
				indiceAtual = (i+pointer)%musicasArray.length;
				if(indiceAtual<0){
					indiceAtual = musicasArray.length + (indiceAtual)%musicasArray.length;
				}
				
				//Limpa as informações antigas
				jaComprado = false;
				musicsList["music"+i].gotoAndStop(1);
				musicsList["music"+i].mouseChildren = false;
				musicsList["music"+i].musica_nome.text = musicasArray[indiceAtual][1];
				musicsList["music"+i].score.textColor = 0xFFFFFF;
				musicsList["music"+i].score.text = "0";
				musicsList["music"+i].musicLevel.gotoAndStop(1);
				musicsList["music"+i].disco.gotoAndStop(Math.round(musicasArray[indiceAtual][0]/10));
				musicsList["music"+i].addEventListener(MouseEvent.CLICK, onChooseMusic);
				musicsList["music"+i].removeEventListener(MouseEvent.CLICK, onTryBuyMusic);
				musicsList["music"+i].removeEventListener(MouseEvent.CLICK, onShowPremium);	
				
				//Checa se já foi comprado
				for each(var tema:String in playerTemasStringfied){
					if(tema == musicasArray[indiceAtual][1]) { jaComprado = true;}
				}
				//Trata se já foi comprado ou não
				if(!jaComprado){
					musicsList["music"+i].removeEventListener(MouseEvent.CLICK, onChooseMusic);
					var levelBar:LevelBar = new LevelBar();
					if(levelBar.getPlayerLevel()<musicasArray[indiceAtual][0]) {
						musicsList["music"+i].gotoAndStop(4);
						musicsList["music"+i].musica_nome.text = musicasArray[indiceAtual][1];
						musicsList["music"+i].levelMsg.text = "Alcance o level "+musicasArray[indiceAtual][0].toString()+" para desbloquear!";
						musicsList["music"+i].levelNum.text = musicasArray[indiceAtual][0].toString();
					} else {
						musicsList["music"+i].gotoAndStop(3);					
						musicsList["music"+i].musica_nome.text = musicasArray[indiceAtual][1];
						musicsList["music"+i].price.text = setPriceMusic(musicasArray[indiceAtual][0]);
					} 
					musicsList["music"+i].addEventListener(MouseEvent.CLICK, onTryBuyMusic);
					
					//Checa se o jogador é premium
					if(player.compras.indexOf("premium")==-1 && FeelMusic.musicasPremium.indexOf(musicasArray[indiceAtual][1])>=0) {
						musicsList["music"+i].removeEventListener(MouseEvent.CLICK, onTryBuyMusic);
						musicsList["music"+i].gotoAndStop(5);
						musicsList["music"+i].musica_nome.text = musicasArray[indiceAtual][1];
						musicsList["music"+i].addEventListener(MouseEvent.CLICK, onShowPremium);
					}
				} else {
					//Preenche informações de estrelas e de score
					for each(var specificLevel:Array in player.levels) {
						if(specificLevel[0] == musicsList["music"+i].musica_nome.text){
							musicsList["music"+i].musicLevel.gotoAndStop(specificLevel[1]);
							musicsList["music"+i].score.text = specificLevel[2].toString();
							if(specificLevel[1]==7) {
								musicsList["music"+i].gotoAndStop(2);
							}
						}
					}	
				}
			}
			
			//Vê que setas mostra
			pages.text = (Math.ceil(pointerGlobal/8)+1).toString()+"/"+Math.ceil(musicasArray.length/8).toString();
			if(Math.ceil(pointerGlobal/8)+1==1) { backBtn.visible = false; tecladoLiberado[0] = false; }
			else { backBtn.visible = true; tecladoLiberado[0] = true; }
			if(Math.ceil(pointerGlobal/8)+1==Math.ceil(musicasArray.length/8)) { nextBtn.visible = false; tecladoLiberado[1] = false; }
			else { nextBtn.visible = true; tecladoLiberado[1] = true;  }
		}
		
		private function setPriceMusic(diffi:Number):String {
			return "250";
		}		
		
		protected function onClickSearchBox(event:MouseEvent):void {
			searchMusic.text = "";
			searchMusic.textColor = 0x000000;
		}
		
		protected function onCleanSearchBox(event:KeyboardEvent):void {
			//Primeira tecla digitada limpa a caixa de busca
			if(searchMusic.text.indexOf(FeelMusic._("Search..."))>=0) {
				onClickSearchBox(null);
			}			
		}
		
		protected function onSearchMusics(event:KeyboardEvent):void {
			//Só pesquisa se tiver mais de 1 letra
			var auxArray:Array = new Array();
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(String(quintuple[4].toLowerCase()).indexOf(searchMusic.text.toLowerCase())>=0) {
					auxArray.push([Number(quintuple[0]), quintuple[4], FeelMusic.musicasPremium.indexOf(quintuple[4])]);
				}
			}
			if(auxArray.length>0) {	musicasArray = auxArray; }
			if(auxArray.length<8) { toggleVisibilityDiscs(auxArray.length); }
			else { toggleVisibilityDiscs(0); }
			
			//Novo display
			displayMusicas(pointerGlobal, false);
		}
		
		private function toggleVisibilityDiscs(numInvisible:Number):void {
			for(var i:int=1;i<=8;i++) {
				if(i<=numInvisible) { musicsList["music"+i].visible = true;
				} else { musicsList["music"+i].visible = false; }
				if(numInvisible == 0) { musicsList["music"+i].visible = true; }
			}
		}
		
		public function onShowPremium(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showPremiumProposal();
		}
		
		public function onTryBuyMusic(event:MouseEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			var wrongSFX:WrongSoundSFX = new WrongSoundSFX();
			var st:SoundTransform = new SoundTransform(); st.volume = 0.5; 
			if(event.currentTarget.currentFrame==4) {
				TweenMax.to(event.currentTarget, 0.1, {blurFilter:{blurX:30, remove:true}});
				wrongSFX.play(1000,0,st);
			} else {
				if(player.nrCoins >= Number(event.currentTarget.price.text)) {
					//Grava a compra
					player.nrCoins -= Number(event.currentTarget.price.text);
					for each(var quintuple:Array in FeelMusic.musicIDsArray) {
						if(quintuple[4]==event.currentTarget.musica_nome.text) { 
							player.temas.push(String(quintuple[2]));
							playerTemasStringfied.push(quintuple[4]);
						}
					}
					//Comemora a compra
					congratulateBought(event.currentTarget);
					player.save(
						function onComplete(){dispatchEvent(new NavigationEvent(NavigationEvent.UPDATECOINS));},
						function onError(message:String) {});
					displayMusicas(pointerGlobal, true);

					var songAndArtist:String = event.currentTarget.musica_nome.text;
					mixpanel.track(MP_EVT.COMPROU_MUSICA, {
						'Artista': songAndArtist.split('-')[0],
						'Musica': songAndArtist.split('-')[1]
					});
				} else {
					if(!FeelMusic.ehGuest) {
						var popUp:PopUp = new PopUp();
						popUp.bringPopUp(this);
						popUp.showLojinha();
						popUp.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateCoinsDisplay);
					} else {
						navigateToURL(new URLRequest("/cadastroFTM&redirect=ftm"), "_self");
					}
				}
			}
		}
		
		protected function onUpdateCoinsDisplay(event:Event):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.UPDATECOINS));			
		}
		
		private function congratulateBought(target:Object):void {
			var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
			cashRegisterSFX.play(2000);
			boughtRay.visible = true;
			//Por algum motivo, essas proporções centralizam os raios na opção de menu
			boughtRay.x = target.x - 0.45*target.width;
			boughtRay.y = target.y - 0.40*target.height;
			boughtRay.alpha = 1;
			TweenLite.to(boughtRay, 3, {alpha:0});
		}
		
		public function chooseMusicCommon():void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);
			
			//Para de tocar a música que estiver tocando
			if(playerReady) { youtubePlayer.stopVideo(); }
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);			
		}
		
		public function onChooseMusic(event:MouseEvent):void {
			chooseMusicCommon();
			nomeMusica = event.currentTarget.musica_nome.text;
			dispatchEvent(new NavigationEvent(NavigationEvent.MUSICCHOOSEN));
		}
		
		public function removeKeyboardListener():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);			
		}
		
	}
}