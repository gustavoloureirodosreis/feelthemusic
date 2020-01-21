package
{
	import com.adobe.webapis.gettext.GetText;
	import com.gamua.flox.Access;
	import com.gamua.flox.Player;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.mixpanel.Mixpanel;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import auxiliares.JanelaAprendizado;
	import auxiliares.NavigationEvent;
	import auxiliares.PopUp;
	import auxiliares.Settings;
	
	import enums.MP_EVT;
	
	import flox_entities.MyPlayer;
	
	import multiplayer.ChooseBetStyleScreen;
	import multiplayer.MPPlayScreen;
	
	public class StartScreen extends MovieClip {
		//Variáveis de elementos já no MC
		public var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
		public var janelaAprendizado:JanelaAprendizado;
		public var errorNoSound:MovieClip;
		public var usernameInfo:MovieClip;
		public var background:MovieClip;
		public var chinaBtn:SimpleButton;
		public var backMenu:SimpleButton;
		public var coins:TextField;
		public var qtdeCongelarTempo:TextField;
		public var qtdeEliminarOpcao:TextField;
		public var qtdeRecuperarCombo:TextField;
		
		//Outras variáveis
		public var musicas:XML = new XML();
		public var posicaoMenu:Number = 1;
		public var existeId:Boolean = false;
		public var existeMasterId:Boolean = false;
		public var mpPlayScreen:MPPlayScreen;
		public var gameMode:GameModeScreen;
		public var menuEstilos:MenuEstilos;
		public var menuMusicas:MenuMusicas;
		public var chooseBetStyle:ChooseBetStyleScreen;
		public var musica:String;
		
		//Mixpanel
		private var mixpanel:Mixpanel;
		
		public function StartScreen() {
			// Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			gameMode = new GameModeScreen();
		}
		
		public function setPopUpListener(popUp:PopUp):void {
			popUp.addEventListener(NavigationEvent.MUSICCHOOSEN, onMusicChosenPopUp);
		}
				
		public function getMusic(){
			return musica;
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			chinaBtn.addEventListener(MouseEvent.MOUSE_OVER, onMoveBtnUp);
			chinaBtn.addEventListener(MouseEvent.MOUSE_OUT, onMoveBtnDown);
			chinaBtn.addEventListener(MouseEvent.CLICK, changeToChinese);
			
			var testSound:Sound = new Sound();
			//Testa se o "gênio" tentou abrir o jogo sem aúdio no computador:
			if(testSound!=null) {
				//Testa se já veio com musicId não-nulo, e só deixa entrar uma primeira vez
				if(FeelMusic.musicId!=null && !existeId) {
					checkMusicId(); 
				} 
				//Análogo, mas para o treino master de uma música
				else if(FeelMusic.masterSongId!=null && !existeMasterId) {
					checkMasterSongId();
				} else {
					//Checa se é guest para cair na tela inicial especial
					if(FeelMusic.ehGuest) {
						menuMusicas = new MenuMusicas("1");
						addChild(menuMusicas);
						menuMusicas.guestScenario();
						menuMusicas.addEventListener(NavigationEvent.MUSICCHOOSEN, onMusicChosen);
						setUIandBack();
						backMenu.visible = false;
						usernameInfo.gotoAndStop(4); 
						usernameInfo["cadastrarBtn"].addEventListener(MouseEvent.CLICK, function() {
							navigateToURL(new URLRequest("/cadastroFTM&redirect=ftm"), "_self");
						});
						if(FeelMusic.codPromo!=null) {
							noLoginButPromoMusics();
						}
					} 
					//Se nao é guest e é jogo normal
					else {
						//Preenche informações do jogador
						var player:MyPlayer = Player.current as MyPlayer;
						
						//Põe o menu de escolha de modo de jogo
						backMenu.visible = false;
						background["gameTitle"].visible = true;
						usernameInfo.gotoAndStop(3);
						usernameInfo["username"].text = player.username;
						gameMode.addEventListener(NavigationEvent.SINGLEPLAY, onContinueSinglePlay);
						gameMode.addEventListener(NavigationEvent.MULTIPLAY, onContinueMultiPlay);
						gameMode.addEventListener(NavigationEvent.CURSOPLAY, onContinueCursoPlay);
						gameMode.addEventListener(NavigationEvent.UPDATECOINS, onUpdateCoinsDisplay);
						this.addChild(gameMode);
						onUpdateCoinsDisplay(null);
					}
				}
			} else {
				errorNoSound["errorSound"].text = FeelMusic._("soundError");
				errorNoSound.y = 0;
				mixpanel.track(MP_EVT.SEM_SOM);
			}	
		}
		
		public function noLoginButPromoMusics():void {
			//Mostra PopUp com as músicas em questão
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			var explanationText:String = "\nATENÇÃO!\n"+
				"Aparentemente você tentou abrir um link para receber músicas sem estar logado!\n"+
				"Caso deseje efetivamente recebê-las e gravar seu progresso, efetue login!\n\n\n"+
				"Att,\n"+
				"Equipe Backpacker";
			popUp.showExplanation(explanationText);
		}
		
		public function checkMusicId():void {
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[2]==FeelMusic.musicId) {
					existeId = true;
					musica = quintuple[4];
					var popUp:PopUp = new PopUp();
					if(FeelMusic.ehGuest) {
						popUp.bringPopUp(this);
						var explanationText:String = "\nATENÇÃO!\n"+
							"Aparentemente você tentou abrir um link para uma música específica sem estar logado!\n"+
							"Caso deseje efetivamente jogar essa música, efetue login!\n\n\n"+
							"Att,\n"+
							"Equipe Backpacker";
						popUp.showExplanation(explanationText);
						popUp.addEventListener(Event.REMOVED_FROM_STAGE, onFailMusicId);
					} else {
						var player:MyPlayer = Player.current as MyPlayer;
						if(player.temas.indexOf(FeelMusic.musicId)==-1) {
							popUp.bringPopUp(this);
							var explanationText2:String = "\nATENÇÃO!\n"+
								"Aparentemente você tentou abrir um link para uma música específica sem tê-la!\n"+
								"Caso deseje efetivamente jogar essa música, adquira-a normalmente dentro do jogo!\n\n\n"+
								"Att,\n"+
								"Equipe Backpacker";
							popUp.showExplanation(explanationText2);
							popUp.addEventListener(Event.REMOVED_FROM_STAGE, onFailMusicId);
						} else {
							dispatchEvent(new NavigationEvent(NavigationEvent.START));
						}
					}
				}
			}
			//Se não acha o Id, recomeça o AddedToStage sem musicId 
			if(!existeId) {
				onFailMusicId(null);
			}
		}
		
		public function onFailMusicId(event:Event):void {
			FeelMusic.musicId = null;
			onAddedToStage(null);
		}
		
		public function checkMasterSongId():void {			
			for each(var quintuple2:Array in FeelMusic.musicIDsArray) {
				if(quintuple2[2]==FeelMusic.masterSongId) {
					existeMasterId = true;
					musica = quintuple2[4];
					dispatchEvent(new NavigationEvent(NavigationEvent.START));
				}
			}
			//Se não acha o Id, recomeça o AddedToStage sem masterSongId 
			if(!existeMasterId) {
				FeelMusic.masterSongId = null;
				onAddedToStage(null);
			}
		}
		
		var jaSubiu:Boolean = false
		protected function onMoveBtnDown(event:MouseEvent):void {
			if(jaSubiu) {
				TweenLite.to(event.currentTarget, 0.5, {y:chinaBtn.y+65});
				jaSubiu = false;
			}
		}
		
		protected function onMoveBtnUp(event:MouseEvent):void {
			if(!jaSubiu) {
				TweenLite.to(event.currentTarget, 0.5, {y:chinaBtn.y-65, ease:Back.easeOut});
				jaSubiu = true;
			}
		}
		
		private function commonContinue():void {
			var player:MyPlayer = Player.current as MyPlayer;
			backMenu.visible = true;
			background["gameTitle"].visible = false;
			if(FeelMusic.ehGuest) {
				usernameInfo.gotoAndStop(2);
			} else {
				usernameInfo.gotoAndStop(1); 
				usernameInfo["username"].text = player.username;
				usernameInfo["myProgressBtn"].addEventListener(MouseEvent.CLICK, showJanelaAprendizado);
			}
			usernameInfo["moreMPcoins"].addEventListener(MouseEvent.CLICK, onShowMoreMPcoins);
			usernameInfo["moreCoins"].addEventListener(MouseEvent.CLICK, onShowLojinha);
			onUpdateCoinsDisplay(null);
			
			//Checagens extras abaixo para o caso de ser guest
			if(gameMode!=null && contains(gameMode)) { this.removeChild(gameMode); }
			if(menuMusicas!=null && contains(menuMusicas)) {this.removeChild(menuMusicas); }
			if(FeelMusic.ehGuest) { backMenu.visible = false; }
		}
		
		private function commonBringMenuEstilos():void {
			this.addChild(menuEstilos);
			menuEstilos.addEventListener(NavigationEvent.UPDATECOINS, onUpdateCoinsDisplay);
			menuEstilos.addEventListener(NavigationEvent.MENU, onChoseEstilo);
			setUIandBack();			
		}
		
		public function onContinueMultiPlay(event:Event):void {
			commonContinue();
						
			chooseBetStyle = new ChooseBetStyleScreen(this);
			chooseBetStyle.addEventListener(NavigationEvent.UPDATECOINS, onUpdateCoinsDisplay);
			chooseBetStyle.addEventListener(NavigationEvent.STARTMP, onChoseSongMP);
			this.addChild(chooseBetStyle);
			setUIandBack();
		}
				
		public function onContinueSinglePlay(event:Event):void {
			commonContinue();
			menuEstilos = new MenuEstilos();
			commonBringMenuEstilos();	
		}
		
		protected function onContinueCursoPlay(event:Event):void {
			commonContinue();
			menuEstilos = new MenuEstilos();
			menuEstilos.setOrdenacao(6);
			commonBringMenuEstilos();
		}
		
		public function onUpdateCoinsDisplay(event:Event):void {
			var player:MyPlayer = Player.current as MyPlayer;
			usernameInfo["coinsSP"].text = setTrailingZeroes(player.nrCoins.toString());
			usernameInfo["coinsMP"].text = setTrailingZeroes(player.nrMPCoins.toString());
		}
		
		public function setUIandBack():void {
			if(!FeelMusic.ehGuest) { backMenu.visible = true; }
			setChildIndex(backMenu, numChildren-1);
			setChildIndex(usernameInfo, numChildren-1);
			backMenu.addEventListener(MouseEvent.CLICK, onBackToGameMode);	
		}
		
		protected function onBackToGameMode(event:MouseEvent):void {
			if(menuEstilos!=null && contains(menuEstilos)) { menuEstilos.youtubePlayer.stopVideo(); removeChild(menuEstilos); }
			if(chooseBetStyle!=null && contains(chooseBetStyle)) {removeChild(chooseBetStyle); }
			btnPressedSFX.play(0,0,new SoundTransform(0.2));
			onAddedToStage(null);
		}		
		
		public function onChoseEstilo(navigationEvent:NavigationEvent){
			var estilo:String = menuEstilos.getEstilo();
			menuMusicas = new MenuMusicas(estilo);
			menuMusicas.x = 1600;
			addChild(menuMusicas);
			setUIandBack();
			menuMusicas.addEventListener(NavigationEvent.UPDATECOINS, onUpdateCoinsDisplay);
			menuMusicas.backMenuEstilos.visible = false;
			TweenLite.to(menuEstilos, 0.25, {x:-1600, ease:Back.easeIn, onComplete:enterMusicasMenu});
		}
		
		public function enterMusicasMenu():void{
			TweenLite.to(menuMusicas, 0.25, {x:0, ease:Back.easeOut, onComplete:function():void{menuMusicas.backMenuEstilos.visible=true;}});
			backMenu.visible = false;
			menuMusicas.addEventListener(NavigationEvent.PREVIOUSMENU, backToMenuEstilos);
			menuMusicas.addEventListener(NavigationEvent.MUSICCHOOSEN, onMusicChosen);
		}
		
		public function backToMenuEstilos(e:Event):void{
			menuMusicas.removeKeyboardListener();
			TweenLite.to(menuMusicas, 0.25, {x:1600, ease:Back.easeIn, onComplete:backEstilosMenu});			
		}
		
		public function backEstilosMenu():void{
			removeChild(menuMusicas);
			removeChild(menuEstilos);
			menuEstilos.x = -1600;
			addChild(menuEstilos);
			menuEstilos.estilo = "";
			menuEstilos.displayEstilos(menuEstilos.pointerGlobal, true);
			setUIandBack();
			setChildIndex(usernameInfo, numChildren-1);
			TweenLite.to(menuEstilos, 0.25, {x:0, ease:Back.easeOut});
		}
		
		public function onMusicChosen(navigationEvent:NavigationEvent){
			musica = menuMusicas.getMusic();
			removeChild(menuMusicas);
			dispatchEvent(new NavigationEvent(NavigationEvent.START));
		}
		
		protected function onMusicChosenPopUp(evt:NavigationEvent):void {
			musica = evt.data.name;
			dispatchEvent(new NavigationEvent(NavigationEvent.START));			
		}
		
		protected function onChoseSongMP(event:Event):void {
			chooseBetStyle.removeEventListener(NavigationEvent.STARTMP, onChoseSongMP);
			this.removeChild(chooseBetStyle);
			mpPlayScreen = new MPPlayScreen(chooseBetStyle.chosenMatch);
			mpPlayScreen.x = 0; 
			this.addChild(mpPlayScreen);
			usernameInfo.visible = false;
			mpPlayScreen.addEventListener(NavigationEvent.END, onMatchEndMP);
		}
		
		protected function onMatchEndMP(event:Event):void {
			//Pega as informações atualizadas da match
			chooseBetStyle.chosenMatch = mpPlayScreen.currentMatch;
			chooseBetStyle.chosenMatch.publicAccess = Access.READ_WRITE; 
			chooseBetStyle.chosenMatch.saveQueued();
			this.removeChild(mpPlayScreen);
			usernameInfo.visible = true;
			this["backMenu"].visible = true;
			
			//Mixpaneliza
			var player:MyPlayer = Player.current as MyPlayer;
			mixpanel.track(MP_EVT.MUSICA_JOGADA, {
				'Artista': mpPlayScreen.musicGlobal.split('-')[0],
				'Musica': mpPlayScreen.musicGlobal.split('-')[1]
			});	
			
			//Dispara evento para FeelMusic tratar como SinglePlayer
			dispatchEvent(new NavigationEvent(NavigationEvent.ENDMP));
		}
		
		protected function onMakeLogin(event:Event):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.MAKELOGIN));	
		}
		
		protected function onContinueRestartAfterEnding(event:Event):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.DONTMAKELOGIN));				
		}
		
		protected function showJanelaAprendizado(event:MouseEvent):void {
			var bringStuff:BringStuffSFX = new BringStuffSFX; bringStuff.play();
			janelaAprendizado.addEventListener(NavigationEvent.PLAYAGAIN, onRemoveMenus);
			setChildIndex(janelaAprendizado, numChildren-1);
			TweenLite.to(janelaAprendizado, 0.33, {x:70, y:20, scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		protected function onRemoveMenus(event:Event):void {
			if(menuEstilos!=null && contains(menuEstilos)) { menuEstilos.removeKeyboardListener(); removeChild(menuEstilos); }
			if(menuMusicas!=null && contains(menuMusicas)) { menuMusicas.removeKeyboardListener(); removeChild(menuMusicas); }
			if(chooseBetStyle!=null && contains(chooseBetStyle)) { removeChild(chooseBetStyle); }
		}
		
		protected function onQuitGame(event:MouseEvent):void {
			SoundMixer.stopAll();
			dispatchEvent(new Event(NavigationEvent.QUITGAME)); //NavigationEvent.QUITGAME == "quitgame"
			parent.removeChild(this);
		}
		
		public function onShowLojinha(event:MouseEvent):void {
			if(!FeelMusic.ehGuest) {
				var popUp:PopUp = new PopUp();
				popUp.bringPopUp(this);
				popUp.showLojinha();
				popUp.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateCoinsDisplay);
			} else {
				navigateToURL(new URLRequest("/cadastroFTM&redirect=ftm"), "_self");
			}
		}
		
		public function onShowMoreMPcoins(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showMoreMPcoins();
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateCoinsDisplay);
		}
		
		public function popUpRoulette(mc:MovieClip):void {
			var player:MyPlayer = Player.current as MyPlayer;
			var popUp:PopUp = new PopUp();
			//Se já é um cara vivido que pode começar a ouvir falar de compras
			if(player.diasJogados>=3 && player.tempoTotal>=1800 && player.compras.length==0) {
				var rand:Number = Math.random();
				//Mostra ou premium, ou lojinha normal, ou invite
				if(rand<0.45) {
					popUp.bringPopUp(mc);
					popUp.showPremiumProposal();
				} else if(rand>=0.45 && rand<0.55) {
					popUp.bringPopUp(mc);
					popUp.showLojinha();
				} else {
					inviteFBfriends(null);;
				}
				//Se é leite com pera, vamos pedir pra convidar amiguinhos
			} else {
				if(player.nrCoins<500) {
					inviteFBfriends(null);
				}
			}
		}
		
		private function inviteFBfriends(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.inviteFriends();
		}
		
		public var loadingScreen:LoadingScreen = new LoadingScreen();
		protected function changeToChinese(event:MouseEvent):void {
			chinaBtn.visible = false;
			addChild(loadingScreen);
			var gettext:GetText = GetText.getInstance();
			gettext.addEventListener(Event.COMPLETE, onGettextComplete);
			gettext.translation("FTM", Settings.LOCALE_URL, "zh");
			gettext.install();
		}
		
		protected function onGettextComplete(event:Event):void {
			if(contains(loadingScreen)) {
				removeChild(loadingScreen);			
			}
		}
		
		public static function setTrailingZeroes(crudeString:String):Object {
			var numAux:Number = Number(crudeString);
			var zeroes:String = "000000";
			for(var i:int=1; i<=5; i++) {
				zeroes = zeroes.substr(1,int.MAX_VALUE);
				if(numAux < 10*i && numAux >= 10*(i-1)){
					return zeroes+crudeString;
				}
			}
			return zeroes+crudeString;
		}
	}
}