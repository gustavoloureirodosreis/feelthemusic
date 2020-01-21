package multiplayer  {
	
	import auxiliares.NavigationEvent;
	import auxiliares.PopUp;
	
	import com.gamua.flox.Player;
	import com.gamua.flox.Query;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.plugins.*;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	
	import flox_entities.GameMatch;
	import flox_entities.MyPlayer;
	
	
	public class ChooseBetStyleScreen extends MovieClip {
		//Variáveis já no MC
		public var pianoTum:PianoTumSFX = new PianoTumSFX();
		public var wrongSFX:WrongSoundSFX = new WrongSoundSFX();
		public var cashRegisterSFX:CashRegisterSFX = new CashRegisterSFX();
		public var currBet:MovieClip
		public var popUp:PopUp;
		public var currentEstilo:TextField;
		public var nextBet:SimpleButton;
		public var backBet:SimpleButton;
		public var continuarBtn:SimpleButton;
		
		//Outras variáveis
		public var menuEstilos:MenuEstilos = new MenuEstilos();
		public var menuMPmusicScreen:MenuMPmusicScreen;
		public var chosenMatch:GameMatch;
		public var parentGlobal:MovieClip;
		public var estilosArray:Array = new Array();
		public var friendsArray:Array = new Array();
		public var easyMatches:Array = new Array();
		public var mediumMatches:Array = new Array();
		public var hardMatches:Array = new Array();
		public var veryHardMatches:Array = new Array();
		public var extremeMatches:Array = new Array();
		public var popUps:Array = new Array();
		public var lidandoComDiff:String = "";
		public var previouslyDefReceiver:String = "";
		public var pointerEstilo:Number = 1;
		public var styleFloor:Number = 0;
		public var temEasies:Boolean;
		public var temMediums:Boolean;
		public var temHards:Boolean;
		public var temVeryHards:Boolean;
		public var temExtremes:Boolean;
		
		public static var namesList:Array = ["John", "Jacob", "Alice", "Johnny", "Pedro", "Peter", "Mario",
										"Tyler Dur", "Joker", "Jack", "Maria", "João", "Paul", "Raquel",
										"Gustavo", "Bruno", "Aline", "Raissa", "Amanda", "Tati", "Mandy",
										"Guns", "Junior", "Joseph"];
		
		public function ChooseBetStyleScreen(parent:MovieClip) {
			parentGlobal = parent;			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}		
				
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this["chooseBetTxt"].text = FeelMusic._("chooseBetTxt");
			
			//Inicializa variáveis pertinentes a classe inteira
			popUp = new PopUp();			
			estilosArray = FeelMusic.artistas; 
		
			//Listeners nos botões
			continuarBtn.addEventListener(MouseEvent.CLICK, onChoseBet);
			nextBet.addEventListener(MouseEvent.CLICK, function() { changeStyle(1); });
			backBet.addEventListener(MouseEvent.CLICK, function() { changeStyle(-1); });

		}
		
		private function changeStyle(increase:int):void {
			var nextFrame:int = currBet.currentFrame+increase;
			if(nextFrame==0) { nextFrame = 5; }
			else if(nextFrame==6) { nextFrame = 1; }
			currBet.gotoAndStop(nextFrame);
			checkCanBet();
		}
		
		private function checkCanBet():void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.nrMPCoins<Number(currBet.tax.text)) {
				continuarBtn.visible = false;
			} else {
				continuarBtn.visible = true;
			}
		}
		
		protected function onChoseBet(event:MouseEvent):void {
			var amount = Number(currBet.tax.text);
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.nrMPCoins>=amount) {
				player.nrMPCoins -= amount;
				player.save(
					function onComplete(){dispatchEvent(new NavigationEvent(NavigationEvent.UPDATECOINS));},
					function onError(message:String) {});
				cashRegisterSFX.play(2000);
				lidandoComDiff = currBet.tax.text;
				createMatch();
			} else {
				wrongSFX.play(1000,0,new SoundTransform(0.2));
				TweenLite.to(event.currentTarget, 0.2, {blurFilter:{blurX:20, remove:true}});		
			}
		}
						
		private function createMatch():void {
			menuEstilos.x = 1460;
			menuEstilos.addEventListener(Event.REMOVED_FROM_STAGE, onCriarMatch);
			
			popUp.showChooseMultiStyle();
			popUp.bringPopUp(this);
			popUp.addEventListener(NavigationEvent.MULTIRANDOM, onContinueMatchCreation);
			popUp.addEventListener(NavigationEvent.MULTIFRIEND, onContinueMatchCreation);
			this.addChild(popUp);
		}				
		
		public var ehBot:Boolean = false;
		public var friendSelected:String = "";
		protected function onContinueMatchCreation(event:NavigationEvent):void {
			if(event.data!=null) { 
				friendSelected = event.data.friendName;
			} else {
				ehBot = true;
				var numbers:Array = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "11", "13", "19", "20"];
				friendSelected = namesList[Math.floor(Math.random()*namesList.length)]+
				numbers[Math.floor(Math.random()*numbers.length)];
			}
			menuEstilos.chooseMenuStyle.gotoAndStop(5);
			menuEstilos.chooseMenuStyle["estiloDesafioTxt"].text = FeelMusic._("estiloDesafioTxt");
			menuEstilos.setMultiplayer(true);
			menuEstilos.setOrdenacao(3);
			this.addChild(menuEstilos);
			parent["backMenu"].visible = false;
			TweenLite.to(this, 0.3, {x:-1460, ease:Back.easeIn});					
		}
		
		protected function onCriarMatch(event:Event):void {
			pianoTum.play(100,0,new SoundTransform(0.9));
			
			var player:MyPlayer = Player.current as MyPlayer;
			chosenMatch = new GameMatch();
			chosenMatch._sender = player.username;
			chosenMatch._receiver = friendSelected;
			chosenMatch._dateCreated = new Date();
			chosenMatch._betType = lidandoComDiff;
			
			if(!ehBot) {
				chosenMatch._jaJogouRecEJaViuSender = "falsefalse";
			} else {
				chosenMatch._jaJogouRecEJaViuSender = "bot";
			}
			
			//Mandar pra nova tela
			menuMPmusicScreen = new MenuMPmusicScreen(chosenMatch, menuEstilos.tresMusicas);
			addChild(menuMPmusicScreen);
			menuMPmusicScreen.x = 2920; menuMPmusicScreen.y = 200;
			TweenLite.to(this, 0.5, {x:-2920, ease:Back.easeIn, onComplete:bringMenuMPmusicas});
			function bringMenuMPmusicas():void {
				TweenLite.to(menuMPmusicScreen, 0.5, {x:2920, ease:Back.easeIn});
			}
			menuMPmusicScreen.addEventListener(Event.REMOVED_FROM_STAGE, function(){onChoseMusic(chosenMatch);});			
		}
				
		protected function onChoseMusic(match:GameMatch):void {
			menuMPmusicScreen.removeEventListener(Event.REMOVED_FROM_STAGE, function(){onChoseMusic(chosenMatch);});
			
			//Agora o match tá atualizado com a música selecionada
			chosenMatch = match;
			dispatchEvent(new NavigationEvent(NavigationEvent.STARTMP));
		}
			
	}
}