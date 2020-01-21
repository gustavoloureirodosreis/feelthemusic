package auxiliares {
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class IntroSongMasterScreen extends MovieClip {
		//Variávies já no MC
		public var welcomeSongMaster:TextField;
		public var currProgressTXT:TextField;
		public var progressPercentage:TextField;
		public var musicName:TextField;
		public var songMasterInfoBtn:SimpleButton;
		public var progressInfoBtn:SimpleButton;
		public var jogarBtn:SimpleButton;
		
		//Outras variáveis
		public var musicWordsToMaster = new Array();
		public var musicMasteredWords:Array = new Array();
		public var musicNameString:String;
		
		public function IntroSongMasterScreen() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setMusicName(musicGlobal:String):void {
			musicNameString = musicGlobal;
		}
		
		protected function onAddedToStage(event:Event):void {
			//Checa se o cara é guest
			if(FeelMusic.ehGuest) {
				var popUp:PopUp = new PopUp();
				popUp.bringPopUp(this);
				//parentMC só pode ser startScreen
				var explanationText:String = "\nATENÇÃO!\n\n"+
					"Aparentemente você tentou abrir um link para mestrar uma música sem estar logado no jogo!\n"+
					"Feche esta janela para conhecer o jogo como visitante. Para jogar a música que lhe trouxe aqui, "+
					"efetue o login e clique no link novamente.\n\n\n" +
					"Att,\n"+
					"Equipe Backpacker";
				popUp.showExplanation(explanationText);
			}
			
			//Preenche os textos (TODO)
			//welcomeSongMaster.text = FeelMusic._("WelcomeSongMaster");
			//currProgressTXT.text = FeelMusic._("CurrProgressTXT");
			
			//Coloca os listeners nos botões
			songMasterInfoBtn.addEventListener(MouseEvent.CLICK, onSongMasterInfo);
			progressInfoBtn.addEventListener(MouseEvent.CLICK, onProgressInfo);
			
			//Descobre quantos % se tem da música já
			var progressPercent:Array = PlayScreenController.getProgPercentage();
			//Não permite começar já com 100%
			if(progressPercent[1]==100) {
				progressPercent[1] = 99;
			}
			musicMasteredWords = progressPercent[0];
			musicWordsToMaster = progressPercent[2];
			
			//Preenche o carregamento da barra e últimos textos
			TweenLite.to(this["progress"].fill, 1, {x:this["progress"].fill.x+progressPercent[1]*1.25});
			progressPercentage.text = progressPercent[1].toString()+"%";
			musicName.text = musicNameString;
			
			//Coloca o listener de retirar da tela
			jogarBtn.addEventListener(MouseEvent.CLICK, onRemoveThis);
		}
		
		protected function onRemoveThis(event:MouseEvent):void {
			parent.removeChild(this);			
		}
		
		protected function onProgressInfo(event:MouseEvent):void {
			var texto:String = "\nPalavras da música já aprendidas: \n";
			for each(var palavraMestrada:String in musicMasteredWords) {
				texto += palavraMestrada+"  |  ";
			}
			texto += "\n\n Palavras da música que faltam aprender: \n"; 
			for each(var palavraAmestrar:String in musicWordsToMaster) {
				texto += palavraAmestrar+"  |  ";
				if(musicWordsToMaster.indexOf(palavraAmestrar)>=20) {
					texto += "...";
					break;
				}
			}
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showExplanation(texto);
		}
		
		protected function onSongMasterInfo(event:MouseEvent):void {
			var texto:String = "\n\n\nNesse modo de jogo você irá treinar as palavras de uma música até "+
				"ser considerado um SONG MASTER nela. \n"+
				"Isso significará que você já consegue entender muito bem o que está sendo cantado. \n"+
				"Parabéns! ;)";
			var popUp:PopUp = new PopUp();
			popUp.bringPopUp(this);
			popUp.showExplanation(texto);
		}
		
	}
	
}
