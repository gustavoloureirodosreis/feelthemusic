package {
	
	import com.adobe.webapis.gettext.GetText;
	import com.gamua.flox.Access;
	import com.gamua.flox.AuthenticationType;
	import com.gamua.flox.Entity;
	import com.gamua.flox.Flox;
	import com.gamua.flox.Player;
	import com.gamua.flox.Query;
	import com.gamua.flox.TimeScope;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.mixpanel.Mixpanel;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import auxiliares.FuvogCalculator;
	import auxiliares.NavigationEvent;
	import auxiliares.PlayScreenController;
	import auxiliares.PopUp;
	import auxiliares.Settings;
	
	import enums.MP_EVT;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import flox_entities.BrokenSongs;
	import flox_entities.GameID;
	import flox_entities.Invites;
	import flox_entities.MyPlayer;
	
	import multiplayer.MPPlayScreen;
	
	public class FeelMusic extends MovieClip {
		//Telas que essa classe trabalha com
		public var createLoginScreen:CreateLoginScreen;
		public var loadingScreen:LoadingScreen;
		public var startScreen:StartScreen;
		public var playScreen:PlayScreen;
		public var mpPlayScreen:MPPlayScreen;
		public var tutorialScreen:TutorialScreen;
		public var endScreen:EndScreen;
		
		//Variáveis estáticas para o jogo inteiro
		public static var musicIDsArray:Array = new Array();
		public static var musicasNivelUm:Array = [29, 32, 74, 94, 162, 189, 300, 523];
		public static var es_musicasNivelUm:Array = [31, 50, 698, 146, 25, 83, 280, 622];
		public static var musicasPremium:Array = []; 
		public static var artistas:Array = new Array();
		public static var generos:Array = new Array();
		public static var loadedTranslations:Boolean = false;
		public static var ehGuest:Boolean = false;
		public static var tipoUsuario:String = "4";
		public static var gameLang:String = "en";
		
		//Variáveis somente daqui
		private var xmlQueue:LoaderMax;
		
		//Variáveis acerca do Mixpanel
		private var mixpanel:Mixpanel;

		//Outras variáveis:
		public static var codPromo:String;
		public static var musicId:String;
		public static var masterSongId:String;
		public static var onFacebook:Boolean;
		public static var nameFacebook:String;
		public static var curso:Object;
		private var lang:String;
		private var emailPlayer:String; 
		private var idPlayer:String;
		private var usernamePlayer:String;
		private var friends:Array;
		
		public function FeelMusic(infos:Object) {
			// Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			//Pega as informações de email, id, username, e - se tiver - musicId
			emailPlayer = infos.email;
			idPlayer = infos.id;
			usernamePlayer = infos.username;
			musicId = infos.musicId;
			masterSongId = infos.masterSongId;
			if(infos.tipoUsuario!=null) { tipoUsuario = infos.tipoUsuario; }
			if(infos.lang!=null) { lang = infos.lang; }
			else { lang = "pt"; }
			if(infos.onFacebook!=null) { onFacebook = infos.onFacebook; }
			else { onFacebook = false; }
			if(infos.friends!=null) {friends = infos.friends;}
			if(infos.nameFacebook!=null) {nameFacebook = infos.nameFacebook;}
			if(infos.codPromo!=null) {codPromo = infos.codPromo;}
			if(infos.curso!=null) {curso = infos.curso;}
			if(infos.gameLang!=null) {
				gameLang = infos.gameLang;
				Settings.changeGameLanguage(infos.gameLang);
			}
		}
		
		public function initFTM():void {
			startScreen = new StartScreen();
			startScreen.addEventListener(NavigationEvent.START, onStartPlayScreen);
			startScreen.addEventListener(NavigationEvent.ENDMP, onEndMovieMP);
			startScreen.addEventListener(NavigationEvent.MAKELOGIN, onMakeLogin);
			startScreen.addEventListener(NavigationEvent.DONTMAKELOGIN, onRestartAfterEnding);
			startScreen.addEventListener(NavigationEvent.QUITGAME, onQuitGame);
			startScreen["janelaAprendizado"].addEventListener(NavigationEvent.PLAYAGAIN, onRestartPlayScreen);

			//Põe a tela de loading e só tira quando tiver carregado o usuário e os XML
			loadingScreen = new LoadingScreen();
			addChild(loadingScreen);
			
			//Começa o Flox
			initFlox();				
		}
				
		public function initFTMguest():void {
			ehGuest = true;
			initFTM();
		}
		
		private function initFlox():void {
			Flox.playerClass = MyPlayer;	
			if(gameLang=="en") {
				Flox.init(GameID.GAME_ID, GameID.GAME_KEY, GameID.GAME_VERSION);
			} else if(gameLang=="es") {
				Flox.init(GameID.ES_GAME_ID, GameID.ES_GAME_KEY, GameID.ES_GAME_VERSION);				
			}
			loadXMLs();
		}		
		
		private function loadXMLs():void {
			xmlQueue = new LoaderMax({
				name: "xmlQueue",
				auditSize: false,
				onComplete: function(event:LoaderEvent):void {
					parseXMLs();
				},
				onError: function(event:LoaderEvent):void {
					trace("error occured with " + event.target + ": " + event.text);
				}
			});
			
			var path = "";
			if(gameLang=="en") {
				path = "Musicas/";
			} else if(gameLang=="es") {
				path = "ES_Musicas/"
			}
			
			xmlQueue.append(new XMLLoader(path+"Index/MusicsIDs.xml", {name:"musicsIDsXML"}));
			xmlQueue.append(new XMLLoader(path+"Index/Estilos.xml", {name:"estilosXML"}));
			xmlQueue.append(new XMLLoader(path+"Index/Generos.xml", {name:"generosXML"}));
			xmlQueue.load();
		}
		
		public var fileRef:FileReference=new FileReference();
		public var content:String = "";
		private function parseXMLs():void {
			var musicsIDsXml:XML = xmlQueue.getContent("musicsIDsXML");
			var estilosXml:XML = xmlQueue.getContent("estilosXML");
			var generosXml:XML = xmlQueue.getContent("generosXML");
			
			var nomesMusicas:XMLList = musicsIDsXml.nomes.children();
			var musicsIDsXmlLength:int = nomesMusicas.length();
			
			var nomesEstilos:XMLList = estilosXml.nomes.children();
			for each(var nEstilo:XML in nomesEstilos){
				artistas.push(nEstilo.toString());
			}
			
			var nomesGeneros:XMLList = generosXml.nomes.children();
			for each(var nGenero:XML in nomesGeneros){
				generos.push(nGenero.toString());				
			}
			
			//Prepara os arrays de musicIDs, artistas e generos
			var auxArtistas:Array = [];
			for each(var artista:String in artistas) {
				auxArtistas.push(artista);
			}
			var auxGeneros:Array = [];
			for each(var genero:String in generos) {
				auxGeneros.push(genero);
			}
			
			//Preenche musicIDsArray
			for each (var nMusica:XML in nomesMusicas) {  
				musicIDsArray.push([
					nMusica.@diff,
					nMusica.@genero, 
					nMusica.@id,
					nMusica.@url,
					nMusica.toString()
				]);
			}
			
			var musicasLivres:Object = {}
			for(var h:int=1; h<=99; h++) {
				musicasLivres[h] = 8;
			}
			for(var i:int=2; i<musicIDsArray.length; i++) {
				if(musicasLivres[musicIDsArray[i][0]]==0) {
					musicasPremium.push(nomesMusicas[i].toString());			
				} else {
					musicasLivres[musicIDsArray[i][0]]--;
				}
			}
			
			//Preenche arrays de artistas e gêneros
			var index:Number;
			for each (var quintuple:Array in musicIDsArray) {
				// artista
				index = artistas.indexOf(quintuple[4].split(" - ")[0]);
				if(index >= 0) {
					auxArtistas[index] = auxArtistas[index] + "&" + quintuple[2];
				}
				// genero
				var musicGenders:Array = quintuple[1].split(" ");
				index = generos.indexOf(musicGenders[0]);
				if(index >= 0) {
					auxGeneros[index] = auxGeneros[index] + "&" + quintuple[2];
				}
				if(musicGenders[1] != null) {
					index = generos.indexOf(musicGenders[1]);
					if(index >= 0) {
						auxGeneros[index] = auxGeneros[index] + "&" + quintuple[2];
					}
				}
			}
			artistas = auxArtistas;
			generos = auxGeneros;
			
			//Carrega as musicas quebradas
			var brokenId:String = "curr-broken";
			Entity.load(BrokenSongs, brokenId,
				onBrokenSongs,
				function onError(error:String, httpStatus:int):void {
					trace("Erro de musicas quebradas. HttpStatus: "+httpStatus);
				}
			);
		}
		
		protected function onBrokenSongs(broken:BrokenSongs):void {
			for each(var idBroken:String in broken.currBroken) {
				for each(var quintuple:Array in musicIDsArray) {
					if(quintuple[2]==idBroken) {
						musicIDsArray.splice(musicIDsArray.indexOf(quintuple), 1);
						break;
					}
				}
			}
			
			//Carrega as traduções
			var gettext:GetText = GetText.getInstance();
			gettext.addEventListener(Event.COMPLETE, onGettextComplete);
			gettext.addEventListener(IOErrorEvent.IO_ERROR, onIOerror);
			gettext.translation("FTM", Settings.LOCALE_URL, lang);
			gettext.install();
		}
		
		protected function onIOerror(event:Event):void {
			trace("Erro ao abrir traducoes: "+event);			
		}
		
		public var file:FileReference = new FileReference();
		public var data:ByteArray = new ByteArray();
		private function onGettextComplete(event:Event):void {
			//queryForPlayerTypes(2200);

			//Mesmo que mudemos a língua no meio do jogo não carregará esse evento de novo
			if(!loadedTranslations) {
				loadedTranslations = true;
				
				//Força logout para atualizar informações do player
				Player.logout();
				startPlayer();
				
				//Descomentar abaixo somente para calcular fuvogs ou musicas quebradas algum dia
				//var fuvogCalculator:FuvogCalculator = new FuvogCalculator();
				//fuvogCalculator.calculaFuvogs(0);
				//fuvogCalculator.calculaBroken(0);
			}
		}
		
		public var fullText:String = "";
		public var guests:Number = 0;
		public function queryForPlayerTypes(offset:Number):void {
			var query:Query = new Query(MyPlayer);
			query.limit = 50;
			query.offset = offset*50;
			
			if(offset<2400) {
				trace("Total vistos: "+offset*50);
				trace("Total guests: "+guests);
				query.find(
					function onComplete(players:Array):void {
						offset++;
						for each(var player:MyPlayer in players) {
							if(player.email!=null) {
								if(player.diasJogados<3 && player.primeiraPontuacao!=null && player.primeiraPontuacao.length<3) {
									fullText += "Player START: "+player.email+"\n"
								}
								if(player.diasJogados>=3 && player.primeiraPontuacao!=null && player.primeiraPontuacao.length>=3
									&& player.primeiraPontuacao.length<10) {
									fullText += "Player FIRST VALUE: "+player.email+"\n"
								}
								if(player.diasJogados>=3 && player.primeiraPontuacao!=null && player.primeiraPontuacao.length>=10) {
									fullText += "Player RECURRING VALUE: "+player.email+"\n"
								}
							} else {
								guests++;
							}
						}
						queryForPlayerTypes(offset);
					},
					function onError(error:String):void {
						trace("Erro de query: "+error+" ...recomeçando...");
						queryForPlayerTypes(offset);
					}
				);
			} else {
				trace("Terminou! "+new Date());							
				this.addEventListener(MouseEvent.CLICK, onFinish);
			}
		}
		
		public function onFinish(event:MouseEvent):void {
				data.writeMultiByte (fullText, "utf-8");
				file.save(data, "myfile4.txt");
		}
		
		private function startPlayer():void	{
			//Checar se é a primeira vez vendo se a autenticação é "GUEST". Sendo, cria-se um login.
			if(Player.current.authType == AuthenticationType.GUEST) {
				Player.loginWithKey(idPlayer,
					function onComplete(p:Player) {
						var player:MyPlayer = Player.current as MyPlayer;						
						if(!player.jaCriado) {
							player.username = usernamePlayer;
							player.playerKey = idPlayer;
							player.email = "guest@guestmail.com";
							player.sexo = "a definir";
							player.idade = "a definir";
							player.tipoPerfil = "a definir";
							player.alunos = new Array();
							player.primeiraPontuacao = new Array();
							player.expressAcertadas = new Array();
							player.expressBem = new Array();
							player.playDates = new Array();
							player.sugestions = new Array();
							player.compras = new Array();
							player.levels = new Array();
							player.friends = new Array();
							player.temas = musicasNivelUm;
							player.itens = [0,0,0,0,0,0,20,20];
							player.diasJogados = 0;
							player.nivel = "1";
							player.jaViuTutorial = false;
							player.viuTutorial = false;
							if(gameLang=="en") {
								player.achievements = [["Location",0,0],["Pronouns",0,0],["Adverbs",0,0]];
							} else if(gameLang=="es") {
								player.achievements = [["Saludos",0,0],["Despedidas",0,0],["Numeros cardinales",0,0]];
							}
							if(ehGuest) {
								player.nrCoins = 50;
								player.nrMPCoins = 50;
								player.experience = 0;
							} else {
								player.nrCoins = 1000;
								player.nrMPCoins = 500;
								player.experience = 11;
							}
							if(nameFacebook!=null) {
								var invitesId:String = "curr-invites";
								Entity.load(Invites, invitesId,
									function onComplete(invite:Invites):void {
										invite.sent.push(nameFacebook);
										invite.saveQueued();
									},
									function onError(error:String, httpStatus:int):void {}
								);
							}
							player.jaCriado = true;
							player.saveQueued();	
						}
						//Criado um novo login, recarrega-se "startPlayer" para agora não cair em "guest"
						startPlayer();
					}, function onError(message:String) {
						loadingScreen.gotoAndStop(2); 
						loadingScreen.fillText(2);
						loadingScreen["errorMsg"].text = message;
					});
			} else {
				Player.current.refresh(
					function onComplete(p:Player) {
						//Checa por atualizações no player
						Settings.checkPlayerUpdates(startScreen, emailPlayer, usernamePlayer, friends);
						
						var player:MyPlayer = Player.current as MyPlayer;
						//Identifica o jogador no mixpanel
						mixpanel.identify(player.playerKey);
						if(!ehGuest) {
							mixpanel.people_set({
								'$email': player.email,
								'Username': player.username,
								'ID': player.playerKey,
								'# dias jogados': player.diasJogados,
								'# musicas jogadas': player.playDates.length
							});
						}
						mixpanel.register({
							"Guest": ehGuest,
							"Dias Jogados": player.diasJogados,
							"Musicas Jogadas": player.playDates.length
						});
						
						//Aqui começa o jogo realmente
						startScreen.usernameInfo["levelBar"].setPlayerLevel();
						startScreen.usernameInfo["username"].text = player.username;
						startScreen.usernameInfo["coinsSP"].text = StartScreen.setTrailingZeroes(player.nrCoins.toString());
						startScreen.usernameInfo["coinsMP"].text = StartScreen.setTrailingZeroes(player.nrMPCoins.toString());
						
						//Aqui começa o jogo de fato de fato
						removeChild(loadingScreen);
						addChild(startScreen);
						mixpanel.track(MP_EVT.CARREGOU_JOGO);						
					},
					function onError(message:String) {
						loadingScreen.gotoAndStop(2); 
						loadingScreen.fillText(2);
						loadingScreen["errorMsg"].text = message;
					});
			}
		}
		
		public function onStartPlayScreen(evt:NavigationEvent):void {
			var musica:String = "musica-vazia-comecando-playscreen";
			if(evt.data==null) {
				musica = startScreen.getMusic();
			} else {
				for each(var quintuple:Array in FeelMusic.musicIDsArray) {
					if(quintuple[2] == evt.data.id) {
						musica = quintuple[4];
						break;
					}
				}
			}
			playScreen = new PlayScreen(musica);
			
			if(playScreen!=null && contains(playScreen)) { removeChild(playScreen); }
			if(endScreen!=null && contains(endScreen)) { removeChild(endScreen); }
			
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.jaViuTutorial){
				addChild(playScreen);				
				playScreen.addEventListener(NavigationEvent.END, onEndMovieSP);
				playScreen.addEventListener(NavigationEvent.ENDLEAVING, onEndLeaving);
			} else {
				tutorialScreen = new TutorialScreen();
				addChild(tutorialScreen);
				tutorialScreen.addEventListener(Event.REMOVED_FROM_STAGE, onPlayScreenAfterTutorial);
			}
			var dataAtual:Date = new Date();
			player.playDates.push([dataAtual, musica]);	
		}
		
		protected function onRestartPlayScreen(event:NavigationEvent):void {
			if(ehGuest) {
				createLoginScreen = new CreateLoginScreen();
				addChild(createLoginScreen);
				createLoginScreen.addEventListener(NavigationEvent.DONTMAKELOGIN, function():void{onStartPlayScreen(event);});
				createLoginScreen.addEventListener(NavigationEvent.MAKELOGIN, onMakeLogin);
			} else {
				onStartPlayScreen(event);
			}	
		}
		
		protected function onPlayScreenAfterTutorial(event:Event):void {
			addChild(playScreen);				
			playScreen.addEventListener(NavigationEvent.END, onEndMovieSP);
			playScreen.addEventListener(NavigationEvent.ENDLEAVING, onEndLeaving);			
		}
		
		protected function onEndLeaving(event:Event):void {
			estiloJogado = "SP";
			onRestartAfterEnding(null);
			
			mixpanel.track(MP_EVT.FECHOU_MUSICA, {
				'Artista': playScreen.musicGlobal.split('-')[0],
				'Musica': playScreen.musicGlobal.split('-')[1]
			});
		}
		
		public var finalScore:Number;
		public var perfectScore:Number;
		public var goodScore:Number;
		public var badScore:Number;
		public var missScore:Number;
		public var comboScore:Number;
		public var accuracy:Number; 
		public var timeNew:Number;
		public var expressNew:Array = new Array();
		public var auxExpressBemNew:Array = new Array();
		public var versosModificados:Array = new Array();
		public var auxItens:Array = new Array();
		public var temasAbordados:Array = new Array();
		public var estiloJogado:String = "";
		public function onEndMovieSP(navigationEvent:NavigationEvent):void {
			estiloJogado = "SP";
			
			//Tira as últimas informações da PlayScreen
			finalScore = playScreen.getFinalScore();
			perfectScore = playScreen.getPerfectScore();
			goodScore = playScreen.getGoodScore();
			badScore = playScreen.getBadScore();
			missScore = playScreen.getMissScore();
			accuracy = playScreen.getAccuracy();
			comboScore = playScreen.getComboScore();
			timeNew = playScreen.getNewTime();
			expressNew = playScreen.getNewExpressions();
			auxExpressBemNew = playScreen.getNewAuxExpressionsBem();
			versosModificados = playScreen.getVersosModificados();
			temasAbordados = playScreen.getTemasAbordados();
			auxItens = playScreen.getNewItens();
			accuracy = playScreen.getAccuracy();
					
			//Cria a EndScreen
			endScreenCommon(playScreen.musicGlobal);
			endScreen.addEventListener(NavigationEvent.PLAYAGAIN, onRestartPlayScreen);
			
			//Cria o evento de musica completada
			var eventMusica:NavigationEvent = new NavigationEvent(NavigationEvent.MUSICCOMPLETE);
			
			var finalizada:Boolean = false;
			if(navigationEvent.type!="endleaving"){
				finalizada = true;
				endScreen.setStars(accuracy);
				eventMusica.data = {artista: playScreen.musicGlobal.split('-')[0], 
									musica: playScreen.musicGlobal.split('-')[1],
									completada: true};
			} else {
				endScreen.setStars(-1);
				eventMusica.data = {artista: playScreen.musicGlobal.split('-')[0], 
					musica: playScreen.musicGlobal.split('-')[1],
					completada: false};
			}
			
			//Mixpaneliza
			var player:MyPlayer = Player.current as MyPlayer;
			mixpanel.track(MP_EVT.MUSICA_JOGADA, {
				'Artista': playScreen.musicGlobal.split('-')[0],
				'Musica': playScreen.musicGlobal.split('-')[1]
			});
			
			//Manda pro Cambará a música jogada (repare que só singleplayer porque aqui há escolha de que música jogar)
			var urlMusicPlayed:URLRequest = new URLRequest("http://www.backpacker.com.br/music.user&artista="+
				encodeURI(playScreen.musicGlobal.split('-')[0])+"&musica="+
				encodeURI(playScreen.musicGlobal.split('-')[1]));
			var loaderMusicPlayed:Loader = new Loader();
			loaderMusicPlayed.load(urlMusicPlayed);
						
			//Aqui despacha o NavigationEvent.MUSICCOMPLETED com .data = {artista:string1, musica:string2, completada:bool}
			dispatchEvent(eventMusica as Event);
		}

		protected function onEndMovieMP(event:Event):void {
			estiloJogado = "MP";
			
			//Tira as últimas informações da startScreen.mpPlayScreen
			finalScore = startScreen.mpPlayScreen.getFinalScore();
			perfectScore = startScreen.mpPlayScreen.getPerfectScore();
			goodScore = startScreen.mpPlayScreen.getGoodScore();
			badScore = startScreen.mpPlayScreen.getBadScore();
			missScore = startScreen.mpPlayScreen.getMissScore();
			comboScore = startScreen.mpPlayScreen.getComboScore();
			timeNew = startScreen.mpPlayScreen.getNewTime();
			expressNew = startScreen.mpPlayScreen.getNewExpressions();
			auxExpressBemNew = startScreen.mpPlayScreen.getNewAuxExpressions();
			versosModificados = startScreen.mpPlayScreen.getVersosModificados();
			auxItens = startScreen.mpPlayScreen.getNewItens();
			
			//MUDAR URGENTE
			accuracy += startScreen.mpPlayScreen.getAccuracy();
			
			//Cria a EndScreen e desaparece com o que não pode ter numa EndScreen vinda do MultiPlayer
			endScreenCommon(startScreen.mpPlayScreen.musicGlobal);
			endScreen.repeatBtn.y = 10000;
			endScreen.continueBlock.y = 10000;
			endScreen.continueBtn.y = 10000;
			endScreen.continueQuantity.y = 10000;
			
			//Cria o evento de musica completada
			var eventMusica:NavigationEvent = new NavigationEvent(NavigationEvent.MUSICCOMPLETE);
			eventMusica.data = {artista: startScreen.mpPlayScreen.musicGlobal.split('-')[0], 
				musica: startScreen.mpPlayScreen.musicGlobal.split('-')[1],
				completada: true};
			
			//AQUI DESPACHA O NavigationEvent.MUSICCOMPLETED com .data = {artista:string1, musica:string2, completada:bool}
			dispatchEvent(eventMusica as Event);
		}
		
		private function endScreenCommon(musicaQueTocou:String):void {
			endScreen = new EndScreen();
			endScreen.addEventListener(NavigationEvent.AGAIN, onRestartAfterEnding);
			addChild(endScreen);
			endScreen.setMusicName(musicaQueTocou);
			endScreen.setFinalScore(finalScore);
			endScreen.setPerfectScore(perfectScore);
			endScreen.setGoodScore(goodScore);
			endScreen.setBadScore(badScore);
			endScreen.setMissScore(missScore);
			endScreen.setComboScore(comboScore);
			endScreen.savePlayerNewInfos(timeNew, expressNew, auxExpressBemNew, auxItens);
			endScreen.setLetraMotion(versosModificados);
			endScreen.setTemas(temasAbordados);
			endScreen.setStars(accuracy);
		}
		
		public function onRestartAfterEnding(evt:Event):void {
			//Checa se é guest, pra ver se faz pedido de login ou não
			if(ehGuest) {
				createLoginScreen = new CreateLoginScreen();
				addChild(createLoginScreen);
				createLoginScreen.addEventListener(NavigationEvent.DONTMAKELOGIN, onContinueRestartAfterEnding);
				createLoginScreen.addEventListener(NavigationEvent.MAKELOGIN, onMakeLogin);
			} else {
				onContinueRestartAfterEnding(null);
			}
		}
		
		protected function onMakeLogin(event:Event):void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += 1000;
			player.nrMPCoins += 500;
			player.saveQueued();
			navigateToURL(new URLRequest("/cadastroFTM&redirect=ftm"), "_self");
		}
				
		private function onContinueRestartAfterEnding(event:Event):void {
			if(createLoginScreen!=null) { removeChild(createLoginScreen); }
			
			removeChild(startScreen);
			if(playScreen!=null && contains(playScreen)) { removeChild(playScreen); }
			if(endScreen!=null && contains(endScreen)) { removeChild(endScreen); }
			addChild(startScreen);
			startScreen.usernameInfo["levelBar"].setPlayerLevel();
			
			//Retorna do último estilo de jogo escolhido
			if(estiloJogado=="SP") {
				startScreen.onContinueSinglePlay(null);
			} else if(estiloJogado=="MP") {
				startScreen.onContinueMultiPlay(null);
			}
			
			//Checa se enche o saco do cara com PopUp da lojinha
			startScreen.popUpRoulette(this); 
		}
				
		protected function onQuitGame(event:Event):void {
			dispatchEvent(new Event(NavigationEvent.QUITGAME)); //NavigationEvent.QUITGAME == "quitgame"
		}
		
		public static function rankingInput(points:Number):void {
			var player:MyPlayer = Player.current as MyPlayer;
			var playerSupername:String = player.username+"###"+player.email;
			
			//Põe a partida no leaderboard
			Flox.loadScores("rankingsemanal", TimeScope.THIS_WEEK, 
				function(scores:Array):void {
					for each(var score:Object in scores) {
						if(score.playerName == playerSupername) {
							Flox.postScore("rankingsemanal", score.value+points, playerSupername);
							break;
						}
					}
					//Se chegar aqui é porque ainda não tinha score do player
					Flox.postScore("rankingsemanal", points, playerSupername);
				}, function onError(error:String):void { trace(error);}
			);
		}
		
		public static function _(id:String):String {
			var retorno:String = "";
			retorno = GetText.translate(id);
			if(retorno!=null) {
				return retorno;			
			} else {
				return "no-translation";
			}
		}
	}
}
