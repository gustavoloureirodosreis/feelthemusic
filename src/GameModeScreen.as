package  {
	
	import auxiliares.BestMusicScore;
	import auxiliares.LevelBar;
	import auxiliares.NavigationEvent;
	import auxiliares.PopUp;
	
	import com.gamua.flox.Entity;
	import com.gamua.flox.Flox;
	import com.gamua.flox.Player;
	import com.gamua.flox.TimeScope;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import fl.motion.Color;
	import fl.transitions.Tween;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import flox_entities.Invites;
	import flox_entities.MyPlayer;
	
	
	public class GameModeScreen extends MovieClip {
		//Variáveis já no MC
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var singleplayerBtn:SimpleButton;
		public var multiplayerBtn:SimpleButton;
		public var multiplayerBlock:SimpleButton;
		public var inviteBtn:SimpleButton;
		public var verRanking:SimpleButton;
		public var beginningGif:MovieClip;
		public var cursoBtn:MovieClip;
		public var cursoTxt:TextField;
		
		//Outras variáveis
		private var bestMS:BestMusicScore = new BestMusicScore();
		public var popUp:PopUp = new PopUp();
		public var checouCombo:Boolean = false;
		
		public function GameModeScreen() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			setTimeout(function(){showBeginningGif(1);}, 1000);
			
			//Listeners
			verRanking.addEventListener(MouseEvent.CLICK, onLoadScores);
			singleplayerBtn.addEventListener(MouseEvent.CLICK, choseSingle);
			multiplayerBtn.addEventListener(MouseEvent.CLICK, choseMulti);
			multiplayerBlock.addEventListener(MouseEvent.CLICK, choseBlock);
			inviteBtn.addEventListener(MouseEvent.CLICK, inviteFBfriends);
			
			//Checa se mostra o bloqueio
			var player:MyPlayer = Player.current as MyPlayer;
			var levelBar:LevelBar = new LevelBar();
			levelBar.setPlayerLevel();
			if(levelBar.getPlayerLevel()>=25) {
				multiplayerBlock.visible = false;
			}
			
			//Checa o combo
			if(!checouCombo) {
				onCheckCombo();
			}
		}
		
		protected function choseBlock(event:MouseEvent):void {
			TweenMax.to(event.currentTarget, 0.1, {blurFilter:{blurX:30, remove:true}});
			var wrongSFX:WrongSoundSFX = new WrongSoundSFX();
			wrongSFX.play(1000,0,new SoundTransform(0.5));			
		}
		
		protected function onCheckCombo():void {
			//Checa que mensagem de combo dar
			var player:MyPlayer = Player.current as MyPlayer;
			var today:Date = new Date();
			var myPattern1:RegExp = /-/g; var myPattern2:RegExp = /T/;
			if(player.comboDates==null) { player.comboDates = new Array(); }
			if(!FeelMusic.ehGuest) {
				//Checa combo diário no caso de jogador não-premium
				if(player.compras.indexOf("premium")==-1) {
					if(player.comboDates.length==0){
						player.comboDates.push(today);
						//Certamente entrou em um dia novo, ainda que recomeçando o combo
						player.diasJogados++;
						player.saveQueued();
						
						popUp.bringPopUp(this);
						popUp.showDailyCombo(player.comboDates.length);
					} else {
						var dateParsedAux:String = String(player.comboDates[player.comboDates.length-1]).replace(myPattern1, '/').replace(myPattern2, ' ');
						var dateNumber:Number = Date.parse(dateParsedAux.substr(0,19)); //"19" para cortar dos milissegundos em diante
						if(today.dateUTC.toString()!=dateParsedAux.substr((today.dateUTC.toString().length==1 ? 9:8),today.dateUTC.toString().length)
						   && (today.time - dateNumber) < 2*86400000) {
							player.comboDates.push(today);
							//Grava um novo dia
							player.diasJogados++;
							player.saveQueued();
							
							popUp.bringPopUp(this);
							var diasDeCombo:Number = player.comboDates.length;
							if(diasDeCombo>5) { diasDeCombo = 5; }
							popUp.showDailyCombo(diasDeCombo);
						} else if(today.time - dateNumber >= 2*86400000) {
							//Demorou mais de um dia pra entrar, então retoma do dia zero.
							player.comboDates = new Array();
							player.saveQueued();
						}
					}
				//Checa combo diário no caso de jogador premium
				} else {
					if(player.comboDates.length==0){
						player.comboDates.push(today);
						player.saveQueued();
						popUp.bringPopUp(this);
						popUp.showPremiumCombo();
					} else {
						var dateParsedAux2:String = String(player.comboDates[player.comboDates.length-1]).replace(myPattern1, '/').replace(myPattern2, ' ');
						if(today.dateUTC.toString()!=dateParsedAux2.substr((today.dateUTC.toString().length==1 ? 9:8),today.dateUTC.toString().length)) {
							player.comboDates.push(today);
							player.saveQueued();
							popUp.bringPopUp(this);
							popUp.showPremiumCombo();
						}
					}
				}
				
				//Joga PopUp de vendas por cima, se for o caso
				checkVendas();
				//Joga PopUp de retorno de invite, se for o caso
				checkInvites();
				//Joga PopUp de fim de ranking, se for o caso
				checkEndRanking();
				//Prepara configurações do menu de modo Curso
				settingsCursoBtn();
				
			}
			checouCombo = true;
			popUp.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateDatesAndCoins);
		}
				
		private function checkVendas():void {			
			var startScreen:StartScreen = new StartScreen();
			startScreen.popUpRoulette(this);
		}
		
		private function checkInvites():void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.sugestions!=null && player.sugestions.length>0) {
				var invitesId:String = "curr-invites";
				Entity.load(Invites, invitesId,
					completeInvites,
					function onError(error:String, httpStatus:int):void {}
				);
			}
		}
		
		public function completeInvites(invites:Invites):void {
			var player:MyPlayer = Player.current as MyPlayer;
			var effectiveInvites:Array = new Array();
			for each(var invite:String in invites.sent) {
				if(player.sugestions.indexOf(invite)>=0) {
					invites.sent.splice(invites.sent.indexOf(invite),1);
					effectiveInvites.push(invite);
				}
			}
			if(effectiveInvites.length>0) {
				invites.saveQueued();
				//Chama a PopUp de resultado de convites
				var popUpInvite:PopUp = new PopUp();
				popUpInvite.inviteResults(effectiveInvites);
				popUpInvite.bringPopUp(this);
				popUpInvite.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateDatesAndCoins);
			} 
		}
		
		private function checkEndRanking():void {
			var invitesId:String = "curr-invites";
			Entity.load(Invites, invitesId,
				function onComplete(invite:Invites):void {
					var dateNow:Date = new Date();
					//Se já passou 7 dias do ranking, recomeça informações a respeito
					if(dateNow.time - invite.currRankingDate.time > 7*24*60*60*1000) {
						invite.currRankingDate = dateNow;
						invite.viramCurrRanking = new Array();
						invite.saveQueued();
					}					
					//Vê se o player já viu o resultado dessa última semana, e então mostra caso não
					var player:MyPlayer = Player.current as MyPlayer;
					if(invite.viramCurrRanking.indexOf(player.playerKey)==-1) {
						invite.viramCurrRanking.push(player.playerKey);
						invite.saveQueued();
						//Calcula posição do cara no ranking
						var playerRanking:Number = 100;
						Flox.loadScores("rankingsemanal", TimeScope.THIS_WEEK, 
						function onComplete(scores:Array):void {
							if(scores!=null) {
								for(var j:int=0; j<scores.length; j++) {
									if(scores[j].playerName.split("###")[0] == player.username) {
										playerRanking = Math.ceil(j/scores.length*100);
										break;
									}
								}
							}
						},
						function onError(error:String):void { trace(error); });
						//Se o cara ficou pelo menos nos 50%, ve a popup do ranking
						if(playerRanking<=50) {
							var popUpRanking:PopUp = new PopUp();
							popUpRanking.rankingResult(playerRanking);
							popUpRanking.bringPopUp(this);
							popUpRanking.addEventListener(Event.REMOVED_FROM_STAGE, onUpdateDatesAndCoins);
						}
					}
				},
				function onError(error:String, httpStatus:int):void {}
			);	
		}
		
		public function onLoadScores(event:MouseEvent):void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.5;
			var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
			btnPressedSFX.play(0,0,st);
			
			//Mostra a pontuação máxima
			Flox.loadScores("rankingsemanal", TimeScope.THIS_WEEK, 
				onCompleteLoadingScores, function onError(error:String):void { trace(error);});
		}
		
		private function onCompleteLoadingScores(scores:Array):void {
			this.addChild(bestMS); 
			var player:MyPlayer = Player.current as MyPlayer;
			if(scores!=null) {
				for(var i:int=0; i<3; i++) {
					if(scores[i] != null) {
						bestMS["maxRecord"+(i+1)].text = scores[i].value.toString();
						bestMS["userMaxRecord"+(i+1)].text = scores[i].playerName.split("###")[0];
					} else {
						bestMS["maxRecord"+(i+1)].text = "0";
						bestMS["userMaxRecord"+(i+1)].text = "---";
					}
				}
				var jaPontuouNaSemana:Boolean = false;
				for(var j:int=0; j<scores.length; j++) {
					if(scores[j].playerName.split("###")[0] == player.username) {
						bestMS["yourPosition"].text = j.toString();
						bestMS["maxRecordYou"].text = scores[j].value.toString();
						bestMS.yourPositionRel.text = "TOP: "+Math.ceil(j/scores.length*100).toString()+"%";
						if(Math.ceil(j/scores.length*100)<20) {
							TweenMax.to(bestMS.yourPositionRel, 0.3, {glowFilter:{color:0x00FF00, alpha:1, blurX:5, blurY:5, strength:2}});
						} else {
							TweenMax.to(bestMS.yourPositionRel, 0.3, {glowFilter:{color:0xFF0000, alpha:1, blurX:5, blurY:5, strength:2}});
						}
						jaPontuouNaSemana = true;
						break;
					}
				}
				if(!jaPontuouNaSemana) {
					bestMS["yourPosition"].text = "9999";
					bestMS["yourPositionRel"].text = "TOP: 100%";
					bestMS["maxRecordYou"].text = "0";
				}
			}
			bestMS["userMaxRecordYou"].text = player.username;
			bestMS.x = 180; bestMS.y = -500;
			TweenLite.to(bestMS, 0.8, {y:75, ease:Back.easeOut});
			bestMS["closeRanking"].addEventListener(MouseEvent.CLICK, onCloseRanking);
		}
		
		protected function onCloseRanking(event:MouseEvent):void {
			this.removeChild(bestMS);
		}
		
		private function inviteFBfriends(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.inviteFriends();
		}

		private function showBeginningGif(frame:int):void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.diasJogados<2) {
				if(!contains(popUp)){
					beginningGif.visible = true;
					beginningGif.gotoAndStop(frame);
					beginningGif["beginningGifTxt"+beginningGif.currentFrame].text = 
					FeelMusic._("beginningGifTxt"+beginningGif.currentFrame);
					setTimeout(function(){showBeginningGif(frame%3+1)}, 3000);
				} else { setTimeout(function(){showBeginningGif(1)}, 6000); }
			}
		}
				
		private function settingsCursoBtn():void {
			cursoBtn.price.text = "Curso";
			cursoBtn.buttonMode = true;
			cursoBtn.mouseChildren = false;
			if(FeelMusic.tipoUsuario=="4") {
				cursoBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent){cursoTxt.y = 500;});
				cursoBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){cursoTxt.y = 1000;});
				cursoBtn.addEventListener(MouseEvent.CLICK, goPagCurso);
			} else {
				var color:Color = new Color();
				color.brightness = 0;         
				cursoTxt.text = "";
				cursoBtn.transform.colorTransform = color;
				cursoBtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent){e.target.gotoAndStop(2);});
				cursoBtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){e.target.gotoAndStop(1);});
				cursoBtn.addEventListener(MouseEvent.CLICK, choseCurso);
			}
		}
				
		protected function goPagCurso(event:MouseEvent):void {
			var request:URLRequest = new URLRequest("https://www.backpacker.com.br/produto.ftm.escola");
			navigateToURL(request, "_self");		
		}
		
		private function moveContent(amount:Number, delay:Boolean):void {
			var del1:Number = 0.25;
			var del2:Number = 0.25;
			if(delay) {
				del1 = 0;
			} else {
				del2 = 0;
			}
			TweenLite.to(singleplayerBtn, 0.5, {x:singleplayerBtn.x+amount, delay:del1, ease:Back.easeIn});
			TweenLite.to(multiplayerBtn, 0.5, {x:multiplayerBtn.x+amount, delay:del1, ease:Back.easeIn});
			TweenLite.to(multiplayerBlock, 0.5, {x:multiplayerBlock.x+amount, delay:del1, ease:Back.easeIn});
			TweenLite.to(cursoBtn, 0.5, {x:cursoBtn.x+amount, delay:del2, ease:Back.easeOut});
			TweenLite.to(cursoTxt, 0.5, {x:cursoTxt.x+amount, delay:del2, ease:Back.easeOut});
		}
		
		protected function onUpdateDatesAndCoins(event:Event):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.UPDATECOINS));
		}
				
		public function commonChose():void {
			var st:SoundTransform = new SoundTransform(); st.volume = 0.9;
			pianoTum.play(100,0,st);			
		}
		
		protected function choseMulti(event:MouseEvent):void {
			commonChose();
			dispatchEvent(new NavigationEvent(NavigationEvent.MULTIPLAY));			
		}
		
		protected function choseSingle(event:MouseEvent):void {
			commonChose();
			dispatchEvent(new NavigationEvent(NavigationEvent.SINGLEPLAY));
		}
		
		protected function choseCurso(event:MouseEvent):void {
			commonChose();
			dispatchEvent(new NavigationEvent(NavigationEvent.CURSOPLAY));
		}

		
	}
	
}
