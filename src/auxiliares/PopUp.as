package auxiliares  {
	
	
	import com.gamua.flox.Entity;
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.mixpanel.Mixpanel;
	
	import enums.MP_EVT;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flox_entities.GameMatch;
	import flox_entities.Invites;
	import flox_entities.MyPlayer;
	
	
	public class PopUp extends MovieClip {
		//Variáveis já no MC:
		public var continueBtn:SimpleButton;
		//Frame 1
		public var date:TextField;
		public var music:TextField;
		public var opponent:TextField;
		public var result:TextField;
		public var balance:TextField;
		//Frame 2
		public var dailyComboRect:MovieClip;
		public var coinsDay1:TextField;
		public var fichasDay1:TextField;
		public var coinsDay2:TextField;
		public var fichasDay2:TextField;
		public var coinsDay3:TextField;
		public var fichasDay3:TextField;
		public var coinsDay4:TextField;
		public var fichasDay4:TextField;
		public var coinsDay5:TextField;
		public var fichasDay5:TextField;
		//Frame 3 e Frame 4
		public var amntConversionMP:TextField;
		public var amntConversionSingle:TextField;
		public var convertCoinsToFichas:SimpleButton;
		public var goShopping:SimpleButton;
		//Frame 5
		public var coinsPrize:TextField;
		public var levelPrize:TextField;
		public var levelPrizeMinus:TextField;
		//Frame 6
		public var callAmigoBtn:SimpleButton;
		public var callRandomBtn:SimpleButton;
		public var acceptBtn:SimpleButton;
		//Frame 7
		public var masteredWord:TextField;
		public var masteredPrize:TextField;
		//Frame 9
		public var amntEnough:TextField;
		public var invite:SimpleButton;
		public var maisAmigosBtn:SimpleButton;
		//Frame 11
		public var comprarAssinatura:MovieClip;
		//Frame 12
		public var coinsPremium:TextField;
		public var fichasPremium:TextField;
		//Frame 13 (e 8)
		public var tokensToCoinsBtn:SimpleButton;
		
		//Outras variáveis
		private var mixpanel:Mixpanel;
		public var bringStuff:BringStuffSFX = new BringStuffSFX();
		public var coinSFX:CoinSE = new CoinSE();
		public var matchGlobal:GameMatch;
		
		public function PopUp() {
			mixpanel = Settings.getInstance().mixpanel;
		}
		
		protected function onExit(event:MouseEvent):void {
			continueBtn.removeEventListener(MouseEvent.CLICK, onExit);
			setTimeout(onClose, 100);
		}
		
		protected function onExitWithCashSound(event:MouseEvent):void {
			var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
			cashRegisterSFX.play(2000, 0, null);
			onExit(null);
		}
		
		protected function onExitFrameConversion(event:MouseEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(this.currentFrame==3) {
				player.nrCoins -= Number(amntConversionSingle.text);
				player.nrMPCoins += Number(amntConversionMP.text);
			} else if(this.currentFrame==4) {
				player.nrCoins += Number(amntConversionSingle.text);
				player.nrMPCoins -= Number(amntConversionMP.text);
			}
			var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
			cashRegisterSFX.play(2000, 0, null);
			continueBtn.visible = false;
			player.save(function onComplete(){
				setTimeout(onClose, 100);			
			}, function onError(message:String) {});
		}
		
		protected function onExitFrame1(event:MouseEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrMPCoins += Number(balance.text);
			continueBtn.visible = false;
			player.save(function onComplete(){
				setTimeout(onClose, 100);			
			}, function onError(message:String) {});
		}
		
		protected function onClose():void {
			if(continueBtn!=null) {
				continueBtn.removeEventListener(MouseEvent.CLICK, onExit);
			}
			parent.removeChild(this);
		}
		
		public function bringPopUp(father:MovieClip):void {
			this.x = 100; this.y = 15;
			this.scaleX = 0.25; this.scaleY = 0.25;
			father.addChild(this);
			bringStuff.play();
			TweenLite.to(this, 0.5, {scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		public function showMPMatchResult(match:GameMatch):void {
			matchGlobal = match;
			
			this.gotoAndStop(1);
			fillText(this.currentFrame);
			var auxDate1:Array = match._dateCreated.toString().split(' ');
			date.text = auxDate1[2]+"/"+auxDate1[1]+"/"+auxDate1[5];
			music.text = match._musica.split("-")[0]+"\n"+match._musica.split("-")[1];
			opponent.text = "Opponent: "+match._receiver;
			result.text = "Winner: "+match._winner;
			if(match._winner==match._sender) {
				if(match._betType=="easyBet") { balance.text = "10";} 
				else if(match._betType=="mediumBet") { balance.text = "50"; }
				else { balance.text = "200"; }
			} else {
				balance.text = "0";
			}
			continueBtn.addEventListener(MouseEvent.CLICK, onExitFrame1);
		}
				
		public var numberAux:Object = {value: 99};
		public var altSound:Number = 0;
		public var dayNrGlobal:Number = 0
			
		public function showDailyCombo(dayNr:Number):void {
			dayNrGlobal = dayNr;
			this.gotoAndStop(2);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			dailyComboRect.gotoAndStop(dayNr);

			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(this["coinsDay"+dayNr].text);
			player.nrMPCoins += Number(this["fichasDay"+dayNr].text);
			player.saveQueued();
		}		
		
		public function showMoreMPcoins():void {
			this.gotoAndStop(3);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExitFrameConversion);
			this.addEventListener(KeyboardEvent.KEY_UP, onMakeConversion);
		}
		
		public function showMoreSingleCoins():void {
			this.gotoAndStop(4);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExitFrameConversion);
			this.addEventListener(KeyboardEvent.KEY_UP, onMakeConversion);
		}
		
		protected function onMakeConversion(event:KeyboardEvent):void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(this.currentFrame==3) {
				if(player.nrCoins<Number(amntConversionSingle.text) || amntConversionSingle.text.indexOf("-")!=-1){
					amntConversionSingle.text = player.nrCoins.toString();
				}
				amntConversionMP.text = Math.floor(Number(amntConversionSingle.text)/2).toString();					
			} else if(this.currentFrame==4) {
				if(player.nrMPCoins<Number(amntConversionMP.text) || amntConversionMP.text.indexOf("-")!=-1){
					amntConversionMP.text = player.nrMPCoins.toString();
				}
				amntConversionSingle.text = Math.floor(Number(amntConversionMP.text)/2).toString();	
			}
		}
		
		public function showNewLevel(newLevel:int):void {
			this.gotoAndStop(5);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			coinsPrize.text = "250";
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(coinsPrize.text);
			var levelBar:LevelBar = new LevelBar();
			levelPrize.text = levelBar.getPlayerLevel().toString();
			levelPrizeMinus.text = (levelBar.getPlayerLevel()-1).toString();
			player.save(
				function onComplete(){continueBtn.visible = true;},
				function onError(message:String) {});
		}
		
		public function showChooseMultiStyle():void {
			this.gotoAndStop(6);
			fillText(this.currentFrame);
			callAmigoBtn.addEventListener(MouseEvent.CLICK, onChamarAmigoMulti);
			callRandomBtn.addEventListener(MouseEvent.CLICK, onCallRandomMulti);
		}
		
		
		protected function onCallRandomMulti(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.MULTIRANDOM));
			onClose();
		}
		
		protected function onChamarAmigoMulti(event:MouseEvent):void {
			//Chamar função de convite do facebook
		}
		
		public function showMasteredWord(word:String):void {
			this.gotoAndStop(7);
			fillText(this.currentFrame);
			masteredWord.text = word;
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(masteredPrize.text);
			player.saveQueued();
			continueBtn.addEventListener(MouseEvent.CLICK, onExitWithCashSound);
		}
				
		public function showLojinha():void {
			if(!FeelMusic.onFacebook){//ftm normal
				this.gotoAndStop(8);
				fillText(this.currentFrame);
			}else{//ftm facebook
				this.gotoAndStop(13);
				fillText(this.currentFrame);
			}
			
			tokensToCoinsBtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {showMoreSingleCoins();});
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			
			this["comprar1"].price.text = "R$3.90";
			this["comprar2"].price.text = "R$14.90";
			this["comprar3"].price.text = "R$59.90";
			this["comprar4"].price.text = "R$159.90";
			for(var i:int=1; i<=4; i++) {
				this["comprar"+i].mouseChildren = false;
				this["comprar"+i].buttonMode = true;
				this["comprar"+i].addEventListener(MouseEvent.MOUSE_OVER, onOverComprarBtn);
				this["comprar"+i].addEventListener(MouseEvent.MOUSE_OUT, onOutComprarBtn);
				this["comprar"+i].addEventListener(MouseEvent.CLICK, onBuyPackage);
			}
		}
				
		public function onOverComprarBtn(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(2);
		}
		
		public function onOutComprarBtn(event:MouseEvent):void {
			event.currentTarget.gotoAndStop(1);
		}
		
		public function onBuyPackage(event:MouseEvent):void {
			var numberChosen:Number = Number(event.currentTarget.name.substr(7,int.MAX_VALUE));
			var coinsAmnt:Number = Number(this["priceCoins"+numberChosen].text);
			var player:MyPlayer = Player.current as MyPlayer;
			
			var data:URLVariables = new URLVariables();
			data.email = player.email;
			data.ftm_coins = coinsAmnt.toString();
			
			if(!FeelMusic.onFacebook){//ftm normal
				var request:URLRequest = new URLRequest("https://loja.backpacker.com.br/");
				request.data = data;
				navigateToURL(request, "_self");
			}
			else{ //ftm facebook 
				var params:Object = new Object();
				params.fbCoins = Number(this["priceFBCoins"+numberChosen].text);
				params.n = numberChosen;
				params.ftmCoins = coinsAmnt;
				params.email = player.email;
				ExternalInterface.addCallback("responsePurchase", onFacebookPurchase);
				ExternalInterface.call("buy_coins", params);
				
			}
		}
		
		public function onFacebookPurchase(bought:Boolean, numberChosen:Number):void{
			var player:MyPlayer = Player.current as MyPlayer;
			if (bought) {
				var fbCoins:Number = Number(this["priceFBCoins"+numberChosen].text);
				var coinsAmnt:Number = Number(this["priceCoins"+numberChosen].text);
				
				player.nrCoins += coinsAmnt;
				player.saveQueued();
				this.gotoAndStop(15);
				fillText(this.currentFrame);
				continueBtn.addEventListener(MouseEvent.CLICK, onExit);
				this["coinsPrize"].text = coinsAmnt;
				this["coinsFBPrize"].text = fbCoins;
			}
			
			ExternalInterface.addCallback("responsePurchase", null);
		}
		
		public function showPromoMusics(musicNames:Array):void {
			this.gotoAndStop(9);
			for(var i:int=1; i<=8; i++) {
				if(musicNames[i-1]!=null) {
					this["music"+i]["disco"].gotoAndStop(Math.round(musicNames[i-1][0]/10));
					this["music"+i].musica_nome.text = musicNames[i-1][1];
					this["music"+i].mouseChildren = false;
					this["music"+i].buttonMode = true;
					this["music"+i].score.text = "0";
					this["music"+i].addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void {
						event.currentTarget["stroke"].gotoAndStop(2);});
					this["music"+i].addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void {
						event.currentTarget["stroke"].gotoAndStop(1);});
					this["music"+i].addEventListener(MouseEvent.CLICK, onChooseMusic);
				} else {
					this["music"+i].visible = false;
				}
			}
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
		}
		
		public function onChooseMusic(event:MouseEvent):void {
			var pianoTum:PianoTumSFX = new PianoTumSFX();
			pianoTum.play(100,0,new SoundTransform(0.9));
			var evt:NavigationEvent = new NavigationEvent(NavigationEvent.MUSICCHOOSEN);
			evt.data = new Object();
			evt.data.name = event.currentTarget.musica_nome.text;
			dispatchEvent(evt);
			onExit(null);
		}
		
		public function inviteFriends():void {
			this.gotoAndStop(16);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			invite.addEventListener(MouseEvent.CLICK, onInitiateInvite);
		}
		
		protected function onInitiateInvite(event:MouseEvent):void {
			ExternalInterface.call("invite_friends");
			ExternalInterface.addCallback("inviteFriendsCompletedSending", inviteFriendsCompletedSending);
		}
		
		public function inviteFriendsCompletedSending(invites:Array):void {
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Registra no mixpanel quantos foram chamados
			mixpanel.track(MP_EVT.CONVIDOU_AMIGO, {
				'Jogador': player.username,
				'Chamou quantos': invites.length
			});
			
			//Registra no jogador os que ele chamou
			for each(var friendName:String in invites) {
				player.sugestions.push(friendName);
			}
			player.saveQueued();
			showInvitesSuccess();
		}
		
		private function showInvitesSuccess():void {
			this.gotoAndStop(18);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
		}
		
		public function showPremiumProposal():void {
			this.gotoAndStop(11);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			var player:MyPlayer = Player.current as MyPlayer;
			comprarAssinatura["price"].text = FeelMusic._("See More!");
			comprarAssinatura.buttonMode = true;
			comprarAssinatura.mouseChildren = false;
			comprarAssinatura.addEventListener(MouseEvent.MOUSE_OVER, onGlow);
			comprarAssinatura.addEventListener(MouseEvent.MOUSE_OUT, onUnGlow);
			comprarAssinatura.addEventListener(MouseEvent.CLICK, onBuyPremium);			
		}
		
		protected function onUnGlow(event:MouseEvent):void { event.currentTarget.gotoAndStop(1); }
		
		protected function onGlow(event:MouseEvent):void { event.currentTarget.gotoAndStop(2); }
		
		protected function onBuyPremium(event:MouseEvent):void {			
			var player:MyPlayer = Player.current as MyPlayer;
			var data:URLVariables = new URLVariables();
			data.email = player.email;
			if(!FeelMusic.onFacebook){
				var request:URLRequest = new URLRequest("https://loja.backpacker.com.br/subscribe/");
				request.data = data;
				navigateToURL(request, "_self");
			}
			else{
				//assinatura por facebook
				ExternalInterface.call("subscription");
				ExternalInterface.addCallback("subscriptionResponse", onSubsResponseFB);
			}		
		}
		
		private function onSubsResponseFB(boughtID:String):void {
			if(boughtID!=null && boughtID!="") {
				this.gotoAndStop(14);
				var player:MyPlayer = Player.current as MyPlayer;
				player.compras.push(boughtID);
				player.compras.push("premium");
				continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			} else {
				onClose();
			}
		}
		
		public function showPremiumCombo():void {
			this.gotoAndStop(12);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(coinsPremium.text);
			player.nrMPCoins += Number(fichasPremium.text);
			player.saveQueued();
		}
		
		public function inviteResults(effectiveInvites:Array):void {
			this.gotoAndStop(17);
			fillText(this.currentFrame);
			
			//Guarda que amigos o cara chamou dessa vez
			var player:MyPlayer = Player.current as MyPlayer;
			for each(var invite:String in effectiveInvites) {
				player.friends.push(["invited", invite]);
			}
			
			//Força, se chegaram mais de 10 amigos, a ser apenas o prêmio de 10
			var invitesNumber:Number = effectiveInvites.length > 10 ? 10 : effectiveInvites.length;
			
			//Calcula progresso na barra
			var inviteBarFrame:Number = 1 + invitesNumber;
			this["inviteBar"].gotoAndStop(inviteBarFrame);
			
			//Dá os prêmios (moedas e premium)
			player.nrCoins += 250*invitesNumber;
			this["effectiveInvitesTxt"].text = invitesNumber;
			this["effectiveReward"].text = (250*invitesNumber).toString();
			if(this["inviteBar"].currentFrame==11) {
				this["friendsRemaining"].text = "";
				this["friendsRemainingTxt"].text = "Premium!";
				this["invitesRelative"].text = "10/10";
				player.compras.push("premium");
				player.compras.push("expiry30plus: "+new Date());
			} else {
				this["friendsRemaining"].text = (10-invitesNumber).toString();
				this["invitesRelative"].text = (invitesNumber).toString()+"/10";
			}
			
			//Checa se mostra ehPremium ou não
			var jaEhPremium = false;
			for each(var compra:String in player.compras) {
				if(compra.indexOf("expiry30plus")>=0) {
					jaEhPremium = true;
					break;
				}
			}
			this["ehPremium"].visible = jaEhPremium;
			
			//Registra no mixpanel
			mixpanel.track(MP_EVT.TROUXE_AMIGO, {
				'Jogador': player.username,
				'Trouxe quantos': effectiveInvites.length,
				'Chegou a 10': this["inviteBar"].currentFrame==11
			});
			
			//Grava
			player.saveQueued();
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
		}
		
		public function rankingResult(rankingPos:Number):void {
			this.gotoAndStop(19);
			var player:MyPlayer = Player.current as MyPlayer;
			fillText(this.currentFrame);
			if(rankingPos>10 && rankingPos<=50) {
				this["promoCode"].text = "50";
			} else if(rankingPos<=10) {
				this["promoCode"].text = "500";				
			}
			this["rankingTxt"].text = rankingPos.toString();
			player.nrCoins += Number(this["promoCode"].text);
			player.saveQueued();
			continueBtn.addEventListener(MouseEvent.CLICK, onBuyPremium);
		}

		public function showThreeStarsExplanation(musicName:String, numLacunas:int):void {
			this.gotoAndStop(20);
			fillText(this.currentFrame);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			this["musicName"].text = musicName;
			var auxTotalWithCombo:Number = PlayScreenController.totalPoinsWithCombo(numLacunas);
			var minimumAccuracy:Number = Math.round(0.95*(5*(numLacunas)+auxTotalWithCombo));
			this["pointsNecessary"].text = minimumAccuracy.toString();
		}
		
		public function showExplanation(texto:String):void {
			this.gotoAndStop(21);
			continueBtn.addEventListener(MouseEvent.CLICK, onExit);
			this["explanationText"].text = texto;	
		}
		
		private function fillText(cf:int):void {
			if(cf==1) {
				this["resultadoTxt"].text = FeelMusic._("Match Result");
				this["seuPremio"].text = FeelMusic._("Your Prize");
			} else if(cf==2) {
				this["dailyBonus"].text = FeelMusic._("Daily Bonus");
			} else if(cf==3) {
				this["coinTokenTxt"].text = FeelMusic._("coinTokenTxt");
			} else if(cf==4) {
				this["tokenCoinTxt"].text = FeelMusic._("tokenCoinTxt");
			} else if(cf==5) {
				this["levelUpTxt"].text = FeelMusic._("I leveled up!");
			} else if(cf==6) {
				this["chooseStyleTxt"].text = FeelMusic._("chooseStyleTxt");
			} else if(cf==7) {
				this["masteredWordTxt"].text = FeelMusic._("masteredWordTxt");
			} else if(cf==8 || cf==13) {
				this["lojinhaTxt"].text = FeelMusic._("lojinhaTxt");					
			} else if(cf==10) {
				this["inviteFriendError"].text = FeelMusic._("inviteFriendError");
			} else if(cf==11) {
				this["assinaturaHead"].text = FeelMusic._("assinaturaHead");
				for(var i:int=1; i<7; i++) {
					this["assinatura"+i].text = FeelMusic._("assinatura"+i);
				}
				this["assinaturaPromo"].text = FeelMusic._("assinaturaPromo");
			} else if(cf==12) {
				this["dailyComboPremium"].text = FeelMusic._("Premium Daily Bonus:");
			} else if(cf==16) {
				this["inviteFriendsTxt"].text = FeelMusic._("inviteFriendsTxt");
				this["oneMonthPremium"].text = FeelMusic._("oneMonthPremium");
			} else if(cf==17) {
				this["inviteFriendsResultsTxt"].text = FeelMusic._("inviteFriendsResultsTxt");
				this["friendsRemainingTxt"].text = FeelMusic._("friendsRemainingTxt");
			} else if(cf==18) {
				this["inviteFriendSuccess"].text = FeelMusic._("inviteFriendSuccess");
			} else if(cf==19) {
				this["rankingResult1Txt"].text = FeelMusic._("rankingResult1Txt");
				this["rankingResult2Txt"].text = FeelMusic._("rankingResult2Txt");
			} else if(cf==20) {
				this["threeStarsTxt1"].text = FeelMusic._("threeStarsTxt1");
				this["threeStarsTxt2"].text = FeelMusic._("threeStarsTxt2");
			}
		}
		
	}	
}