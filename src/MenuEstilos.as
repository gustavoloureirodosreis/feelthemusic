package
{
	import auxiliares.LevelBar;
	import auxiliares.NavigationEvent;
	import auxiliares.WordShuffler;
	
	import com.gamua.flox.Player;
	import com.greensock.TweenMax;
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	
	import flox_entities.MyPlayer;
	
	public class MenuEstilos extends MovieClip {
		
		//Variáveis no MC
		public var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var musicasCompradasBtn:MovieClip;
		public var searchBtn:MovieClip;
		public var chooseMenuStyle:MovieClip; 
		public var themesList:MovieClip;
		public var backBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		public var videoContainer:MovieClip;
		public var searchTheme:TextField;
		public var pages:TextField;
		
		//Outras variáveis:
		private var ordenacao:Number = 1;
		private var ehMultiplayer:Boolean = false;
		public var tecladoLiberado:Array = [true, true];
		public var tresMusicas:Array = new Array();
		public var niveisArray:Array = new Array();
		public var artistasArray:Array = new Array();
		public var generosArray:Array = new Array();
		public var compradasArray:Array = new Array();
		public var fuvogsArray:Array = new Array();
		public var playerReady:Boolean = false;
		public var estilo:String = "";
		public var pointerGlobal:Number = -1;
		public var youtubePlayer:ChromelessPlayer;
		public var indexMusica:Number;
		public var indiceAtualGlobal:Number;
		public var playerLevel:Number;
		
		public function MenuEstilos() {			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function getEstilo():String {
			return estilo;
		}
		
		public function setOrdenacao(num:int):void {
			ordenacao = num;
		}
		
		public function setMultiplayer(ehMulti:Boolean):void {
			ehMultiplayer = ehMulti;
		}
		
		public function getIndice():Number{
			return indexMusica;
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Seta o level do jogador
			var levelBar:LevelBar = new LevelBar();
			playerLevel = levelBar.getPlayerLevel();
			
			//Vê que marcador de ordenação põe como marcado
			if(chooseMenuStyle.currentFrame!=5) {
				for(var h:int=1; h<=3; h++) {
					chooseMenuStyle["sort"+h].addEventListener(MouseEvent.MOUSE_OVER, onMenuStyleOver);
					chooseMenuStyle["sort"+h].addEventListener(MouseEvent.MOUSE_OUT, onMenuStyleOut);
					chooseMenuStyle["sort"+h].addEventListener(MouseEvent.CLICK, onChangeStyle);
					chooseMenuStyle["sort"+h].buttonMode = true;
				}
				chooseMenuStyle["sort"+player.nivel].gotoAndStop(2);
				searchTheme.text = FeelMusic._(chooseMenuStyle["sort"+player.nivel].name);
				chosenSearchTheme = searchTheme.text;
				
				//Marcadores extra
				musicasCompradasBtn.addEventListener(MouseEvent.CLICK, onMusicasMenuEspecial);
				musicasCompradasBtn.addEventListener(MouseEvent.MOUSE_OVER, onMenuStyleOver);
				musicasCompradasBtn.addEventListener(MouseEvent.MOUSE_OUT, onMenuStyleOut);
				musicasCompradasBtn.buttonMode = true;
				searchBtn.addEventListener(MouseEvent.CLICK, onClickSearchBox);
				searchBtn.addEventListener(MouseEvent.MOUSE_OVER, onMenuStyleOver);
				searchBtn.addEventListener(MouseEvent.MOUSE_OUT, onMenuStyleOut);
				searchBtn.buttonMode = true;
			}
			
			//Prepara o tocador do youtube
			youtubePlayer = new ChromelessPlayer();
			youtubePlayer.addEventListener(ChromelessPlayer.PLAYER_READY, onPlayerReady);
			videoContainer.addChild(youtubePlayer);
		
			//Preenche cada tipo de array
			for each(var nomeEstilo:String in FeelMusic.artistas){
				artistasArray.push(nomeEstilo.split("&")[0]);				
			}
			for each(var nomeGenero:String in FeelMusic.generos){
				generosArray.push(nomeGenero.split("&")[0]);
			}
			for(var i:int=1;i<=99;i++) {
				niveisArray.push(i);
			}
			for each(var theme:Object in WordShuffler.themes) {
				if(theme.active) {
					fuvogsArray.push([theme.id, theme.name, theme.musics]);
				}
			}
			fuvogsArray.sortOn("0", Array.NUMERIC);
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(player.temas.indexOf(quintuple[2])!=-1) {
					compradasArray.push(quintuple[4]);
				}
			}
			
			//Põe listeners nos botões
			activateButtonsListeners();
			nextBtn.addEventListener(MouseEvent.CLICK, onForwardList);
			backBtn.addEventListener(MouseEvent.CLICK, onBackwardList);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);
			
			//Prepara o display, exceção é o modo curso, modo "6"
			if(!ehMultiplayer && ordenacao!=6) {
				if(Number(player.nivel)!=ordenacao && Number(player.nivel)>=1 && Number(player.nivel)<9) {
					ordenacao = Number(player.nivel);
				}
			}
			displayEstilos(pointerGlobal, true);
			
			//Se é o modo curso, adaptamos a tela
			if(ordenacao==6) {
				chooseMenuStyle.gotoAndStop(6);
				this["caixaPesquisa"].visible = false;
				musicasCompradasBtn.visible = false;
				searchBtn.visible = false;
				searchTheme.text="";
				searchTheme.y = -200;
			}
		}
		
		public var chosenSearchTheme:String = "";
		public function onChangeStyle(event:MouseEvent):void {
			var sortNumber:Number = Number(event.currentTarget.name.substr(event.currentTarget.name.length-1, int.MAX_VALUE));
			
			//Cancela a ordenacao anterior e então atualiza
			chooseMenuStyle["sort"+ordenacao].gotoAndStop(1);
			ordenacao = sortNumber;
			chooseMenuStyle["sort"+sortNumber].gotoAndStop(2);
			searchTheme.text = FeelMusic._(chooseMenuStyle["sort"+sortNumber].name);
			chosenSearchTheme = searchTheme.text;
			
			//Remostra o estilo, voltando pra página 1
			pointerGlobal = -1;
			displayEstilos(pointerGlobal, true);
		}
		
		public function onMenuStyleOver(event:MouseEvent):void {
			searchTheme.text = FeelMusic._(event.currentTarget.name);
		}
		
		public function onMenuStyleOut(event:MouseEvent):void {
			searchTheme.text = chosenSearchTheme;
		}
		
		protected function onPlayerReady(event:Event):void {
			playerReady = true;
			youtubePlayer.addEventListener(ChromelessPlayer.VIDEO_BEGAN, checkStopVideo);
		}
		
		protected function checkStopVideo(event:Event):void {
			if(parent==null) { youtubePlayer.stopVideo(); }
		}
		
		protected function onLoadSong(name:String):void {
			var index:Number = Number(name.substr(name.length-1, int.MAX_VALUE));
	     	if(ordenacao==1) {youtubePlayer.playSampleMenuEstilos(niveisArray[indiceAtual-6+index], this);}
			else if(ordenacao==2) {youtubePlayer.playSampleMenuEstilos(artistasArray[indiceAtual-6+index], this);}
			else if(ordenacao==3) {youtubePlayer.playSampleMenuEstilos(generosArray[indiceAtual-6+index], this);}
			else if(ordenacao==4) {youtubePlayer.playSampleMenuEstilos(compradasArray[indiceAtual-6+index], this);}
		}
		
		private function activateButtonsListeners():void {
			for(var i:int=1; i<=6; i++) {
				themesList["block"+i]["disco"].gotoAndStop(11); //Tira a cor de dificuldade
				themesList["block"+i].buttonMode = true;
				themesList["block"+i].addEventListener(MouseEvent.CLICK, onWrongClick);
				themesList["theme"+i]["disco"].gotoAndStop(11); 
				themesList["theme"+i].buttonMode = true;
				themesList["theme"+i].addEventListener(MouseEvent.MOUSE_OVER, onGlow);
				themesList["theme"+i].addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);	
			}
		}
		
		protected function onWrongClick(event:MouseEvent):void {
			TweenMax.to(event.currentTarget, 0.1, {blurFilter:{blurX:30, remove:true}});
			var wrongSFX:WrongSoundSFX = new WrongSoundSFX(); 
			wrongSFX.play(1000,0,new SoundTransform(0.5));
		}
		
		protected function onUnGlow(event:MouseEvent):void {
			if(playerReady) { youtubePlayer.stopVideo(); }
			event.currentTarget["stroke"].gotoAndStop(1);
		}
		
		protected function onGlow(event:MouseEvent):void {
			if(playerReady) { onLoadSong(event.currentTarget.name); }
			event.currentTarget["stroke"].gotoAndStop(2);
		}
		
		public var indiceAtual:Number; 
		public function displayEstilos(pointer:Number, focaNoStage:Boolean):void {
			if(stage!=null && focaNoStage) { stage.focus = stage; }
			
			//Escolhe que array será o usado
			var currArray:Array = new Array();
			if(ordenacao==1) {
				currArray = niveisArray;
			} else if(ordenacao==2) {
				currArray = artistasArray;
			} else if(ordenacao==3) {
				currArray = generosArray;
			} else if(ordenacao==4) {
				currArray = compradasArray;
			} else if(ordenacao==6) {
				currArray = fuvogsArray;
			}
			
			//Preenche os temas e os bloqueados:
			var player:MyPlayer = Player.current as MyPlayer;
			for(var i:int=1; i<=6; i++){
				//Ajusta o índice em caso negativo
				indiceAtual = (i+pointer)%currArray.length;
				if(indiceAtual<0){ indiceAtual = currArray.length + (indiceAtual)%currArray.length; }
				
				//Limpa todos os discos
				themesList["theme"+i].gotoAndStop(ordenacao);
				themesList["block"+i].visible = false;
				if(ordenacao==1) {
					if(playerLevel<Number(currArray[indiceAtual])) {
						themesList["block"+i].visible = true;
					}
					themesList["theme"+i].tema.text = "Nivel "+currArray[indiceAtual];
					themesList["theme"+i].levelTxt.text = currArray[indiceAtual];
				} else if(ordenacao==2 || ordenacao==3) {
					themesList["theme"+i].tema.text = currArray[indiceAtual];
				} else if(ordenacao==6) {
					themesList["theme"+i].tema.text = currArray[indiceAtual][1];
					//Se o cara não tiver o fuvog, mostra o block
					if(player.temas.indexOf(currArray[indiceAtual][1])==-1) {
						themesList["block"+i].visible = true;
						themesList["block"+i].week.text = "Missão "+currArray[indiceAtual][0];
						themesList["block"+i].cadeado.visible = true;
					}
				}
				themesList["theme"+i].addEventListener(MouseEvent.CLICK, onChooseTheme);
				themesList["theme"+i].mouseChildren = false;
				
				//Aqui preenche "quantas músicas" de "quantas músicas"
				if(ordenacao==2 || ordenacao==3 || ordenacao==6) {
					//Pega o array das musicas do tema
					var musicasCurrTema:Array = new Array();
					if(ordenacao==2) {
						for each(var artista:String in FeelMusic.artistas){
							if(artista.split("&")[0]==currArray[indiceAtual]) {
								var artistLength:Number = artista.split("&").length;
								var artistSplited:Array = artista.split("&");
								for(var k:int=1; k<artistLength; k++) {
									musicasCurrTema.push(artistSplited[k]);
								}
								break;
							}
						}
					} else if(ordenacao==3) {
						for each(var genero:String in FeelMusic.generos){
							if(genero.split("&")[0]==currArray[indiceAtual]) {
								var genLength:Number = genero.split("&").length;
								var genSplited:Array = genero.split("&");
								for(var l:int=1; l<genLength; l++) {
									musicasCurrTema.push(genSplited[l]);
								}
								break;
							}
						}
					} else if(ordenacao==6) {
						for each(var musicPair:Array in currArray[indiceAtual][2]) {
							musicasCurrTema.push(musicPair[0]);
						}
					}
					
					//Vê quantas músicas do tema o cara tem
					var amntOwnedNum:Number = 0;
					for(var m:int =0; m<player.temas.length; m++) {
						if(musicasCurrTema.indexOf(player.temas[m])>=0) {
							amntOwnedNum++;
						}
					}
					themesList["theme"+i].amntOwned.text = amntOwnedNum.toString();				
					themesList["theme"+i].amntTotal.text = musicasCurrTema.length.toString();
				}
			}
			activateButtonsListeners();
			
			//Vê se some com alguns temas
			if(currArray.length<6) {
				toggleVisibilityDiscs(currArray.length);
			}
			
			//Vê que setas mostra
			pages.text = (Math.ceil(pointerGlobal/6)+1).toString()+"/"+Math.ceil(currArray.length/6).toString();
			if(Math.ceil(pointerGlobal/6)+1==1) { backBtn.visible = false; tecladoLiberado[0] = false; }
			else { backBtn.visible = true; tecladoLiberado[0] = true; }
			if(Math.ceil(pointerGlobal/6)+1==Math.ceil(currArray.length/6)) { nextBtn.visible = false; tecladoLiberado[1] = false; }
			else { nextBtn.visible = true; tecladoLiberado[1] = true;  }
		}
						
		protected function onBackwardList(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			btnPressedSFX.play(0,0,st);
			pointerGlobal-=6;
			blurAndThenShow();
		}
				
		protected function onForwardList(event:MouseEvent):void	{
			var st:SoundTransform = new SoundTransform(); st.volume = 0.2;
			btnPressedSFX.play(0,0,st);
			pointerGlobal+=6;
			blurAndThenShow();
		}
		
		private function blurAndThenShow():void {
			for(var i:int = 1; i<=6; i++) {
				TweenMax.to(themesList["theme"+i], 0.2, {blurFilter:{blurX:30, remove:true}});			
			}
			displayEstilos(pointerGlobal, true);
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
		
		protected function onClickSearchBox(event:MouseEvent):void {
			estilo += "$$$";
			onMusicasMenuEspecial(null);
		}
		
		private function toggleVisibilityDiscs(numInvisible:Number):void {
			for(var i:int=1;i<=6;i++) {
				if(i<=numInvisible) { themesList["theme"+i].visible = true;
				} else { 
					themesList["block"+i].visible = false;
					themesList["theme"+i].visible = false; 
				}
				if(numInvisible == 0) { themesList["theme"+i].visible = true; }
			}
		}
			
		public function onChooseTheme(event:MouseEvent):void {
			//Toca áudio de escolha
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);
			
			//Para de tocar a música anterior
			if(playerReady) { youtubePlayer.stopVideo(); }
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);	

			//Pega o estilo
			if(ordenacao==1) {
				estilo = event.currentTarget.levelTxt.text;
			} else if(ordenacao==2 || ordenacao==3 || ordenacao==6) {
				estilo = event.currentTarget.tema.text;
			} 
			
			if(!ehMultiplayer) {
				//Atualiza a ordenacao se for o caso
				var player:MyPlayer = Player.current as MyPlayer;
				if(ordenacao!=Number(player.nivel) && ordenacao>=1 && ordenacao<=3){
					player.nivel = ordenacao.toString();
					player.saveQueued();
				}
				dispatchEvent(new NavigationEvent(NavigationEvent.MENU));
			} else {
				var possibilidades:Array = new Array();
				for each (var quintuple:Array in FeelMusic.musicIDsArray) {
					if(quintuple[1].indexOf(estilo)!=-1) {
						possibilidades.push(quintuple[4]);
					}
				}
				
				//Pega três músicas aleatórias do tema
				var rand1:Number = Math.floor(Math.random()*possibilidades.length);
				tresMusicas.push(possibilidades[rand1]);	
				var rand2:Number = Math.floor(Math.random()*possibilidades.length);
				while(rand2 == rand1) { rand2 = Math.floor(Math.random()*possibilidades.length); }
				tresMusicas.push(possibilidades[rand2]);
				var rand3:Number = Math.floor(Math.random()*possibilidades.length);
				while(rand3 == rand2 || rand3 == rand1) { rand3 = Math.floor(Math.random()*possibilidades.length); }
				tresMusicas.push(possibilidades[rand3]);
				
				parent.removeChild(this);
			}
		}
		
		//Cai aqui quando se escolhe ver as músicas compradas
		protected function onMusicasMenuEspecial(event:MouseEvent):void {
			//Para de tocar a música anterior
			youtubePlayer.stopVideo();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);
			
			estilo += "especial";
			dispatchEvent(new NavigationEvent(NavigationEvent.MENU));
		}
		
		public function removeKeyboardListener():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownMenus);
		}
	}
}