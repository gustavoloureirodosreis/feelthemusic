package{
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.mixpanel.Mixpanel;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
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
	
	import auxiliares.IntroSongMasterScreen;
	import auxiliares.NavigationEvent;
	import auxiliares.ParticleBalls;
	import auxiliares.PerformanceRate;
	import auxiliares.PlayScreenController;
	import auxiliares.ProgressRate;
	import auxiliares.Settings;
	import auxiliares.TextBox;
	import auxiliares.TimeBar;
	import auxiliares.WordShuffler;
	
	import enums.MP_EVT;
	
	import fl.motion.Color;
	
	import flox_entities.MyPlayer;
	
	import z_nl.base42.subtitles.SubtitleParser;
	
	public class PlayScreen extends Sprite {
		//Variáveis de objetos já existentes no MovieClip "Main"
		public var timeBar:TimeBar;
		public var performanceRate:PerformanceRate;
		public var progressBar:ProgressRate;
		public var leaveBtn:SimpleButton;
		public var botaoDobrarCombo:SimpleButton;
		public var skipButton:SimpleButton;
		public var comboBar:MovieClip;
		public var logMovimentado:MovieClip;
		public var glowSpotPerfect:MovieClip;
		public var glowSpotGood:MovieClip;
		public var glowSpotBad:MovieClip;
		public var glowSpotSecondary:MovieClip;
		public var perfectLine:MovieClip;
		public var goodLine:MovieClip;
		public var badLine:MovieClip;
		public var subSpace:MovieClip;
		public var precisionText:MovieClip;
		public var videoContainer:MovieClip;
		public var scorePoints:TextField;
		public var comboText:TextField;
		public var feedbackMsg:TextField;
		
		//Outras variáveis, em ordem decrescente de complexidade
		public var correctSE:CorrectSE = new CorrectSE();
		public var wrongSE:WrongSE = new WrongSE();
		public var mySoundChannel:SoundChannel = new SoundChannel();
		public var adaptRequest:URLRequest = new URLRequest();
		public var adaptVARS:URLVariables = new URLVariables();
		public var examination:Object = new Object();
		public var wordShuffler:WordShuffler;
		public var loadingScreen:LoadingScreen;
		public var currentDescentSinging:TweenMax;
		public var currentDescentFast:TweenMax;
		public var mySound:Sound = new Sound();
		public var vetSelec:Vector.<int> = new Vector.<int>(); //Controla que versos tem omissão ('1') ou não ('0')
		public var versosModificados:Array = new Array();
		public var versosInfo:Array = new Array();
		public var textBoxes:Array = new Array();
		public var omitido:Array = new Array();
		public var auxExpressoesAcertadas:Array = new Array();
		public var auxExpressBem:Array = new Array();
		public var temasNaPartida:Array = new Array();
		public var auxItens:Array = [0,0,0,0,0,0];
		public var ultimaOmissao:String = "";
		public var musicGlobal:String = "";
		public var jaPosAsOpcoes:Boolean = false;
		public var loadedSubtitles:Boolean= false;
		public var jaDobrouCombo:Boolean = false;
		public var youtubePlayerReady:Boolean = false;
		public var podeSubirOutro:Boolean = true;
		public var naoLiberadoSelecao:Boolean = true;
		public var novaLegendaComOmissao:Boolean = true;
		public var lastCombo:Number = int.MAX_VALUE;
		public var btnCorreto:Number = 1;
		public var combo:Number = 1;
		public var blankType:Number = 0;
		public var versoEmJogo:Number = 0;
		public var versoACantar:Number = 0;
		public var pontuacao:Number = 0;
		public var lastTime:Number = 0;
		public var boxNew:Number = 0;
		public var boxOld:Number = 0;
		public var contPrincipal:Number = 0;
		public var perfectCount:Number = 0;
		public var goodCount:Number = 0;
		public var badCount:Number = 0;
		public var missCount:Number = 0;
		public var maxCombo:Number = 0;
		public var contadorLog:Number = 0;
		public var posicaoLegendaAtual:Number = int.MAX_VALUE;
		public var posicaoLegendaOld:Number = int.MAX_VALUE;
		public var timeFirstVerse:Number = 0;
		public var totalPointsWithCombo:Number = 0;
		public var youtubePlayer:ChromelessPlayer;
		public var wBtn1:MovieClip;
		public var wBtn2:MovieClip;
		public var wBtn3:MovieClip;
		public var wordOpt:XML;
		public var _subtitles:Array;
		public var blocks:Array;
		public var currentTime:Number;
		
		// Mixpanel
		private var mixpanel:Mixpanel;
		
		public function PlayScreen(musica:String) {
			//Inicia Mixpanel e player
			mixpanel = Settings.getInstance().mixpanel;
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Ajusta algumas variáveis essenciais
			wBtn1.mouseChildren = false; wBtn1.buttonMode = true; 
			wBtn2.mouseChildren = false; wBtn2.buttonMode = true;
			wBtn3.mouseChildren = false; wBtn3.buttonMode = true;
			for(var i:int=1; i<=7; i++) {  TweenMax.to(this["log"+i], 0.3, {y:this["log"+i].y-3.3, repeat:-1, yoyo:true}); }
			comboBar["bar"].gotoAndStop(2);
			perfectLine.gotoAndStop(1); 
			goodLine.gotoAndStop(2); 
			badLine.gotoAndStop(3);
			musicGlobal = musica;
			this["nomeDaMusica"].text = musica;
			
			//Inicializa o request adaptativo
			var musicID:String = PlayScreenController.getMusicId(musica);
			adaptRequest.url = "http://54.207.61.203/adaptive/examination/ftm/song/"+musicID+"/";
			adaptRequest.method = URLRequestMethod.POST;
			adaptVARS.user = player.email;
			examination.items = new Array();
			
			//Adiciona no Stage
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedtoStage);		
		}
		
		private function onAddedtoStage(event:Event):void{
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
		
		private function handleSubtitleLoaded(event:Event):void {
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
		
		private function urlLoader_complete(evt:Event):void{
			wordOpt = new XML(evt.target.data);
			wBtn1.addEventListener(MouseEvent.CLICK, function(){apertouBotao(1);});
			wBtn2.addEventListener(MouseEvent.CLICK, function(){apertouBotao(2);});
			wBtn3.addEventListener(MouseEvent.CLICK, function(){apertouBotao(3);});
			for(var i:int=1; i<=3; i++) {
				this["wBtn"+i].addEventListener(MouseEvent.MOUSE_OVER, onOverOption);
				this["wBtn"+i].addEventListener(MouseEvent.MOUSE_OUT, onOutOption);
			}
			leaveBtn.addEventListener(MouseEvent.CLICK, onLeaveClick);
			
			youtubePlayer = new ChromelessPlayer();
			youtubePlayer.addEventListener(ChromelessPlayer.PLAYER_READY, onYoutubePlayerReady);
			videoContainer.addChild(youtubePlayer); 
			
			mixpanel.track(MP_EVT.COMECOU_MUSICA, {
				'Artista': musicGlobal.split('-')[0],
				'Musica': musicGlobal.split('-')[1]
			});
		}
		
		protected function onYoutubePlayerReady(event:Event):void {
			//Ajusta o nome pra tocar a música certa
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
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
			setChildIndex(leaveBtn, numChildren-1);
			loadingScreen.setMusica(musicGlobal);
			loadingScreen.gotoAndStop(3);
			loadingScreen.fillText(3);
		}
		
		public function onOverOption(event:MouseEvent):void { event.currentTarget.gotoAndStop(2); }
		
		public function onOutOption(event:MouseEvent):void { event.currentTarget.gotoAndStop(1); }
		
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
			var numLacunas:Number = 0;
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
			//Divide por dois porque a contagem tá contando inicio e fim do verso (02/07/2015)
			progressBar.totalLacunas = numLacunas/2-1;
			totalPointsWithCombo = PlayScreenController.totalPoinsWithCombo(progressBar.totalLacunas);
			timeBar.setBeginning(versosInfo[0][1]);
			wordShuffler = new WordShuffler(wordOpt, versosInfo);
			
			//Aqui checa se é treino especial ou não
			if(FeelMusic.masterSongId!=null) {
				//Pausa a música
				togglePauseVideo();
				
				//Prepara o dicionário de palavras da música e as palavras mestradas
				PlayScreenController.setSongWords(versosInfo);
				PlayScreenController.preparaMasteredWords(PlayScreenController.setouMasteredWords);
				
				//Coloca a IntroSong no stage
				var introSongMasterScreen:IntroSongMasterScreen = new IntroSongMasterScreen();
				introSongMasterScreen.setMusicName(musicGlobal);
				this.addChild(introSongMasterScreen);
				
				//Coloca listener nela para ela sumir quando clicada em 'play'
				introSongMasterScreen.addEventListener(Event.REMOVED_FROM_STAGE, onContinuePlayScreen);
			}
			
			skipButton.visible = true;
			skipButton.addEventListener(MouseEvent.CLICK, skipBeginningHandler);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onContinuePlayScreen(event:Event):void {
			togglePauseVideo();
		}
		
		public function keyDown(k:KeyboardEvent){
			switch(k.keyCode) {
				case 37: //Seta pra esquerda
					apertouBotao(1); break;
				case 38: case 40: //Seta pra cima e seta pra baixo
					apertouBotao(2); break;
				case 39: //Seta pra direita
					apertouBotao(3); break;
				case 13: //Enter
					if(!jaDobrouCombo) { dobraCombo(null);	} break;
				case 32: //Espaço
					togglePauseVideo(); break;
			}
		}
		
		public var togglePause:int = 0;
		public function togglePauseVideo():void {
			if(FeelMusic.tipoUsuario!="4" || FeelMusic.masterSongId!=null) { //Ou seja, se não é aluno ou se estamos treinando uma música pra master
				if(togglePause%2==0) {
					if(currentDescentSinging!=null && TweenMax.isTweening(textBoxes[versoACantar-1])){ currentDescentSinging.pause();}
					if(currentDescentFast!=null && TweenMax.isTweening(textBoxes[versoACantar-2])){ currentDescentFast.pause();}                    
					youtubePlayer.pauseVideo();
				} else if(togglePause%2==1) {
					if(currentDescentSinging!=null && currentDescentSinging.paused()){ currentDescentSinging.play();}
					if(currentDescentFast!=null && currentDescentFast.paused()){ currentDescentFast.play();}
					youtubePlayer.playVideo();
				}
				togglePause++;
			}
		}
		
		//Controla a resposta ao clique do efeito especial
		private function dobraCombo(event:MouseEvent):void{
			var explosionSFX:ExplosionSFX = new ExplosionSFX();
			explosionSFX.play(0,0,new SoundTransform(0.8));
			jaDobrouCombo = true;
			this["botaoDobrarCombo"].removeEventListener(MouseEvent.CLICK, dobraCombo);					
			combo = Number(comboText.text.substr(1,int.MAX_VALUE))*6;
			comboText.text = "x"+[Math.ceil(combo/3)].toString();
			if(combo > 15) {
				TweenLite.to(comboBar["bar"], 0.5, {x:0});
			} else {
				TweenLite.to(comboBar["bar"], 0.5, {x:-comboBar["bar"].width});	
			}
			botaoDobrarCombo.alpha = 0.2;						
		}
		
		public function onLeaveClick(navigationEvent:MouseEvent):void {
			youtubePlayer.stopVideo();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			dispatchEvent(new NavigationEvent(NavigationEvent.ENDLEAVING));
		}
		
		public var btnApertadoGlobal:Number = 4;
		public var posicaoReal:Number = 0;
		private function apertouBotao(btnApertado:Number):void{
			var adaptShift:Number = 1;
			btnApertadoGlobal = btnApertado;
			posicaoReal = posicaoLegendaAtual;
			
			//A posição real só é a old se ela ainda existe na tela e não foi preenchida
			if(textBoxes[posicaoLegendaOld]!=null && contains(textBoxes[posicaoLegendaOld]) &&
			   textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") != -1){ 
				posicaoReal = posicaoLegendaOld;
				adaptShift = 2;
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
					if(combo < 15) {
						combo++;
						TweenLite.to(comboBar["bar"], 0.5, {x:-comboBar["bar"].width + comboBar["bar"].width/3*((combo-1)%3)});
						if(combo > 1 && (combo-1)%3==0) {
							TweenLite.to(comboBar["bar"], 0.5, {x:0, onComplete:returnComboBar});
						}
						function returnComboBar():void { TweenLite.to(comboBar["bar"], 0.5, {delay:0.5, x:-comboBar["bar"].width}); }
					} else { TweenLite.to(comboBar["bar"], 0.5, {x:0}); }
					correctSE.play(0,0,new SoundTransform(0.33));
					
					//Adaptativo
					examination.items[examination.items.length-adaptShift].grade = 1;
					examination.items[examination.items.length-adaptShift].time = currentTime-versosInfo[versoEmJogo-adaptShift][1];
					
					var pointsIncrease:Number = PlayScreenController.acrescimoNaPontuacao(Math.floor(combo/3), 1, textBoxes[posicaoReal], this["subSpace"]);
					var auxArray:Array = [pontuacao];
					TweenLite.to(auxArray, 0.33, {endArray:[pontuacao+pointsIncrease], onUpdate:showCountdown});
					function showCountdown(){ scorePoints.text = Math.round(auxArray[0]).toString();}
					pontuacao += pointsIncrease;
					
					var quantoAcertou:Number = 0;
					if(textBoxes[posicaoReal].y>goodLine.y+goodLine.height/2){
						TweenMax.to(glowSpotSecondary, 0.2, {glowFilter:{color:0x00CCFF, alpha:1, 
						blurX:30, blurY:30, strength:3, quality:2, remove:true}, onStart:glowSecondaryStart, onComplete:glowSecondaryEnd});
						this.precisionText.gotoAndStop(2);
						quantoAcertou = 2;
						completarLetra(4);
						perfectCount++;
					} else if(textBoxes[posicaoReal].y>badLine.y+badLine.height/2){
						TweenMax.to(glowSpotPerfect, 0.2, {glowFilter:{color:0x00FF33, alpha:1, blurX:30,
						blurY:30, strength:3, quality:2, remove:true}, onStart:glowPerfectStart, onComplete:glowPerfectEnd});
						this.precisionText.gotoAndStop(3);
						quantoAcertou = 3;
						completarLetra(3);
						goodCount++;
					} else {
						TweenMax.to(glowSpotGood, 0.2, {glowFilter:{color:0xFCFD03, alpha:1, blurX:30, blurY:30, 
						strength:3, quality:2, remove:true}, onStart:glowGoodStart, onComplete:glowGoodEnd});
						this.precisionText.gotoAndStop(4);
						quantoAcertou = 4;
						completarLetra(2);
						badCount++;
					}
					this.precisionText.textoBtn.text = Number(pointsIncrease).toString();
					var accuracy:Number = (5*perfectCount+4*goodCount+3*badCount+pontuacao)/(5*(progressBar.totalLacunas)+totalPointsWithCombo);
					progressBar.refresh(accuracy); 
					performanceRate.refresh(1);
					posApertarBotao(quantoAcertou);
				} else if(btnApertado!=4) {
					//Adaptativo
					examination.items[examination.items.length-adaptShift].grade = 0;
					examination.items[examination.items.length-adaptShift].time = currentTime-versosInfo[versoEmJogo-adaptShift][1];
					errouOpcao(true);
				}
				logMovimentado.x = 480;
				logMovimentado.y = textBoxes[posicaoReal].y;	
				logMovimentado.alpha = 1;			
				if(textBoxes[posicaoReal]!=null) { 
					precisionText.x = textBoxes[posicaoReal].x; precisionText.y = textBoxes[posicaoReal].y + 25;
				} else {precisionText.x = 480; precisionText.y = 0;}
				TweenLite.to(precisionText, 0.5, {alpha:0.5, x:50, y:scorePoints.y, onComplete:restorePrecisionText});
			}
		}
		
		public function errouOpcao(erroNormal:Boolean):void {
			PlayScreenController.novaExpressao(this, false);
			if(erroNormal) {completarLetra(1);} 
			else {completarLetra(5);}
			combo = 1;
			comboText.text = "x1";
			TweenLite.to(comboBar["bar"], 0.5, {x:-180});
			this.precisionText.gotoAndStop(6);
			this.precisionText.textoBtn.text = "X";
			missCount++;
			performanceRate.refresh(-1);
			wrongSE.play(0,0,new SoundTransform(0.2));
			posApertarBotao(6);
		}
				
		public function posApertarBotao(acertou:Number):void {
			if(combo > maxCombo){ maxCombo = combo; }
			
			if(this["wBtn"+btnCorreto].textoBtn.text!=""){
				contadorLog++;
				logMovimentado.alpha = 1;
				logMovimentado.gotoAndStop(acertou);
				logMovimentado.textoBtn.text = this["wBtn"+btnCorreto].textoBtn.text;
				TweenLite.to(logMovimentado, 0.5, {x:770, y:75, alpha:0.5, onComplete:logMotion(acertou)});
			}	
			limpaBotoesDeOpcao();
			comboDisplay();
		}
		
		public function logMotion(acertou:Number):void{							
			if(contadorLog>=1 && contadorLog<=7) {
				this["log"+contadorLog].visible = true;	
			}
			for(var i:int=7; i>1; i--) {
				this["log"+i].gotoAndStop(this["log"+(i-1)].currentFrame);
				this["log"+i].textoBtn.text = this["log"+(i-1)].textoBtn.text;
			}
			this["log1"].gotoAndStop(acertou);
			this["log1"].textoBtn.text = this["wBtn"+btnCorreto].textoBtn.text;
		}
				
		public function glowPerfectStart():void{ glowSpotPerfect.visible = true; glowSpotPerfect.gotoAndStop(2); }
		
		public function glowSecondaryStart():void{ glowSpotSecondary.visible = true; }
		
		public function glowSecondaryEnd():void{ glowSpotSecondary.visible = false; }
		
		public function glowPerfectEnd():void{ glowSpotPerfect.visible = false; }
		
		public function glowGoodStart():void{ glowSpotGood.visible = true; glowSpotGood.gotoAndStop(3);}
		
		public function glowGoodEnd():void{	glowSpotGood.visible = false; }
		
		public function restorePrecisionText():void {
			precisionText.x = 480; precisionText.y = 640;
			precisionText.alpha = 1; precisionText.textoBtn.text = "";
		}
		
		private function onEnterFrame(event:Event):void{
			if(youtubePlayer!=null && youtubePlayerReady){
				currentTime = youtubePlayer.getCurrentTime();
				//Atualiza a timeBar
				timeBar.refresh(currentTime);
							
				if(lastTime != currentTime){					
					lastTime = currentTime;
					onEachFrame();			
				}
			}
		}	
		
		private function onEachFrame():void{
			var actualSub:String;
			var formato:TextFormat;
			
			if(skipButton.visible && currentTime+0.1>=timeFirstVerse && boxOld<versosInfo.length){
				skipButton.visible = false;
				skipButton.removeEventListener(MouseEvent.CLICK, skipBeginningHandler);
				var player:MyPlayer = Player.current as MyPlayer;
				this["botaoDobrarCombo"].addEventListener(MouseEvent.CLICK, dobraCombo);
			}
			
			if(loadedSubtitles == true){	
				for each(var trio:Array in versosInfo){
					if(versosInfo.indexOf(trio)>=versoEmJogo && currentTime>=trio[1]){
						textBoxes[boxNew] = new TextBox();
						textBoxes[boxNew].textoBox.text = WordShuffler.unescapeString(versosInfo[versoEmJogo][0]);	
						vetSelec[boxNew] = 0;
						if(versosInfo[versoEmJogo+1]!= null &&
						   (versosInfo[versoEmJogo+1][2]-versosInfo[versoEmJogo+1][1]>1 ||
							FeelMusic.masterSongId!=null)){
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
						break;
					}
				}
			}
			analisaLegenda();			
			sobeLegenda();
			removeMensagem();
		}
		
		private function analisaLegenda():void{
			//Vê se pode botar opções nos botões
			if(posicaoLegendaAtual!=int.MAX_VALUE && !jaPosAsOpcoes &&
			(posicaoLegendaOld==int.MAX_VALUE ||
			(textBoxes[posicaoLegendaOld]!=null && 
			!contains(textBoxes[posicaoLegendaOld]) ||
			textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") == -1))) {
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
		
		private function comboDisplay():void {
			if(combo > 1 && combo != lastCombo){
				comboText.text = "x"+Math.ceil(combo/3).toString();
				if((combo-1)%3==0){
					TweenLite.to(comboText, 0.5, {x:370, scaleX:3, scaleY:3, 
						glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:7.5},
						ease:Back.easeOut, onComplete:comboTextBack});	
					function comboTextBack():void{
						TweenLite.to(comboText, 0.5, {x:120, scaleX:1, scaleY:1, 
							glowFilter:{color:0xFFFF00, alpha:1, blurX:2, blurY:2, strength:3, quality:3},
						ease:Back.easeOut, delay:0.5});
					}
				}
				lastCombo = combo;
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
		
		public function getFinalScore():Number { return pontuacao; }
		public function getPerfectScore():Number { return perfectCount; }
		public function getGoodScore():Number { return goodCount; }
		public function getBadScore():Number { return badCount; }
		public function getMissScore():Number { return missCount; }
		public function getAccuracy():Number { return (5*perfectCount+4*goodCount+3*badCount+pontuacao)/(5*(progressBar.totalLacunas)+totalPointsWithCombo); }
		public function getComboScore():Number { return maxCombo; }
		public function getNewTime():Number { return youtubePlayer.getDuration(); }
		public function getNewExpressions():Array { return auxExpressoesAcertadas; }
		public function getNewAuxExpressionsBem():Array { return auxExpressBem; }
		public function getVersosModificados():Array { return versosModificados; }
		public function getNewItens():Array { return auxItens; }
		public function getTemasAbordados():Array { return temasNaPartida; }
		
		public var colorGlobal:Number = 0x000000;
		private function completarLetra(rst:Number):void { 
			var perfectFeedback:Array = ["Usain Bolt!", "Amazing!", "Fantastic!", "So fast!", "Unbelievable!", "OMG!", "Awesome!", "Dazzling!"];
			var goodFeedback:Array = ["Nice!", "Not bad!", "Good!", "Yeah!", "Keep going!", "yey!", "yay!", "wow!"];
			var badFeedback:Array = ["Do better!", "Faster!", "C'mon!", "Focus!"];
			var missFeedback:Array = ["Wrong!", "Try harder!", "Nope!", "Almost right!", "So close!"];
			var counterPosLacuna:Number;
			var formato:TextFormat;
			var compArray:Array = new Array();
			var posicVersoAcompletar:int = vetSelec.length-1;
			
			while(vetSelec[posicVersoAcompletar]!=1) { posicVersoAcompletar--; }
			if(textBoxes[posicaoLegendaOld]!=null && contains(textBoxes[posicaoLegendaOld]) &&
			   textBoxes[posicaoLegendaOld].textoBox.text.indexOf("_____") != -1) { posicVersoAcompletar--; }
			compArray = textBoxes[posicVersoAcompletar].textoBox.text.split(/ /g);
			
			for(counterPosLacuna=0; 
				compArray[counterPosLacuna]!="" && compArray[counterPosLacuna]!="\0" && compArray[counterPosLacuna]!=null && compArray[counterPosLacuna]!= "_____";
				counterPosLacuna++) {}
			compArray[counterPosLacuna]=this['wBtn'+btnCorreto].textoBtn.text.toUpperCase();
			textBoxes[posicVersoAcompletar].textoBox.text=compArray.join(" ");
			formato = textBoxes[posicVersoAcompletar].textoBox.getTextFormat();
			if(rst!=5) { //Ou  seja, se faz sentido mostrar o erro ainda
				var currFeedback:Array = new Array();
				if(rst==4){ formato.color = 0x00CDCD; currFeedback = perfectFeedback; //Perfect
				} else if(rst==3){ formato.color = 0x55FF55; currFeedback = goodFeedback;  //Good
				} else if(rst==2) { formato.color = 0xFFFF00; currFeedback = badFeedback; //Bad
				} else if (rst==1) { formato.color = 0xFF0000; currFeedback = missFeedback; //Miss
				}
				colorGlobal = Number(formato.color);
				
				//Mostra brilho na frase e no botao
				PlayScreenController.showParticlesAround(this, textBoxes[posicVersoAcompletar], colorGlobal);
				
				//Mostra feedback verbal
				feedbackMsg.text = currFeedback[Math.floor(Math.random()*currFeedback.length)];
				TweenLite.to(feedbackMsg, 0.2,
					{y:410, glowFilter:{color:formato.color, strength:10, blurX:3, blurY:3},
						onComplete:function():void { TweenLite.to(feedbackMsg, 0.2, 
						{delay:1, y:600});}
					});
			} else {
				formato.color = 0xFF0000;	
			}
			textBoxes[posicVersoAcompletar].textoBox.setTextFormat(formato);
			
			//Grava verso em versosModificados
			versosModificados.push(textBoxes[posicVersoAcompletar].textoBox);
		}
		
		public function skipBeginningHandler(navigationEvent:MouseEvent):void{
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
			adaptVARS.examination = JSON.stringify(examination);;
			adaptRequest.data = adaptVARS;
			adaptRequest.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.load(adaptRequest);
						
			//Termina a música e envia o evento de término
			youtubePlayer.stopVideo();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			dispatchEvent(new NavigationEvent(NavigationEvent.END));
		}		
	}
}