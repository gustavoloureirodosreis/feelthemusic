package  {
	
	import auxiliares.NavigationEvent;
	
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class CreateLoginScreen extends MovieClip {
		//Variáveis já no MC:
		public var vantagem1:TextField;
		public var vantagem2:TextField;
		public var vantagem3:MovieClip;
		public var cadastroTxt:TextField;
		public var opcaoNao:SimpleButton;
		public var opcaoSim:SimpleButton;
		
		//Outras variáveis:
		public var bringStuffSFX:BringStuffSFX = new BringStuffSFX();
		public var sexo:String;
		public var idade:String;
		public var nivel:String;
		public var jaFoiSexo:Boolean = false;
		public var jaFoiIdade:Boolean = false;
		public var jaFoiNivel:Boolean = false;
		
		public function CreateLoginScreen() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		protected function onAddedToStage(event:Event):void {
			bringStuffSFX.play();
			opcaoNao.alpha = 0;
			opcaoNao.addEventListener(MouseEvent.CLICK, onNoLogin);
			opcaoSim.alpha = 0;
			opcaoSim.addEventListener(MouseEvent.CLICK, onYesLogin);
			vantagem1.alpha = 0;
			vantagem2.alpha = 0;
			vantagem3.alpha = 0;
			cadastroTxt.alpha = 0;
			fillTexts();
			setTimeout(showVantagem1, 1000);
		}
		
		private function fillTexts():void {
			this["cadastroPreTxt"].text = FeelMusic._("cadastroPreTxt");
			this["cadastroMsg"].text = FeelMusic._("cadastroMsg");
			cadastroTxt.text = FeelMusic._("cadastroTxt");
			vantagem1.text = FeelMusic._("vantagem1");
			vantagem2.text = FeelMusic._("vantagem2");
			vantagem3["vantagem3"].text = FeelMusic._("vantagem3");
		}
		
		private function showVantagem1():void {
			bringStuffSFX.play();
			TweenLite.to(vantagem1, 1, {alpha:1, onComplete:showVantagem2}); 
		}
				
		private function showVantagem2():void {
			bringStuffSFX.play();
			TweenLite.to(vantagem2, 1, {alpha:1, onComplete:showVantagem3}); 
		}
		
		private function showVantagem3():void {
			bringStuffSFX.play();
			TweenLite.to(vantagem3, 1, {alpha:1, onComplete:showCadastroTxt}); 
		}			
				
		private function showCadastroTxt():void {
			cadastroTxt.alpha = 1;
			opcaoNao.alpha = 1;
			opcaoSim.alpha = 1;
		}
		
		protected function onYesLogin(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.MAKELOGIN));
		}
		
		protected function onNoLogin(event:MouseEvent):void {
			dispatchEvent(new NavigationEvent(NavigationEvent.DONTMAKELOGIN));			
		}
	}	
}
