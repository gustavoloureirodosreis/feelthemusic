package  {
	
	import com.gamua.flox.Entity;
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenMax;
	import com.mixpanel.Mixpanel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import auxiliares.PlayScreenController;
	import auxiliares.Settings;
	
	import enums.MP_EVT;
	
	import flox_entities.BrokenSongs;
	import flox_entities.Invites;
	import flox_entities.MyPlayer;
	
	
	public class LoadingScreen extends MovieClip {
		//Variáveis já no MC:
		public var disco:MovieClip;
		public var gameTitle:MovieClip;
		public var tutorialMsgs:MovieClip;
		//No frame 3
		public var prize:MovieClip;
		
		//Mixpanel
		private var mixpanel:Mixpanel;
		
		//Outras variáveis
		private var artista:String;
		private var musica:String;
		private var musicID:String;
		
		public function LoadingScreen() {
			glowDisc();
			if(FeelMusic.loadedTranslations) {
				tutorialMsgs.gotoAndStop(Math.floor(Math.random()*31+1));
				
				if(tutorialMsgs.currentFrame==31) {
					tutorialMsgs["okBtn"].addEventListener(MouseEvent.CLICK, function():void {
						navigateToURL(new URLRequest("https://www.backpacker.com.br/curso-ingles-com-musica"));
					});
				}
				
				fillTextTutorialMsg(tutorialMsgs.currentFrame);
				setTimeout(changeMessage, 5000);
			} else {
				tutorialMsgs.visible = false;
				gameTitle.visible = true;
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function setMusica(musicaGlobal:String):void {
			artista = musicaGlobal.split(" - ")[0];
			musica = musicaGlobal.split(" - ")[1];
			musicID = PlayScreenController.getMusicId(musicaGlobal);
		}
		
		private function onEnterFrame(event:Event):void {
			if(this.currentFrame==3) {
				prize.addEventListener(MouseEvent.CLICK, onClickPrize);	
				prize.mouseChildren = false;
				prize.buttonMode = true;
			}
		}
		
		private function onClickPrize(event:MouseEvent):void {
			//Some com o botão
			prize.visible = false;
			
			//Grava no mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			mixpanel.track(MP_EVT.MUSICA_QUEBRADA, {
				'Artista': artista,
				'Musica': musica
			});

			//Dá as moedas pro jogador
			var player:MyPlayer = Player.current as MyPlayer;
			player.nrCoins += Number(prize["price"].text);
			player.save(function onComplete():void {

				//Atualiza Entity de musicas quebradas pra evitar que o cara consiga moeda de novo
				var brokenId:String = "curr-broken";
				Entity.load(BrokenSongs, brokenId,
					function onComplete(broken:BrokenSongs):void {
						
						broken.currBroken.push(musicID);
						broken.save(function onComplete():void {
							//Toca o som de prêmio
							var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
							cashRegisterSFX.play(2000);
											
							//'Recarrega' a pagina
							navigateToURL(new URLRequest("www.backpacker.com.br/playFTMLogado"), "_self");
						}, function onError():void { "Erro gravando nova entry em curr-broken"; });
					},
					function onError(error:String, httpStatus:int):void {
						trace("Erro: "+error+" HttpStatus: "+httpStatus.toString());
					}
				);
			}, function onError():void { trace("Erro dando moedas pelo prêmio!"); } );
			
			
		}
		
		private function glowDisc():void {
			var random:Number = Math.floor(Math.random()*16777216);
			if(disco!=null) {
				TweenMax.to(disco, 0.2, {glowFilter: {blurX:25, blurY:25, alpha:1,
				color:random}});
			}
			setTimeout(glowDisc, 750);
		}
		
		private function changeMessage():void {
			//Só existe tutorialMsgs no primeiro frame
			if(this.currentFrame==1) {
				tutorialMsgs.gotoAndStop(Math.floor(Math.random()*30+1)); //Do 1 ao 30
				fillTextTutorialMsg(tutorialMsgs.currentFrame);
				setTimeout(changeMessage, 5000);
			}
		}
		
		private function fillTextTutorialMsg(currFrame:int):void {
			if(tutorialMsgs["loadingTxt"+currFrame]!=null) {
				tutorialMsgs["loadingTxt"+currFrame].text = FeelMusic._("loadingTxt"+currFrame);
			}
			if(tutorialMsgs["loadingTxt"+currFrame+"sub1"]!=null) {
				tutorialMsgs["loadingTxt"+currFrame+"sub1"].text = FeelMusic._("loadingTxt"+currFrame+"sub1");
			}
			if(tutorialMsgs["loadingTxt"+currFrame+"sub2"]!=null) {
				tutorialMsgs["loadingTxt"+currFrame+"sub2"].text = FeelMusic._("loadingTxt"+currFrame+"sub2");				
			}
		}
		
		public function fillText(cf:int):void {
			this["loadingError"+(cf-1)].text = FeelMusic._("loadingError"+(cf-1));			
		}
	}
	
}
