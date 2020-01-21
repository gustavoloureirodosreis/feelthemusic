package auxiliares
{
	
	import com.gamua.flox.Player;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flox_entities.MyPlayer;
	
	public class JanelaAprendizado extends MovieClip {
		
		//Variáveis no MC
		public var questsAtuais:MovieClip;
		public var questsTodas:MovieClip;
		public var questsHolder:MovieClip;
		public var musicaSugeridaBtn:SimpleButton;
		public var musicaSugeridaBlock:SimpleButton;
		public var backMenu:SimpleButton;
		
		public function JanelaAprendizado() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			fillText(this.currentFrame);
			setTimes();
			setExpressions();
			setAcertos();
			setListeners();
			setQuestsAtuais();
		}
		
		private function fillText(cf:int):void {
			if(cf==1) {
				this["myProgressTxt"].text = FeelMusic._("myProgressTxt");
				this["timeTxt"].text = FeelMusic._("timeTxt");
				this["lacunasRelTxt"].text = FeelMusic._("lacunasRelTxt");
				this["lacunasAbsTxt"].text = FeelMusic._("lacunasAbsTxt");
				this["expressoesTxt"].text = FeelMusic._("expressoesTxt");
			}
		}
		
		public function setTimes():void {
			var player:MyPlayer = Player.current as MyPlayer;
			this["seconds"].text = (player.tempoTotal%60).toString()+"s";
			this["minutes"].text = (Math.floor(player.tempoTotal/60)%60).toString()+"m";
			this["hours"].text = (Math.floor(player.tempoTotal/3600)).toString()+"h";
		}
		
		public function setExpressions():void {
			var player:MyPlayer = Player.current as MyPlayer;
			this["expressoesAmnt"].text = player.expressAcertadas.length;
		}
		
		private function setAcertos():void {
			var player:MyPlayer = Player.current as MyPlayer;
			this["acertosAbsoluto"].text = (player.itens[0]+player.itens[2]+player.itens[4]).toString()+
			"/"+(player.itens[1]+player.itens[3]+player.itens[5]).toString();
			if(player.itens[1]+player.itens[3]+player.itens[5]==0) {
				this["acertosRelativo"].text = "0%";
			} else {
				this["acertosRelativo"].text = Math.round(100*(player.itens[0]+player.itens[2]+player.itens[4])
				/(player.itens[1]+player.itens[3]+player.itens[5])).toString()+"%";
			}
		}
		
		private function setListeners():void {
			//Vê se mostra o bloqueio de musica sugerida ou não
			var player:MyPlayer = Player.current as MyPlayer;
			musicaSugeridaBlock.visible = false;
			if(player.itens[6]<=0 && player.compras.indexOf("premium")==-1) {
				musicaSugeridaBlock.visible=true;
				musicaSugeridaBlock.alpha=0;
				TweenLite.to(musicaSugeridaBlock, 0.75, {delay:1, alpha:1});					
			}
			
			questsAtuais.mouseChildren = false;
			questsTodas.mouseChildren = false;
			questsAtuais.buttonMode = true;
			questsTodas.buttonMode = true;
			questsTodas.gotoAndStop(4);
			questsAtuais["currQuestsTxt"].text = FeelMusic._("currQuestsTxt");
			questsTodas["allQuestsTxt"].text = FeelMusic._("allQuestsTxt");
			questsTodas.addEventListener(MouseEvent.CLICK, onShowTodasQuests);
			musicaSugeridaBtn.addEventListener(MouseEvent.CLICK, onPlayMusicaSugerida);
			musicaSugeridaBlock.addEventListener(MouseEvent.CLICK, onShowPremium);
			backMenu.addEventListener(MouseEvent.CLICK, onCloseThis);			
		}
		
		private function setQuestsAtuais():void {
			var player:MyPlayer = Player.current as MyPlayer;
			var questIndex:int = 1;
			for each(var trice3:Array in player.achievements) {
				if(questIndex>=4) { break; }
				if(trice3[2]<100) {
					questsHolder["quest"+questIndex].meta.text = trice3[0];
					questsHolder["quest"+questIndex].progressTxt.text = (trice3[1]>trice3[2] ? trice3[1] : trice3[2])+"%";
					questsHolder["quest"+questIndex].progress.fill.x += Number(questsHolder["quest"+questIndex].progressTxt.
					text.substr(0,questsHolder["quest"+questIndex].progressTxt.text.length-1))*1.25;
					questIndex++;
				}
			}
		}
		
		private function setTodasQuests():void {
			var player:MyPlayer = Player.current as MyPlayer;
			questsHolder["botaoUp"].addEventListener(MouseEvent.CLICK, onUpContent);
			questsHolder["botaoDown"].addEventListener(MouseEvent.CLICK, onDownContent);
			var currHeight:Number = 0;
			for each(var trice3:Array in player.achievements) {
				var newQuest:QuestLabel = new QuestLabel();
				newQuest.scaleX = 0.8;
				newQuest.scaleY = 0.8;
				questsHolder["listaHolder"].addChild(newQuest);
				newQuest.y = currHeight;
				currHeight += 85;
				newQuest["meta"].text = trice3[0];
				newQuest["progressTxt"].text =(trice3[1]>trice3[2] ? trice3[1] : trice3[2])+"%";
				newQuest["progress"].fill.x += 
				Number(newQuest["progressTxt"].text.substr(0,newQuest["progressTxt"].text.length-1))*1.25;
				if(Number(newQuest["progressTxt"].text.substr(0,newQuest["progressTxt"].text.length-1))>=100) {
					newQuest.gotoAndStop(2);
					newQuest["raio"].visible = false;
				}
			}
		}

		protected function onUpContent(event:MouseEvent):void {
			questsHolder["listaHolder"].y += 85;
		}
		
		protected function onDownContent(event:MouseEvent):void {
			questsHolder["listaHolder"].y -= 85;
		}
		
		protected function onShowPremium(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showPremiumProposal();			
		}
		
		protected function onPlayMusicaSugerida(event:MouseEvent):void {
			//Sai da frente
			onCloseThis(null);
			
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
		
		protected function onShowTodasQuests(event:MouseEvent):void {
			questsTodas.gotoAndStop(3);
			questsAtuais.gotoAndStop(2);
			questsAtuais.addEventListener(MouseEvent.CLICK, onShowQuestsAtuais);
			
			//Mostra todas quests
			questsHolder.gotoAndStop(2);
			setTodasQuests();
		}
				
		protected function onShowQuestsAtuais(event:MouseEvent):void {
			questsTodas.gotoAndStop(4);
			questsAtuais.gotoAndStop(1);
			questsTodas.addEventListener(MouseEvent.CLICK, onShowTodasQuests);
			
			//Mostra quests atuais
			questsHolder.gotoAndStop(1);
			setQuestsAtuais();
		}
		
		protected function onCloseThis(event:MouseEvent):void {
			TweenLite.to(this, 0.33, {x:385, y:-125, scaleX:0.2, scaleY:0.2});
		}
	}
}