package auxiliares {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	
	
	public class QuestLabel extends MovieClip {
		//Variáveis já no MC	
		public var questExpressoes:SimpleButton;
		public var questMusicas:SimpleButton;
		public var meta:TextField;
		public var progressTxt:TextField;
		public var progress:MovieClip;
		public var content:MovieClip;
		public var closeBtn:SimpleButton;
		
		//Outras variáveis
		public var btnPressedSFX:BtnPressedSFX = new BtnPressedSFX();
		public var parentMC:MovieClip;
		
		public function QuestLabel() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void {
			content["closeBtn"].addEventListener(MouseEvent.CLICK, onCloseContent);
			content["upBtn"].addEventListener(MouseEvent.CLICK, onUpContent);
			content["downBtn"].addEventListener(MouseEvent.CLICK, onDownContent);
			questExpressoes.addEventListener(MouseEvent.CLICK, onShowExpressoes);
			questMusicas.addEventListener(MouseEvent.CLICK, onShowMusicas);
		}
		
		protected function onShowMusicas(event:MouseEvent):void {
			btnPressedSFX.play(0,0,new SoundTransform(0.2));
			content.visible = true;
			content["conteudo"].text = "Melhores músicas pro tema: \n";
			for each(var tema:Object in WordShuffler.themes) {
				if(tema.name==meta.text) {
					for each(var pair:Array in tema.musics) {
						for each(var quintuple:Array in FeelMusic.musicIDsArray) {
							if(quintuple[2]==pair[0]){
								content["conteudo"].text += quintuple[4].split("(")[0]+"\n";
								break;
							}
						}
					}
				}
			}
			//Tira o ultimo " -- "
			content["conteudo"].text = content["conteudo"].text.substr(0,content["conteudo"].text.length-4);
		}
		
		protected function onShowExpressoes(event:MouseEvent):void {
			btnPressedSFX.play(0,0,new SoundTransform(0.2));
			content.visible = true;	
			
			content["conteudo"].text = "Expressoes do tema: \n"; 
			for each(var tema:Object in WordShuffler.themes) {
				if(tema.name==meta.text) {
					for each(var word:String in tema.content) {
						content["conteudo"].text += word+" -- ";
					}
					break;
				}
			}
			//Tira o ultimo " -- "
			content["conteudo"].text = content["conteudo"].text.substr(0,content["conteudo"].text.length-4);
		}
		
		protected function onUpContent(event:MouseEvent):void {
			content["conteudo"].y += 90;
		}
		
		protected function onDownContent(event:MouseEvent):void {
			content["conteudo"].y -= 90;
		}
		
		public function blockThis(parentMCout:MovieClip):void {
			parentMC = parentMCout;
			this.gotoAndStop(4);
			this["premiumBtn"].addEventListener(MouseEvent.CLICK, showPremium);
		}
		
		protected function showPremium(event:MouseEvent):void {
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(parentMC);
			popUp.showPremiumProposal();
		}
		
		protected function onCloseContent(event:MouseEvent):void {
			content.visible = false;			
		}
		
	}	
}
