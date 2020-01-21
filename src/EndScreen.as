package
{
	import auxiliares.LevelBar;
	import auxiliares.NavigationEvent;
	import auxiliares.ParticleBalls;
	import auxiliares.PlayScreenController;
	import auxiliares.PopUp;
	import auxiliares.QuestLabel;
	import auxiliares.Settings;
	import auxiliares.WordShuffler;
	
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.mixpanel.Mixpanel;
	
	import enums.MP_EVT;
	
	import fl.motion.Color;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import flox_entities.MyPlayer;
	
	public class EndScreen extends MovieClip {
		//Variáveis já no MC
		public var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var endStuffSFX:EndStuffSFX = new EndStuffSFX();
		public var metalSE:MetalBamSE = new MetalBamSE();
		public var coinSE:CoinSE = new CoinSE();
		public var levelBar:LevelBar;
		public var musicTF:TextField;
		public var expGain:TextField;
		public var questionBtn:SimpleButton;
		public var repeatBtn:SimpleButton;
		public var chamarAmigosBtn:SimpleButton;
		public var backToMenuBtn:SimpleButton;
		public var nextChunkBtn:SimpleButton;
		public var showLyricsBlock:SimpleButton;
		public var continueBtn:SimpleButton;
		public var continueBlock:SimpleButton;
		public var showLyricsBtn:SimpleButton;
		public var showLyricsBtnQuantity:MovieClip;
		public var continueQuantity:MovieClip;
		public var letraHolder:MovieClip
		public var musicLevel:MovieClip;
		public var background:MovieClip;
		public var perfect:MovieClip;
		public var good:MovieClip;
		public var bad:MovieClip;
		public var miss:MovieClip;
		public var total:MovieClip;
		public var coinsEnding:MovieClip;
		public var newRecordBadge:MovieClip;
		
		//Mixpanel
		private var mixpanel:Mixpanel;
		
		//Outras variáveis
		private var mySound:Sound = new Sound();
		private var mySoundChannel:SoundChannel = new SoundChannel();
		private var temasAbordadosAux:Array = new Array();
		private var newMasteredWords:Array = new Array();
		private var musicName:String;
		private var quantasEstrelas:int;
		private var perfectScore:int;
		private var goodScore:int;
		private var badScore:int;
		private var missScore:int;
		private var comboScore:int;
		private var pontuacaoScore:int;
		private var totalCoinsNum:int;
		
		public function EndScreen() {
			//Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			//Seta propriedades e listeners essenciais
			miss.gotoAndStop(4);
			bad.gotoAndStop(3);
			good.gotoAndStop(2);
			finalButtonsVisible(false);
			coinsEnding.alpha = 0;
			musicLevel.alpha = 0;
			questionBtn.alpha = 0;
			levelBar.alpha = 0;
			continueBlock.addEventListener(MouseEvent.CLICK, onShowPremium);
			showLyricsBlock.addEventListener(MouseEvent.CLICK, onShowPremium);
			repeatBtn.addEventListener(MouseEvent.CLICK, onRepeatMusic);
			backToMenuBtn.addEventListener(MouseEvent.CLICK, onContinueToMenu);
			continueBtn.addEventListener(MouseEvent.CLICK, onRecomendMusic);
			showLyricsBtn.addEventListener(MouseEvent.CLICK, onProximoChunk);
			nextChunkBtn.addEventListener(MouseEvent.CLICK, onProximoChunk);
		}
		
		protected function onStarsExplanation(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showThreeStarsExplanation(musicName, missScore+badScore+goodScore+perfectScore);			
		}
		
		protected function onShowPremium(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showPremiumProposal();			
		}
		
		private function finalButtonsVisible(visible:Boolean):void {
			if(!visible) {
				repeatBtn.alpha = 0;
				continueBtn.alpha = 0;
				showLyricsBtn.alpha = 0;
				backToMenuBtn.alpha = 0;	
				nextChunkBtn.alpha = 0;
				continueQuantity.alpha = 0;
				showLyricsBtnQuantity.alpha = 0;
				continueBlock.visible = false;
				showLyricsBlock.visible = false;
			} else {
				TweenLite.to(repeatBtn, 0.75, {delay:1, alpha:1});
				TweenLite.to(continueBtn, 0.75, {delay:1, alpha:1});
				TweenLite.to(continueQuantity, 0.75, {delay:1, alpha:1});
				TweenLite.to(backToMenuBtn, 0.75, {delay:1, alpha:1});
				TweenLite.to(showLyricsBtn, 0.75, {delay:1, alpha:1});
				TweenLite.to(showLyricsBtnQuantity, 0.75, {delay:1, alpha:1});
				
				var player:MyPlayer = Player.current as MyPlayer;
				if(player.compras.indexOf("premium")>=0) {
					continueQuantity.visible = false; 
					showLyricsBtnQuantity.visible = false;	
				} else {
					continueQuantity["texto"].text = player.itens[6].toString(); 
					showLyricsBtnQuantity["texto"].text = player.itens[7].toString();
					if(player.itens[6]<=0) {
						continueBlock.visible=true;
						continueBlock.alpha=0;
						TweenLite.to(continueBlock, 0.75, {delay:1, alpha:1});					
					}
					if(player.itens[7]<=0) {
						showLyricsBlock.visible=true;
						showLyricsBlock.alpha=0;
						TweenLite.to(showLyricsBlock, 0.75, {delay:1, alpha:1});					
					}
				}
			}
		}
				
		private function onUpLetra(event:MouseEvent):void {
			letraHolder["content"].y += 70;
		}
		
		private function onDownLetra(event:MouseEvent):void {
			letraHolder["content"].y -= 70;			
		}
		
		public function getQuantasEstrelas():int {
			return quantasEstrelas;
		}
		
		public function getQuantasMoedas():int {
			return totalCoinsNum;
		}
		
		public function getFinalScore():Number {
			return pontuacaoScore;
		}

		public function setMusicName(musicGlobal:String):void {
			musicName = musicGlobal;
			musicTF.text = musicGlobal;
			setPastPoints();
		}
		
		private function setPastPoints():void {
			//Seta pontuações do passado
			var player:MyPlayer = Player.current as MyPlayer;
			for each(var level:Array in player.levels) {
				if(level[0]==musicName && level.length>=8){
					var counter:Number = 3;
					while(level[counter] != null && counter < 17) {
						total["pontuacaoPast"+(Math.round(counter/4)).toString()].text = level[counter];
						miss["textoPast"+(Math.round(counter/4)).toString()].text = level[counter+1];
						bad["textoPast"+(Math.round(counter/4)).toString()].text = level[counter+2];
						good["textoPast"+(Math.round(counter/4)).toString()].text = level[counter+3];
						perfect["textoPast"+(Math.round(counter/4)).toString()].text = level[counter+4];
						counter += 5;
					}	
				}
			}			
		}
		
		public function setFinalScore(scoreValor:Number):void {
			pontuacaoScore = scoreValor;
		}
		
		public function setPerfectScore(scoreValor:Number):void {
			perfectScore = scoreValor;
		}
		
		public function setGoodScore(scoreValor:Number):void {
			goodScore = scoreValor;
		}
		
		public function setBadScore(scoreValor:Number):void {
			badScore = scoreValor;
		}
		
		public function setMissScore(scoreValor:Number):void {
			missScore = scoreValor;
		}
		
		public function setComboScore(scoreValor:Number):void {
			comboScore = Math.floor(scoreValor/3);
		}
		
		public function setTemas(temasAbordados:Array):void {
			for each(var pair:Array in temasAbordados) {
				temasAbordadosAux.push(pair);
			}
		}
		
		public function savePlayerNewInfos(timeNew:Number, expressNew:Array, auxExpressBemNew:Array, auxItens:Array):void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.tempoTotal += timeNew;
			for each(var word:String in expressNew) {
				if(player.expressAcertadas.indexOf(word)==-1) {
					player.expressAcertadas.push(word);
					player.expressBem[player.expressAcertadas.indexOf(word)] = auxExpressBemNew[expressNew.indexOf(word)];
				} else if(player.expressBem[player.expressAcertadas.indexOf(word)]<10) {
					var multiplier:Number = 1;
					var noobMultiplier:Number = 1;
					if(PlayScreenController.masteredWords.length<2) {
						noobMultiplier = 5;
					} else if(PlayScreenController.masteredWords.length>=2 && PlayScreenController.masteredWords.length<10) {
						noobMultiplier = 2;
					}
					if(FeelMusic.masterSongId!=null) {
						multiplier = 5;
					}
					player.expressBem[player.expressAcertadas.indexOf(word)] += 
						noobMultiplier*multiplier*auxExpressBemNew[expressNew.indexOf(word)];
					//Se chegou a 10, acumula pra mostrar pro cara
					if(player.expressBem[player.expressAcertadas.indexOf(word)]>=10) {
						newMasteredWords.push(word);
					}
				}
			}
			for(var i:Number = 0; i<player.itens.length-2; i++) {
				player.itens[i] += auxItens[i];
			}
			player.saveQueued();
		}
		
		public function setLetraMotion(versosModificados:Array):void {
			var posY:Number = 0;
			for each(var verso:TextField in versosModificados) {
				letraHolder["content"].addChild(verso);
				verso.x = verso.width/2-235;
				verso.y = posY;
				posY += 70;
			}
		}
		
		public function setStars(scoreValor:Number):void {
			if(scoreValor==-1) {
				dispatchEvent(new NavigationEvent(NavigationEvent.AGAIN));				
			} else {
				if(scoreValor>=0.95){
					quantasEstrelas = 7;
					this["star1"].gotoAndStop(3);
					this["star2"].gotoAndStop(3);
					this["star3"].gotoAndStop(3);	
				} else if(scoreValor>=0.8 && scoreValor<0.95){
					quantasEstrelas = 6;
					this["star1"].gotoAndStop(3);
					this["star2"].gotoAndStop(3);
					this["star3"].gotoAndStop(2);	
				} else if(scoreValor>=0.66 && scoreValor<0.8){
					quantasEstrelas = 5;
					this["star1"].gotoAndStop(3);
					this["star2"].gotoAndStop(3);	
				} else if(scoreValor>=0.5 && scoreValor<0.66){
					quantasEstrelas = 4;
					this["star1"].gotoAndStop(3);
					this["star2"].gotoAndStop(2);
				} else if(scoreValor>=0.33 && scoreValor<0.5){
					quantasEstrelas = 3;
					this["star1"].gotoAndStop(3);
				} else if(scoreValor>=0.15 && scoreValor<0.33){
					quantasEstrelas = 2;
					this["star1"].gotoAndStop(2);
				} else if(scoreValor>=0 && scoreValor<0.15){
					quantasEstrelas = 1;
				}
				var player:MyPlayer = Player.current as MyPlayer;
				var coinsReward:Number = 2*quantasEstrelas;
				if(player.compras.indexOf("premium")>=0) {
					coinsReward *= 2;
				}
				coinsEnding["totalCoins"].text = "+"+coinsReward.toString();
				
				//Só seta o listener aqui porque só então já setei os scores (bad, good, perfect, etc)
				questionBtn.addEventListener(MouseEvent.CLICK, onStarsExplanation);
				
				bringPerfectScore();
			}	
		}
		
		private function bringPerfectScore():void {
			TweenLite.to(perfect, 0.3, {y:140, ease:Back.easeOut, onComplete:rollPerfectScore});				
		}
		
		public function rollPerfectScore():void {
			playEndStuffSFX(0.8);
			var numberAux:Object = {value: 999};
			TweenLite.to(numberAux, 0.3, {value:perfectScore, onUpdate:showScore, onComplete:bringGoodScore})			
			function showScore(){
				perfect["texto"].text = Math.round(numberAux.value).toString();
			}
		}
		
		private function bringGoodScore():void {
			TweenLite.to(good, 0.3, {y:210, ease:Back.easeOut, onComplete:rollGoodScore});				
		}
		
		public function rollGoodScore():void {
			playEndStuffSFX(0.85);
			var numberAux:Object = {value: 999};
			TweenLite.to(numberAux, 0.3, {value:goodScore, onUpdate:showScore, onComplete:bringBadScore})			
			function showScore(){
				good["texto"].text = Math.round(numberAux.value).toString();
			}
		}
		
		private function bringBadScore():void {
			TweenLite.to(bad, 0.3, {y:280, ease:Back.easeOut, onComplete:rollBadScore});				
		}
		
		public function rollBadScore():void {
			playEndStuffSFX(0.9);
			var numberAux:Object = {value: 999};
			TweenLite.to(numberAux,  0.3, {value:badScore, onUpdate:showScore, onComplete:bringMissScore})			
			function showScore(){
				bad["texto"].text = Math.round(numberAux.value).toString();
			}
		}
		
		private function bringMissScore():void {
			TweenLite.to(miss, 0.3, {y:350, ease:Back.easeOut, onComplete:rollMissScore});				
		}
		
		public function rollMissScore():void {
			playEndStuffSFX(0.95);
			var numberAux:Object = {value: 999};
			TweenLite.to(numberAux,  0.3, {value:missScore, onUpdate:showScore, onComplete:bringFinalScore})			
			function showScore(){
				miss["texto"].text = Math.round(numberAux.value).toString();
			}
		}
		
		private function bringFinalScore():void {
			TweenLite.to(total, 0.3, {y:140, ease:Back.easeOut, onComplete:rollFinalScore});				
		}
		
		public function rollFinalScore():void {
			playEndStuffSFX(0.99);
			var numberAux:Object = {value: 999999};
			TweenLite.to(numberAux,  0.6, {value:pontuacaoScore, onUpdate:showScore, onComplete:moveStar1});			
			function showScore(){
				total["pontuacao"].text = Math.round(numberAux.value).toString();
			}
		}
				
		public function moveStar1():void {
			musicLevel.alpha = 1;
			questionBtn.alpha = 1;
			TweenLite.to(this["star1"], 0.3, {alpha:1, scaleX: 1, scaleY:1, ease:Back.easeOut, onComplete:moveStar2});
			playEndStuffSFX(0.99);
		}
		
		public function moveStar2():void {
			if(quantasEstrelas>=4) {
				TweenLite.to(this["star2"], 0.3, {alpha:1, scaleX: 1, scaleY:1, ease:Back.easeOut, onComplete:moveStar3});
				playEndStuffSFX(0.99);
			} else {
				setTimeout(showCoins, 500);
			}
		}
		
		public function moveStar3():void {
			if(quantasEstrelas>=6) {
				TweenLite.to(this["star3"], 0.3, {alpha:1, scaleX: 1, ease:Back.easeOut, scaleY:1, onComplete:showCoins});
				playEndStuffSFX(0.99);
			} else {
				setTimeout(showCoins, 500);
			}
		}
		
		public function showCoins():void {
			coinsEnding.alpha = 1;
			
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(coinsEnding["totalCoins"].text.substr(1,int.MAX_VALUE));
			totalCoinsNum = Number(coinsEnding["totalCoins"].text.substr(1,int.MAX_VALUE));
			
			var numberAux:Object = {value: 99};
			particlesFromStars(coinsEnding, 2, coinsEnding.width, coinsEnding.height/2, 0.5);
			TweenLite.to(numberAux, 1, {value:totalCoinsNum, onUpdate:showScore})
			setTimeout(showLevelUp, 600);
			var altSound:Number = 0;
			function showScore(){
				coinsEnding["totalCoins"].text = "+"+Math.round(numberAux.value).toString();
				if(altSound%3==1) { coinSE.play(0,0,new SoundTransform(0.5)); } altSound++;
			}
		}
		
		public function showLevelUp():void {
			levelBar.alpha = 1;
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Grava novo level
			var ehNovoLevel:Boolean = true;
			var experienciaNova:Number = 0;
			for each(var level:Array in player.levels) {
				if(level[0]==musicName){
					ehNovoLevel = false;

					//Adiciona nova pontuação
					level.splice(3, 0, pontuacaoScore, missScore, badScore, goodScore, perfectScore);
					
					//Adiciona novo recorde se for o caso
					if(level[2]<=pontuacaoScore || level[1]<quantasEstrelas){
						experienciaNova = 3*(quantasEstrelas-level[1]);
						showNewsTxt(quantasEstrelas, level[1]); 
						player.levels.splice(player.levels.indexOf(level), 1);
						var auxLevel:Array = new Array();
						auxLevel.push(musicName, quantasEstrelas, pontuacaoScore);
						if(level.length>3) {
							for(var h:int = 3; h<level.length; h++) {
								auxLevel.push(level[h]);
							}
						}
						player.levels.push(auxLevel);
						break;
					}
				}
			}
			if(ehNovoLevel) {
				showNewsTxt(quantasEstrelas, 1); 
				experienciaNova = 3*(quantasEstrelas-1);
				player.primeiraPontuacao.push([musicName, quantasEstrelas, pontuacaoScore, missScore, badScore, goodScore, perfectScore]);
				player.levels.push([musicName, quantasEstrelas, pontuacaoScore, pontuacaoScore, missScore, badScore, goodScore, perfectScore]);
			}
			player.saveQueued();

			//Faz o levelBar mexer
			particlesFromStars(levelBar, 3, 50, 0, 1);
			levelBar.setPlayerLevel();
			levelBar.addEventListener(NavigationEvent.LEVELEDUP, showMasteredWords);
			var expTotal:Number = experienciaNova+1;
			levelBar.addXP(expTotal, this, true);
			expGain.text = "+"+expTotal.toString()+"xp";
			
			//Marca no ranking
			FeelMusic.rankingInput(expTotal);
		}		
		
		private function particlesFromStars(targetMC:MovieClip, targetFrame:Number, offsetX:Number, offsetY:Number, time:Number):void {
			for(var i:int=1; i<=5; i++) {
				for(var j:int=1; j<=3; j++) {
					var particle:ParticleBalls = new ParticleBalls(); this.addChild(particle);
					particle.gotoAndStop(targetFrame);
					particle.x = this["star"+j].x - 10*Math.random() + 10*Math.random(); 
					particle.y = this["star"+j].y - 10*Math.random() + 10*Math.random();
					particle.rotation = Math.random()*360;
					particle.scaleX = 0.5; particle.scaleY = 0.5;
					TweenLite.to(particle, time-Math.random()/4, {x:targetMC.x+offsetX, y:targetMC.y+offsetY, scaleX:1, scaleY:1,
					alpha: 0.9, onComplete: completeParticle(particle, time)});
				}
			}			
		}
		
		private function completeParticle(particle:ParticleBalls, time:Number):void {
			setTimeout(function(){removeChild(particle);}, time*1000-100);
		}
		
		protected function showMasteredWords(event:Event):void {
			if(newMasteredWords.length>0) {
				for each(var word:String in newMasteredWords) {
					var popUp:PopUp = new PopUp();
					popUp.bringPopUp(this);
					popUp.showMasteredWord(word);
					newMasteredWords.splice(newMasteredWords.indexOf(word), 1);
					popUp.addEventListener(Event.REMOVED_FROM_STAGE, showMasteredWords);
					break;
				}
			} else {
				showNextBtn(null);
			}
		}
		
		protected function showNextBtn(event:Event):void {
			if(FeelMusic.masterSongId!=null) {
				nextChunkBtn.visible = false;
				continueBlock.visible = false;
				this["progressTXT"].text = "Progresso: ";
				this["progressPercentage"].text = "";
				this["masterProgress"].visible = true;
				this["masterPrizeBtn"].visible = true;
				this["masterPrizeBlockBtn"].visible = true;
				this["masterPrizeBtn"].buttonMode = true;
				this["masterPrizeBlockBtn"].buttonMode = true;
				this["masterPrizeBtn"].mouseChildren = false;
				this["masterPrizeBlockBtn"].mouseChildren = false;
				this["masterRepeatBtn"].visible = true;
				this["masterPrizeBtn"].addEventListener(MouseEvent.CLICK, onGetMasterPrize);
				this["masterPrizeBlockBtn"].addEventListener(MouseEvent.CLICK, onBlockedPrize);
				this["masterRepeatBtn"].addEventListener(MouseEvent.CLICK, onRepeatMusic);
				TweenLite.to(this["masterPrizeBtn"], 0.75, {delay:1, alpha:1});
				TweenLite.to(this["masterPrizeBlockBtn"], 0.75, {delay:1, alpha:1});
				TweenLite.to(this["masterRepeatBtn"], 0.75, {delay:1, alpha:1});
				
				continueProgressSong();
			} else {
				TweenLite.to(nextChunkBtn, 0.75, {delay:1, alpha:1});
			}
		}
		
		public function onGetMasterPrize(event:MouseEvent):void {
			//Tira o listener e tornar alphalizado
			this["masterPrizeBtn"].alpha = 0.5
			this["masterPrizeBtn"].removeEventListener(MouseEvent.CLICK, onGetMasterPrize);	
			
			var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
			cashRegisterSFX.play(2000);
			
			//Pra não voltar pra esse modo
			FeelMusic.masterSongId = null;
			
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(this["masterPrizeBtn"].price.text);
			player.saveQueued();
			player.save(function onComplete():void {
				dispatchEvent(new NavigationEvent(NavigationEvent.AGAIN));
			}, function onError(e:String):void{});
		}
		
		public function onBlockedPrize(event:MouseEvent):void {
			var wrongSFX:WrongSoundSFX = new WrongSoundSFX();
			TweenMax.to(event.currentTarget, 0.1, {blurFilter:{blurX:30, remove:true}});
			wrongSFX.play(1000,0,new SoundTransform(0.5));
		}
		
		public var newPercentage:Array = new Array();
		private function continueProgressSong():void {
			PlayScreenController.setouMasteredWords = false;
			PlayScreenController.preparaMasteredWords(PlayScreenController.setouMasteredWords);
			
			newPercentage = PlayScreenController.getProgPercentage();
			var fillSE:FillLevelSE = new FillLevelSE();
			fillSE.play(0,0,null);
			TweenLite.to(this["masterProgress"].fill, 1, {x:this["masterProgress"].fill.x+newPercentage[1]*1.25,
							onComplete:congratulatePrize});
		}
		
		private function congratulatePrize():void {
			this["progressPercentage"].text = newPercentage[1].toString()+"%";
			if(newPercentage[1]>=100) {
				this["masterPrizeBlockBtn"].visible = false;
				this["prizeRay"].visible = true;
				var bringStuff:BringStuffSFX = new BringStuffSFX();
				bringStuff.play();
			}			
		}
		
		private function showNewsTxt(novasEstrelas:int, velhasEstrelas:int):void {
			for(var i:int=1; i<=7; i+=2) {
				if(velhasEstrelas<=i) {
					for(var j:int=i; j<novasEstrelas; j+=2) {
						this["new"+Math.ceil(j/2).toString()].visible = true;
					}
					break;
				}
			}
		}
				
		public function moveChunks(whichChunk:int):void {
			if(whichChunk==1) {
				TweenLite.to(perfect, 0.3, {x:-700});
				TweenLite.to(good, 0.3, {x:-700});
				TweenLite.to(bad, 0.3, {x:-700});
				TweenLite.to(miss, 0.3, {x:-700});
				TweenLite.to(total, 0.3, {x:-200});
				TweenLite.to(musicLevel, 0.3, {x:-200});
				TweenLite.to(questionBtn, 0.3, {x:-200});
				TweenLite.to(levelBar, 0.3, {x:-200});
				TweenLite.to(coinsEnding, 0.3, {x:-200});
				TweenLite.to(expGain, 0.3, {x:-200});
				for(var i:int=1; i<=3; i++) {
					TweenLite.to(this["star"+i], 0.3, {x:-200});
					TweenLite.to(this["new"+i], 0.3, {x:-200});
					TweenLite.to(this["quest"+i], 0.3+0.1*i, {x:150, delay:0.6});	
				}
			} else if(whichChunk==2) {
				for(var j:int=1; j<=3; j++) {
					TweenLite.to(this["quest"+j], 0.3+0.1*j, {x:-750});					
				}
				TweenLite.to(nextChunkBtn, 0.3, {x:-200});
				TweenLite.to(letraHolder, 0.3, {delay:0.6, x:180});
			}
		}
		
		public var chunkAtual:int = 1;
		protected function onProximoChunk(event:MouseEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			nextChunkBtn.alpha = 0;
			//Se vai aparecer as 3 quests, prepara elas
			if(chunkAtual==1) {
				//Joga a pontuacao mais atual de cada tema para a menos atual
				for each(var trice:Array in player.achievements) {
					trice[2] = trice[1];
				}
				//Pega cada tema do cara e soma com as novidades da ultima musica
				for each(var pair:Array in temasAbordadosAux) {
					var temTema:Boolean = false;
					for each(var trice2:Array in player.achievements) {
						if(pair[0]==trice2[0] && trice2[1]<100) {
							trice2[1] += pair[1];
							if (trice2[1]<0) { trice2[1]=0; }
							temTema = true;
						}
					}
					if(!temTema) {
						if(pair[1]<0) { pair[1] = 0; }
						player.achievements.push([pair[0], pair[1]*5, 0]);
					}
				}
				//Ordena os temas do cara pelos mais fortes
				player.achievements.sortOn("1", Array.NUMERIC | Array.DESCENDING);
				
				//Olha os 3 do topo e põe nos labels
				var questsCompletas:int = 0;
				var questIndex:int = 1;
				for each(var trice3:Array in player.achievements) {
					if(questsCompletas>=3 && player.compras.indexOf("premium")==-1) {
						//Se já completou 3 quests e não é premiu, bloqueia
						this["quest1"].blockThis(this);
						this["quest2"].blockThis(this);
						this["quest3"].blockThis(this);
						break;
					} else {
						if(questIndex>=4) { break; }
						if(trice3[2]<100) {
							this["quest"+questIndex].meta.text = trice3[0];
							this["quest"+questIndex].progressTxt.text = (trice3[1]>trice3[2] ? trice3[1] : trice3[2])+"%";
							if(Number(this["quest"+questCounter].message.text)>=0) {
								this["quest"+questIndex].message.text = "+"+[trice3[1]-trice3[2]].toString();
							} else {
								this["quest"+questIndex].message.text = [trice3[1]-trice3[2]].toString();
							}
							questIndex++;
						} else {
							questsCompletas++;
						}
					}
				}
				
				player.saveQueued();
				setTimeout(completeShowQuests, 1500);
			} 
			//Se vai aparecer a letra
			else if(chunkAtual==2) {
				player.itens[7]--;
				player.saveQueued();
				
				letraHolder["upLetra"].addEventListener(MouseEvent.MOUSE_DOWN, onUpLetra);
				letraHolder["downLetra"].addEventListener(MouseEvent.MOUSE_DOWN, onDownLetra);
			}
			moveChunks(chunkAtual);
			chunkAtual++;
		}
		
		public var questCounter:int = 1;
		private function completeShowQuests():void {
			//Upa cada uma das quests
			if(questCounter<=3) {
				var fillSE:FillLevelSE = new FillLevelSE();
				fillSE.play(0,0,null);
				if(this["quest"+questCounter].currentFrame!=4) { this["quest"+questCounter].gotoAndStop(3); }
				TweenLite.to(this["quest"+questCounter].message, 1, {y:this["quest"+questCounter].message.y-30});
				TweenLite.to(this["quest"+questCounter].progress.fill, 1, 
				{x:this["quest"+questCounter].progress.fill.x+Number(this["quest"+questCounter].progressTxt.text.
					substr(0,this["quest"+questCounter].progressTxt.text.length-1))*1.25, 
					onComplete:showQuestLoop});
			} else {
				showContinue(null);	
			}
		}
		
		public function showQuestLoop():void {
			if(Number(this["quest"+questCounter].progressTxt.text.
			   substr(0,this["quest"+questCounter].progressTxt.text.length-1))>=100) {
				var levelUpSE:LevelUpSE = new LevelUpSE();
				levelUpSE.play(0,0,null);
				if(this["quest"+questCounter].currentFrame!=4) { this["quest"+questCounter].gotoAndStop(2); }
				var player:MyPlayer = Player.current as MyPlayer;
				player.nrCoins+=100;
				player.saveQueued();
			} else {
				if(this["quest"+questCounter].currentFrame!=4) { this["quest"+questCounter].gotoAndStop(1); }
			}
			questCounter++;
			completeShowQuests();
		}
		
		public function showContinue(evt:NavigationEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.8;
			
			//Vê se mostra novoRecorde também
			var player:MyPlayer = Player.current as MyPlayer;
			var novoLevel:Boolean = true;
			for each(var level:Array in player.levels) {
				if(level[0]==musicName) {
					novoLevel = false;
					if(level[2]<pontuacaoScore) {
						st.volume = 0.5;
						metalSE.play(0,0,st);
						newRecordBadge.visible = true;
						break;
					}
				}
			}
			if(novoLevel) {
				st.volume = 0.5;
				metalSE.play(0,0,st);
				newRecordBadge.visible = true;
			}
			finalButtonsVisible(true);	
			
			//Envia json caso a partida tenha terminado dentro de modo curso
			if(FeelMusic.curso!=null) {
				sendJSONmodoCurso();
			}
		}
		
		private function sendJSONmodoCurso():void {
			var player:MyPlayer = Player.current as MyPlayer;
			var params:URLVariables = new URLVariables();
			params.acao             =     "adicionarResposta"; //default
			params.idpersonagem     =     player.playerKey;
			params.estrelas         =     quantasEstrelas.toString();
			params.pontos           =     pontuacaoScore.toString();
			params.perfect          =     perfectScore.toString();
			params.good             =     goodScore.toString();
			params.bad              =     badScore.toString();
			params.miss             =     missScore.toString();
			
			//Descobre o id da tarefa e põe como parâmetro também
			var musicID:String = "0";
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[4]==musicName) {
					musicID = quintuple[2];
					break;
				}
			}
			for each(var theme:Object in FeelMusic.curso) {
				for each(var pair:Array in theme.musics) {
					if(pair[0]==musicID.toString()) {
						params.idtarefa = pair[1];
						break;
					}
				}		
			}
			if(params.idtarefa==null) {
				params.idtarefa = "Erro_Nulo";
			}
			
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.data = params;
			request.url = "https://www.backpacker.com.br/flash.controller.php";
			
			var loader:URLLoader = new URLLoader();
			loader.load(request);			
		}
		
		public function onRepeatMusic(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);
			dispatchEvent(new NavigationEvent(NavigationEvent.PLAYAGAIN));
		}
		
		public function onRecomendMusic(event:MouseEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.itens[6]--;
			player.saveQueued();
			
			//Pega os tres temas mais fortes do cara
			var tresTemas:Array = new Array();
			var questIndex:int = 1;
			for each(var trice3:Array in player.achievements) {
				if(questIndex>=4) { break; }
				if(trice3[2]<100) {
					tresTemas.push(trice3[0]);
					questIndex++;
				}
			}
			
			//Vê que músicas ele tem do primeiro ao terceiro. Se tiver de algum, pega aleatória
			var possibilities:Array = new Array();
			for each(var nomeTema:String in tresTemas) {
				for each(var tema:Object in WordShuffler.themes) {
					if(nomeTema==tema) {
						for each(var pair:Array in tema.musics) {
							if(player.temas.indexOf(pair[0])>=0) {
								possibilities.push(pair[0]);
							}
						}
						break;
					}
				}
			}
			
			//Se teve pelo menos uma nos tres temas pega de la, senao pega aleatoria
			var evt:NavigationEvent = new NavigationEvent(NavigationEvent.PLAYAGAIN);
			evt.data = new Object();
			if(possibilities.length>0) {
				evt.data.id = possibilities[Math.floor(Math.random()*possibilities.length-1)];	
			}
			else {
				evt.data.id = player.temas[Math.floor(Math.random()*player.temas.length-1)];
			}
			dispatchEvent(evt);
		}
		
		protected function onChoseRecomendedMusic(event:Event):void {
			var json:Object = JSON.parse(event.target.data);
			//TODO recomendação específica
			dispatchEvent(new NavigationEvent(NavigationEvent.PLAYAGAIN));						
		}
		
		public function onContinueToMenu(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);
			dispatchEvent(new NavigationEvent(NavigationEvent.AGAIN));
		}		
		
		public function playEndStuffSFX(volume:Number):void {
			var st:SoundTransform = new SoundTransform(); st.volume = volume;
			endStuffSFX.play(0,0,st);
		}
	}
}