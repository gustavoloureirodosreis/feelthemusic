package multiplayer  {
	
	import auxiliares.NavigationEvent;
	import auxiliares.ParticleBalls;
	import auxiliares.PerformanceRate;
	import auxiliares.PlayScreenController;
	import auxiliares.TextBox;
	import auxiliares.TimeBar;
	import auxiliares.WordShuffler;
	
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flox_entities.GameMatch;
	import flox_entities.MyPlayer;
	
	import z_nl.base42.subtitles.SubtitleParser;
	
	
	public class MPPlayScreen extends MovieClip {
		//Variáveis de objetos já existentes no MovieClip "Main"
		public var coinSE:CoinSE = new CoinSE();
		public var yourDancer:PerformanceRate;
		public var opDancer:PerformanceRate;
		public var timeBar:TimeBar;
		public var leaveBtn:SimpleButton;
		public var skipButton:SimpleButton;
		public var pointerNameP1:MovieClip;
		public var pointerNameP2:MovieClip;
		public var pointerP1:MovieClip;
		public var pointerP2:MovieClip;
		public var videoContainer:MovieClip;
		public var endingMsg:MovieClip;
		public var grayProtection:MovieClip;
		public var glowSpotPerfect:MovieClip;
		public var glowSpotGood:MovieClip;
		public var glowSpotBad:MovieClip;
		public var glowSpotSecondary:MovieClip;
		public var perfectLine:MovieClip;
		public var goodLine:MovieClip;
		public var badLine:MovieClip;
		public var subSpace:MovieClip;
		public var youPrecisionText:MovieClip;
		public var opPrecisionText:MovieClip;
		public var yourPoints:TextField;
		public var opPoints:TextField;
		public var you:TextField;
		public var opponent:TextField;
		
		//Outras variáveis, em ordem decrescente de complexidade
		public var youtubePlayer:ChromelessPlayer;
		public var currentMatch:GameMatch;
		public var loadingScreen:LoadingScreen;
		public var currentDescentSinging:TweenMax;
		public var currentDescentFast:TweenMax;
		public var wordShuffler:WordShuffler;
		public var correctSE:CorrectSE = new CorrectSE();
		public var wrongSE:WrongSE = new WrongSE();
		public var mySound:Sound = new Sound();
		public var mySoundChannel:SoundChannel = new SoundChannel();
		public var adaptRequest:URLRequest = new URLRequest();
		public var adaptVARS:URLVariables = new URLVariables();
		public var examination:Object = new Object();
		public var vetSelec:Vector.<int> = new Vector.<int>(); //Controla que versos tem omissão ('1') ou não ('0')
		public var versosInfo:Array = new Array();
		public var versosModificados:Array = new Array();
		public var textBoxes:Array = new Array();
		public var auxExpressoesAcertadas:Array = new Array();
		public var auxExpressBem:Array = new Array();
		public var omitido:Array = new Array();
		public var temasNaPartida:Array = new Array();
		public var auxItens:Array = [0,0,0,0,0,0];
		public var ultimaOmissao:String = "";
		public var musicGlobal:String = "";
		public var youtubePlayerReady:Boolean = false;
		public var jaPosAsOpcoes:Boolean = false;
		public var loadedSubtitles:Boolean= false;
		public var podeSubirOutro:Boolean = true;
		public var naoLiberadoSelecao:Boolean = true;
		public var novaLegendaComOmissao:Boolean = true;
		public var btnCorreto:Number = 1;
		public var blankType:Number = 0;
		public var versoEmJogo:Number = 0;
		public var versoACantar:Number = 0;
		public var lastTime:Number = 0;
		public var boxNew:Number = 0;
		public var boxOld:Number = 0;
		public var contPrincipal:Number = 0;
		public var perfectCount:Number = 0;
		public var goodCount:Number = 0;
		public var badCount:Number = 0;
		public var missCount:Number = 0;
		public var contadorLog:Number = 0;
		public var posicaoLegendaAtual:Number = int.MAX_VALUE;
		public var posicaoLegendaOld:Number = int.MAX_VALUE;
		public var timeFirstVerse:Number = 0;
		public var totalPointsWithCombo:Number = 0;
		public var wBtn1:MovieClip;
		public var wBtn2:MovieClip;
		public var wBtn3:MovieClip;
		public var wordOpt:XML;
		public var _subtitles:Array;
		public var blocks:Array;
		public var currentTime:Number;
		public var ehBot:Boolean;
		
		public function MPPlayScreen(match:GameMatch) {
			//Pega o match
			currentMatch = match;
			opDancer.gotoAndStop(2);
			pointerNameP2.gotoAndStop(2); pointerP2.gotoAndStop(2);
			youPrecisionText.gotoAndStop(7); opPrecisionText.gotoAndStop(7);
			
			//Define se é partida contra bot ou não
			var player:MyPlayer = Player.current as MyPlayer;
			ehBot = true;
			if(ehBot) {
				currentMatch._senderInGameInfo = new Array();
				you.text = currentMatch._sender; 
				opponent.text = currentMatch._receiver;
			} else {
				//Fazer mudanças para quando for contra amiguinho do facebook
			}
			
			//Ajusta algumas variáveis essenciais
			this["continueBtn"].visible = false;
			wBtn1.mouseChildren = false; wBtn1.buttonMode = true; 
			wBtn2.mouseChildren = false; wBtn2.buttonMode = true;
			wBtn3.mouseChildren = false; wBtn3.buttonMode = true;
			perfectLine.gotoAndStop(1); goodLine.gotoAndStop(2); badLine.gotoAndStop(3);
			musicGlobal = currentMatch._musica;
			var myPattern:RegExp = /- /; 
			
			//Inicializa o request adaptativo
			adaptRequest.url = "http://54.207.61.203/adaptive/examination/ftm/song/";
			adaptRequest.method = URLRequestMethod.POST;
			examination.items = new Array();
			
			//Adiciona no Stage
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);	
		}
		
		protected function onAddedtoStage(event:Event):void {
			stage.focus = stage;
			loadingScreen = new LoadingScreen();
			addChild(loadingScreen);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			var subtitle:DataLoader;
			if(FeelMusic.gameLang == "en") {
				subtitle = new DataLoader("http://www.feelthemusic.com.br/FeelTheMusic/Musicas/" + encodeURIComponent(musicGlobal) + "/legenda.srt");
			} else if(FeelMusic.gameLang == "es") {
				subtitle = new DataLoader("http://www.feelthemusic.com.br/FeelTheMusic/ES_Musicas/" + encodeURIComponent(musicGlobal) + "/legenda.srt");	
			}
			subtitle.addEventListener(LoaderEvent.COMPLETE, handleSubtitleLoaded);
			subtitle.load(true);				
		}
		
		protected function handleSubtitleLoaded(event:LoaderEvent):void {
			_subtitles = SubtitleParser.parseSRT(DataLoader(event.currentTarget).content);
			loadedSubtitles = true;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
			var urlRequest:URLRequest;
			if(FeelMusic.gameLang == "en") {
				urlRequest = new URLRequest("http://www.feelthemusic.com.br/FeelTheMusic/Musicas/" + encodeURIComponent(musicGlobal) + "/legenda.xml");
			} else if(FeelMusic.gameLang == "es") {
				urlRequest = new URLRequest("http://www.feelthemusic.com.br/FeelTheMusic/ES_Musicas/" + encodeURIComponent(musicGlobal) + "/legenda.xml");	
			}
			urlLoader.load(urlRequest);
		}
		
		protected function urlLoader_complete(evt:Event):void {
			wordOpt = new XML(evt.target.data);
			
			wBtn1.addEventListener(MouseEvent.CLICK, function(){apertouBotao(1);});
			wBtn2.addEventListener(MouseEvent.CLICK, function(){apertouBotao(2);});
			wBtn3.addEventListener(MouseEvent.CLICK, function(){apertouBotao(3);});
			for(var i:int=1; i<=3; i++) {
				this["wBtn"+i].addEventListener(MouseEvent.MOUSE_OVER, onOverOption);
				this["wBtn"+i].addEventListener(MouseEvent.MOUSE_OUT, onOutOption);
			}
			
			youtubePlayer = new ChromelessPlayer();
			youtubePlayer.addEventListener(ChromelessPlayer.PLAYER_READY, onYoutubePlayerReady);
			videoContainer.addChild(youtubePlayer);		
		}
		
		protected function onYoutubePlayerReady(event:Event):void {
			youtubePlayer.removeEventListener(ChromelessPlayer.PLAYER_READY, onYoutubePlayerReady);

			//Ajusta o nome pra tocar a música certa
			for each (var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[4] == musicGlobal) {
					youtubePlayer.loadVideoById(quintuple[3]); 
					break;
				}
			}
			youtubePlayer.setPlaybackQuality("small");
			youtubePlayer.playVideo();
			youtubePlayer.addEventListener(ChromelessPlayer.VIDEO_BEGAN, setDuration);
			youtubePlayer.addEventListener(NavigationEvent.END, onEndMovie);
			youtubePlayer.addEventListener(NavigationEvent.BROKEN, onVideoBroken);
		}
		
		protected function onVideoBroken(event:Event):void {
			leaveBtn.visible = true;
			leaveBtn.addEventListener(MouseEvent.CLICK, onLeaveClick);
			setChildIndex(leaveBtn, numChildren-1);
			loadingScreen.setMusica(musicGlobal);
			loadingScreen.gotoAndStop(3);
			loadingScreen.fillText(3);
		}
		
		protected function onLeaveClick(event:MouseEvent):void {
			youtubePlayer.stopVideo();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			dispatchEvent(new NavigationEvent(NavigationEvent.ENDLEAVING));			
		}
		
		public function onOverOption(event:MouseEvent):void { event.currentTarget.gotoAndStop(2); }
		
		public function onOutOption(event:MouseEvent):void { event.currentTarget.gotoAndStop(1); }
		
		public var numLacunas:Number = 0;
		public function setDuration(e:Event){
			//Tira o listener e fala que pode começar
			youtubePlayer.removeEventListener(ChromelessPlayer.VIDEO_BEGAN, setDuration);
			youtubePlayerReady = true;
			
			removeChild(loadingScreen);
			var duration:Number = (youtubePlayer.getDuration()-youtubePlayer.getCurrentTime());
			timeBar.setTime(duration);
			
			//Monta o array de informações dos versos
			var auxArray:Array = new Array();
			var subtAnterior:String = "";
			for(var increment:Number = 0; increment < duration; increment += 0.01){
				if(SubtitleParser.getCurrentSubtitle(increment, _subtitles)!=subtAnterior){
					if(timeFirstVerse==0){
						timeFirstVerse=increment;
					}
					subtAnterior = SubtitleParser.getCurrentSubtitle(increment, _subtitles);
					numLacunas++; 
					if(SubtitleParser.getCurrentSubtitle(increment, _subtitles)!=""){
						if(auxArray.length!=0){
							auxArray.push(increment);
							versosInfo.push(auxArray);
							auxArray = new Array();
						}
						auxArray.push(SubtitleParser.getCurrentSubtitle(increment, _subtitles));
						auxArray.push(increment);	
					} else {
						auxArray.push(increment);
						if(increment-auxArray[1]<0.75){
							numLacunas--;
						}
						versosInfo.push(auxArray);
						auxArray = new Array();
					}
				}
			}
			timeBar.setBeginning(versosInfo[0][1]);
			wordShuffler = new WordShuffler(wordOpt, versosInfo);
			totalPointsWithCombo = PlayScreenController.totalPoinsWithCombo(numLacunas-1);
			
			skipButton.visible = true;
			skipButton.addEventListener(MouseEvent.CLICK, skipBeginningHandler);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function keyDown(k:KeyboardEvent){
			switch(k.keyCode) {
				case 37: //Seta pra esquerda
					apertouBotao(1); break;
				case 38: case 40: //Seta pra cima e seta pra baixo
					apertouBotao(2); break;
				case 39: //Seta pra direita
					apertouBotao(3); break;
			}
		}
		
		public var btnApertadoGlobal:Number = 4;
		private function apertouBotao(btnApertado:Number):void{
			btnApertadoGlobal = btnApertado;
			var posicaoReal:Number = posicaoLegendaAtual;
			var adaptShift:Number = 1;
			
			//A posição real só é a old se a old ainda existe na tela e não foi preenchida
			if(textBoxes[posicaoLegendaOld]!=null && contains(textBoxes[posicaoLegendaOld]) &&
				textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") != -1){ 
				posicaoReal = posicaoLegendaOld; 
				adaptShift = 2;
			}
			//Grava o verso, o tempo, que botão escolheu, e qual era o certo do player atual
			var medidorSucesso:Number = 1-((subSpace.y+subSpace.height)-textBoxes[posicaoReal].y)/(subSpace.height);
			if(medidorSucesso<0) { medidorSucesso = Math.random(); }
			var acrescimoNaPontuacao:Number = PlayScreenController.acrescimoNaPontuacao(Math.min(3.7, (numLacunas-1)/5), 1, textBoxes[posicaoReal], this["subSpace"]);	
			if(ehBot) { currentMatch._senderInGameInfo.push([posicaoReal, medidorSucesso, btnApertado, btnCorreto]);
			} else {  
				//Fazer quando com facebook 
			}
			if(btnApertado==4){ //Ou seja, se não apertou nada e acabou o tempo
				examination.items[examination.items.length-adaptShift].grade = 0;
				examination.items[examination.items.length-adaptShift].time = -1;	
				errouOpcao(false);
			}
			if(naoLiberadoSelecao == false){
				naoLiberadoSelecao = true;
				
				//Adaptativo
				examination.items[examination.items.length-adaptShift].options = [wBtn1.textoBtn.text, wBtn2.textoBtn.text, wBtn3.textoBtn.text];
				
				if(btnApertado == btnCorreto){	
					PlayScreenController.novaExpressao(this, true);
					yourDancer.refresh(1);
					correctSE.play(0,0,new SoundTransform(0.33));
					
					//Adaptativo
					examination.items[examination.items.length-adaptShift].grade = 1;
					examination.items[examination.items.length-adaptShift].time = currentTime-versosInfo[versoEmJogo-adaptShift][1];
					
					//Aumenta a pontuação do player1
					var pontuacao:Number = Number(yourPoints.text);
					var auxArray:Array = [pontuacao];
					TweenLite.to(auxArray, 0.1, {endArray:[pontuacao+acrescimoNaPontuacao], onUpdate:showCountdownYou});
					function showCountdownYou(){ yourPoints.text = Math.round(auxArray[0]).toString();}
					pontuacao += acrescimoNaPontuacao;
					
					var quantoAcertou:Number = 0;
					if(textBoxes[posicaoReal].y>goodLine.y+goodLine.height/2){
						TweenMax.to(glowSpotSecondary, 0.2, {glowFilter:{color:0x00CCFF, alpha:1, 
							blurX:30, blurY:30, strength:3, quality:2, remove:true}, onStart:glowSecondaryStart, onComplete:glowSecondaryEnd});
						quantoAcertou = 2;
						completarLetra(4);
						perfectCount++;
					} else if(textBoxes[posicaoReal].y>badLine.y+badLine.height/2){
						TweenMax.to(glowSpotPerfect, 0.2, {glowFilter:{color:0x00FF33, alpha:1, blurX:30,
							blurY:30, strength:3, quality:2, remove:true}, onStart:glowPerfectStart, onComplete:glowPerfectEnd});
						quantoAcertou = 3;
						completarLetra(3);
						goodCount++;
					} else {
						TweenMax.to(glowSpotGood, 0.2, {glowFilter:{color:0xFCFD03, alpha:1, blurX:30, blurY:30, 
							strength:3, quality:2, remove:true}, onStart:glowGoodStart, onComplete:glowGoodEnd});
						quantoAcertou = 4;
						completarLetra(2);
						badCount++;
					}
					this.youPrecisionText.textoBtn.text = Number(acrescimoNaPontuacao).toString();
					posApertarBotao(quantoAcertou);
				} else if(btnApertado!=4) {
					//Adaptativo
					examination.items[examination.items.length-adaptShift].grade = 0;
					examination.items[examination.items.length-adaptShift].time = currentTime-versosInfo[versoEmJogo-adaptShift][1];
					this.youPrecisionText.textoBtn.text = "X";
					missCount++;
					errouOpcao(true);
				}
				if(textBoxes[posicaoReal]!=null) { 
					youPrecisionText.x = textBoxes[posicaoReal].x; youPrecisionText.y = textBoxes[posicaoReal].y + 25;
				} else {youPrecisionText.x = 480; youPrecisionText.y = 0;}
				TweenLite.to(youPrecisionText, 0.5, {alpha: 1, x:yourPoints.x+40, y:yourPoints.y+70});
			
				if(ehBot) {
					var difficulty:Number = Number(currentMatch._betType)/100;
					var rand1:Number = Math.random();
					
					//Checa quão provavelmente o bot acerta apesar do seu erro, e quão melhor/pior ele vai
					var botReaction:Array = botReactionIntelligence(difficulty, medidorSucesso);
					if(btnApertado==btnCorreto || botReaction[0]) {
						opDancer.refresh(1);
						var pontuacaoOp:Number = Number(opPoints.text);
						var auxArrayOp:Array = [pontuacaoOp];
						medidorSucesso = botReaction[1];
						acrescimoNaPontuacao = Math.round((1+Math.min(3.7, (numLacunas-1)/5))*Math.ceil(Math.exp(3+2.5*medidorSucesso)));
						TweenLite.to(auxArrayOp, 0.1, {endArray:[pontuacaoOp+acrescimoNaPontuacao], 
						onUpdate:showCountdownOp, onComplete:showNewGlow});
						function showCountdownOp(){ opPoints.text = Math.round(auxArrayOp[0]).toString();}
						function showNewGlow(){
							//Atualiza brilho de quem tá ganhando
							if(Number(yourPoints.text)>Number(opPoints.text)) {
								TweenLite.to(yourPoints, 0.3, {glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:7}});
								TweenLite.to(you, 0.3, {glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:7}});
								TweenLite.to(opPoints, 0.3, {glowFilter:{remove:true}}); 
								TweenLite.to(opponent, 0.3, {glowFilter:{remove:true}});
							} else if(Number(yourPoints.text)<Number(opPoints.text)) { 
								TweenLite.to(opPoints, 0.3, {glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:7}}); 
								TweenLite.to(opponent, 0.3, {glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:7}}); 
								TweenLite.to(yourPoints, 0.3, {glowFilter:{remove:true}}); 
								TweenLite.to(you, 0.3, {glowFilter:{remove:true}});
							}	
						}
						pontuacaoOp += acrescimoNaPontuacao;
						opPrecisionText.textoBtn.text = acrescimoNaPontuacao.toString();
					} else {
						opPrecisionText.textoBtn.text = "x";
						opDancer.refresh(-1);
					}
					if(textBoxes[posicaoReal]!=null) { 
						opPrecisionText.x = textBoxes[posicaoReal].x; opPrecisionText.y = textBoxes[posicaoReal].y + 25;
					} else {opPrecisionText.x = 480; opPrecisionText.y = 0;}
					TweenLite.to(opPrecisionText, 0.5, {alpha: 1, x:opPoints.x+40, y:opPoints.y+70});
				} else {
					//Fazer quando tiver facebook
				}
			}
		}
		
		//'difficulty's possíveis: 0.05, 0.1, 0.25, 0.5, 1
		public var invincibility:Boolean = (Math.random() < 0.16);
		private function botReactionIntelligence(difficulty:Number, medidorSucesso:Number):Array {
			var result:Array = new Array();
			
			//Calcula chance do bot acertar mesmo quando o cara errou
			var botAcertou:Boolean = false;
			if(btnCorreto!=btnApertadoGlobal) {
				if(Math.random() < difficulty*3) {
					botAcertou = true;
				}
			} else {
				botAcertou = true;
			}
			
			//O bot faz uma pontuação tão mais forte quanto a dificuldade em questão
			var botSucesso:Number = 0;
			var auxDiff:Number = Math.pow(difficulty,1/3)-0.1;
			if(!invincibility) {
				botSucesso = (Math.random()*(1.2-auxDiff) + auxDiff)*medidorSucesso;
			} else {
				botSucesso = Math.min(Math.random()*(1.2-auxDiff) + auxDiff, 0.9);
			}
			result.push(botAcertou, botSucesso);
			return result;
		}
		
		public function errouOpcao(erroNormal:Boolean):void {
			PlayScreenController.novaExpressao(this, false);
			if(erroNormal) {completarLetra(1);} else {completarLetra(5);}
			this.youPrecisionText.textoBtn.text = "X";
			yourDancer.refresh(-1);
			wrongSE.play(0,0,new SoundTransform(0.2));
			posApertarBotao(6);
		}
				
		public function posApertarBotao(acertou:Number):void {			
			limpaBotoesDeOpcao();
		}
		
		public function glowPerfectStart():void{ glowSpotPerfect.visible = true; glowSpotPerfect.gotoAndStop(2); }
		
		public function glowSecondaryStart():void{ glowSpotSecondary.visible = true; }
		
		public function glowSecondaryEnd():void{ glowSpotSecondary.visible = false; }
		
		public function glowPerfectEnd():void{ glowSpotPerfect.visible = false; }
		
		public function glowGoodStart():void{ glowSpotGood.visible = true; glowSpotGood.gotoAndStop(3);}
		
		public function glowGoodEnd():void{	glowSpotGood.visible = false; }
				
		private function onEnterFrame(event:Event):void{
			if(youtubePlayer!=null && youtubePlayerReady){
				currentTime = youtubePlayer.getCurrentTime();
				
				//Atualiza a timeBar
				timeBar.refreshMP(currentTime, yourPoints.text, opPoints.text, pointerP1, pointerP2);
				
				if(lastTime != currentTime){					
					lastTime = currentTime;
					onEachFrame();			
				}			
			}
		}	
		
		private function onEachFrame():void {
			var actualSub:String;
			var formato:TextFormat;
			
			if(skipButton.visible && currentTime+0.1>=timeFirstVerse && boxOld<versosInfo.length){
				skipButton.visible = false;
				skipButton.removeEventListener(MouseEvent.CLICK, skipBeginningHandler);
			}
			
			if(loadedSubtitles == true){	
				for each(var trio:Array in versosInfo){
					if(versosInfo.indexOf(trio)>=versoEmJogo && currentTime>=trio[1]){
						textBoxes[boxNew] = new TextBox();
						textBoxes[boxNew].textoBox.text = versosInfo[versoEmJogo][0];	
						vetSelec[boxNew] = 0;
						if(versosInfo[versoEmJogo+1]!= null &&
						   versosInfo[versoEmJogo+1][2]-versosInfo[versoEmJogo+1][1]>1){
							examination.items.push(new Object());
							vetSelec[boxNew] = 1;
							textBoxes[boxNew].textoBox.text = PlayScreenController.criaNovaLegendaModificada(this, blocks);
						} else {
							versosModificados.push(textBoxes[boxNew].textoBox);
						}
						textBoxes[boxNew].y = this["subSpace"].y + this["subSpace"].height-textBoxes[boxNew].height/3;
						textBoxes[boxNew].x = this["subSpace"].x + this["subSpace"].width/2;
						addChild(textBoxes[boxNew]);
						setChildIndex(textBoxes[boxNew], getChildIndex(wBtn1)-1);
						stage.focus = stage; //Garante que vai funcionar pelo teclado
						boxNew++;
						versoEmJogo++;	
					}
				}
				analisaLegenda();			
				sobeLegenda();
				removeMensagem();
			}			
		}
		
		private function analisaLegenda():void {
			//Vê se pode botar opções nos botões
			if(posicaoLegendaAtual!=int.MAX_VALUE && !jaPosAsOpcoes &&
				(posicaoLegendaOld==int.MAX_VALUE ||
				(textBoxes[posicaoLegendaOld]!=null && 
				!contains(textBoxes[posicaoLegendaOld]) ||
				textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") == -1))) {
				//Existe um botão correto fixo se for o retorno
				if(ehBot) { btnCorreto = Math.ceil(Math.random()*3); }
				else {
					//Fazer quando tiver Facebook
				}
				this["blackBtn"].visible = false;
				escreveOpcoes();					
				jaPosAsOpcoes = true;
				naoLiberadoSelecao = false;
			}	
		}
		
		private function sobeLegenda():void {
			if(textBoxes[versoACantar]!=null){
				for each(var trio:Array in versosInfo){
					if(podeSubirOutro && versosInfo.indexOf(trio)>=versoACantar && currentTime>=trio[1]){
						currentDescentSinging = TweenMax.to(textBoxes[versoACantar], trio[2]-currentTime, 
						{y:badLine.y+badLine.height/2, onComplete:onJaCantouVerso, ease:Linear.easeNone});
						versoACantar++;
						podeSubirOutro = false;
					}
				}
			}
		}
		
		public function onJaCantouVerso():void{
			currentDescentFast = TweenMax.to(textBoxes[versoACantar-1], 1.25, {alpha:0, y:badLine.y - 50});		
			podeSubirOutro = true;
		}
		
		private function removeMensagem():void{
			for(contPrincipal = boxOld; contPrincipal < boxNew; contPrincipal++) {
				if(textBoxes[contPrincipal].y <= badLine.y - 49) {
					if(contains(textBoxes[contPrincipal])) { 
						if((contPrincipal == posicaoLegendaAtual || contPrincipal == posicaoLegendaOld) &&
							textBoxes[contPrincipal].textoBox.text.indexOf("_____") >= 0) { 
							apertouBotao(4); //Errou porque moscou
						}
						removeChild(textBoxes[contPrincipal]); 
					}
					boxOld++;
					if(boxOld==versosInfo.length){
						skipButton.visible = true;
						skipButton.addEventListener(MouseEvent.CLICK, skipHandler);
					}				
					if(contPrincipal >= posicaoLegendaAtual) { novaLegendaComOmissao = true; }
				}
			}
		}
		
		private function limpaBotoesDeOpcao():void{			
			this["wBtn1"].textoBtn.text = ""; this["wBtn2"].textoBtn.text = "";
			this["wBtn3"].textoBtn.text = "";
			this["blackBtn"].visible = true;
		}
		
		private function escreveOpcoes():void{
			var optionsArray:Array = wordShuffler.makeThreeOptions(textBoxes[posicaoLegendaAtual].textoBox.text, omitido[posicaoLegendaAtual]);
			btnCorreto = optionsArray[1];
			blankType = optionsArray[2];
			for(var i:int=1; i<=3; i++) {
				this['wBtn'+i].textoBtn.text = optionsArray[0][i-1];			
			}
		}	
		
		public var colorGlobal:Number = 0x000000;
		private function completarLetra(rst:Number):void { 
			var counterPosLacuna:Number;
			var formato:TextFormat;
			var compArray:Array = new Array();
			var posicVersoAcompletar:int = vetSelec.length-1;
			
			while(vetSelec[posicVersoAcompletar]!=1) { posicVersoAcompletar--; }
			if(textBoxes[posicaoLegendaOld]!=null && contains(textBoxes[posicaoLegendaOld]) &&
				textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") != -1) { posicVersoAcompletar--; }
			compArray = textBoxes[posicVersoAcompletar].textoBox.text.split(/ /g);
			
			if(rst!=5) { //Ou  seja, se faz sentido mostrar o erro ainda
				for(counterPosLacuna=0; 
					compArray[counterPosLacuna]!="" && compArray[counterPosLacuna]!="\0" && compArray[counterPosLacuna]!=null && compArray[counterPosLacuna]!= "_____";
					counterPosLacuna++) {}
				compArray[counterPosLacuna]=this['wBtn'+btnCorreto].textoBtn.text.toUpperCase();
				textBoxes[posicVersoAcompletar].textoBox.text=compArray.join(" ");
				formato = textBoxes[posicVersoAcompletar].textoBox.getTextFormat();
				if(rst==4){ formato.color = 0x00CDCD; //Perfect
				} else if(rst==3){ formato.color = 0x55FF55; //Good
				} else if(rst==2) { formato.color = 0xFFFF00; //Bad
				} else if (rst==1) { formato.color = 0xFF0000; //Miss
				}
				colorGlobal = Number(formato.color);
				
				//Mostra brilho na frase
				PlayScreenController.showParticlesAround(this, textBoxes[posicVersoAcompletar], colorGlobal);
			}
			
			//Grava verso em versosModificados
			versosModificados.push(textBoxes[posicVersoAcompletar].textoBox);
		}
			
		public function skipBeginningHandler(navigationEvent:MouseEvent):void {
			skipButton.removeEventListener(MouseEvent.CLICK, skipBeginningHandler);
			currentTime = versosInfo[0][1];
			if(currentTime - 1 > 0) { currentTime--; }
			youtubePlayer.pauseVideo();
			youtubePlayer.skipTo(currentTime);
			youtubePlayer.playVideo();
		}
				
		public function skipHandler(navigationEvent:MouseEvent):void{
			onEndMovie(null);
		}
		
		public function onEndMovie(navigationEvent:NavigationEvent):void {
			//Envia o adaptativo
			adaptRequest.data = examination;
			var loader:URLLoader = new URLLoader();
			loader.load(adaptRequest);
			
			//Fecha a musica
			skipButton.visible = false;
			youtubePlayer.stopVideo();
			onMPending();
		}
		
		private function onMPending():void {
			grayProtection.visible = true;
			this["continueBtn"].alpha = 0;
			//Toca som de fim
			var mySound:Sound = new BringStuffSFX();
			mySound.play(0, 0, null);
			if(ehBot) {
				TweenLite.to(opponent, 0.5, {y:opPoints.y - 35, ease:Cubic.easeOut});
				//Mostrar vencedor/perdedor:
				var currentFrame:Number = 1;
				if(Number(yourPoints.text)>=Number(opPoints.text)) {
					showCoinsEndingYou();
				} else if(Number(yourPoints.text)<Number(opPoints.text)) {
					showCoinsEndingOp();
				}
			} else {
				//Fazer quando tiver Facebook
			}
		}
		
		private function showCoinsEndingYou():void {
			currentMatch._winner = currentMatch._receiver;
						
			var mySound:Sound = new EndStuffSFX();
			mySound.play();
			endingMsg["mpEndingTxt"].text = FeelMusic._("mpEndingTxtWin");
			TweenLite.to(endingMsg, 0.5, {y:50, ease:Back.easeIn, onComplete:moreCoins});
			function moreCoins():void{
				var player:MyPlayer = Player.current as MyPlayer;
				player.nrMPCoins += Number(currentMatch._betType)*2;
								
				player.saveQueued();
				var numberAux:Object = {value: 99};
				TweenLite.to(numberAux,  0.5, {value:Number(currentMatch._betType)*2, onUpdate:showScore, onComplete:showEndingContinue})			
				function showScore(){
					endingMsg["coinsTxt"].text = Math.round(numberAux.value).toString();
					coinSE.play(0,0,new SoundTransform(0.5));
				}
			}
		}
		
		public function getFinalScore():Number { return Number(yourPoints.text); }
		public function getPerfectScore():Number { return perfectCount; }
		public function getGoodScore():Number { return goodCount; }
		public function getBadScore():Number { return badCount; }
		public function getMissScore():Number { return missCount; }
		public function getComboScore():Number { return 0; }
		public function getAccuracy():Number { return (5*perfectCount+4*goodCount+3*badCount)/(5*(numLacunas-1)); }
		public function getNewTime():Number { return youtubePlayer.getDuration(); }
		public function getNewExpressions():Array { return auxExpressoesAcertadas; }
		public function getNewAuxExpressions():Array { return auxExpressBem; }
		public function getVersosModificados():Array { return versosModificados; }
		public function getNewItens():Array { return auxItens; }
		public function getTemasAbordados():Array { return temasNaPartida; }
		
		private function showCoinsEndingOp():void {
			currentMatch._winner = currentMatch._sender;
						
			var mySound:Sound = new EndStuffSFX();
			mySound.play();
			endingMsg["mpEndingTxt"].text = FeelMusic._("mpEndingTxtLose");
			TweenLite.to(endingMsg, 0.5, {y:50, ease:Back.easeIn, onComplete:noCoins});
			function noCoins():void{
				showEndingContinue();
			}
		}
		
		protected function showEndingContinue():void {
			TweenLite.to(endingMsg, 0.5, {y:50, ease:Back.easeIn});
			this["continueBtn"].visible = true;
			TweenLite.to(this["continueBtn"], 1, {alpha:1});
			if(ehBot) {
				this["continueBtn"].addEventListener(MouseEvent.CLICK, onSendGameVolta); 
			} else { 
				//Fazer quando tiver Facebook
			}
		}
		
		protected function onSendGameIda(event:MouseEvent):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			dispatchEvent(new NavigationEvent(NavigationEvent.END));			
		}
		
		protected function onSendGameVolta(event:MouseEvent):void {
			if(!ehBot) { currentMatch._jaJogouRecEJaViuSender = "truefalse"; }
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			dispatchEvent(new NavigationEvent(NavigationEvent.END));	
		}
	}
	
}