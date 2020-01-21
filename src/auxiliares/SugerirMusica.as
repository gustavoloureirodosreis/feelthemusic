package auxiliares {
	
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.xml.*;
	
	import flox_entities.MyPlayer;
	
	public class SugerirMusica extends MovieClip {
		//Variáveis já nele:
		public var discoGirando:MovieClip;
		public var textoDeEntrada:MovieClip;
		public var mensagemSugestao:MovieClip;
		
		public var xmlData:XML = new XML();
		public var myLoader:URLLoader = new URLLoader();
		
		public function SugerirMusica() { 
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
		}
		
		protected function onAddedToStage(event:Event):void {
			buttonMode = true;
			discoGirando.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSugestion);
			discoGirando.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutSugestion);
			discoGirando.addEventListener(MouseEvent.CLICK, onMouseClickSugestion);									
		}

		public function onMouseOverSugestion(e:MouseEvent){
			mensagemSugestao.visible = true;
		}

		public function onMouseClickSugestion(e:MouseEvent){
			if(!textoDeEntrada.visible) {
				discoGirando.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverSugestion);
				mensagemSugestao.visible = false;
				textoDeEntrada.visible = true;
				textoDeEntrada["texto"].border = true;
				textoDeEntrada["texto"].borderColor = 0xFFFFFF;
				textoDeEntrada["texto"].text = "Escreva aqui sua sugestão"
				textoDeEntrada.addEventListener(MouseEvent.CLICK, onClickSugestionBox);
			} else if(textoDeEntrada["texto"].text=="" || textoDeEntrada["texto"].text=="Escreva aqui sua sugestão") {
				discoGirando.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSugestion);
				mensagemSugestao.visible = true;
				textoDeEntrada.visible = false;
				textoDeEntrada.removeEventListener(MouseEvent.CLICK, onClickSugestionBox);	
			}
		}

		public function onClickSugestionBox(e:MouseEvent){
			textoDeEntrada["texto"].text = "";
			textoDeEntrada.addEventListener(KeyboardEvent.KEY_DOWN, onSugestMusics);
		}

		public function onSugestMusics(event:KeyboardEvent){
			if(event.charCode == 13){ //Enter
				var str:String = textoDeEntrada["texto"].text; 
				var player:MyPlayer = Player.current as MyPlayer;
				if(player.sugestions == null) {
					player.sugestions = new Array();
				} 
				player.sugestions.push(str);
				player.saveQueued();
				textoDeEntrada.visible = false;
				mensagemSugestao.texto.text = "Sugestão enviada!";
				mensagemSugestao.visible = true;	

				//Espera um tempo antes de permitir outras sugestões
				setTimeout(restoreSugestion, 2000);
			}
		}
		
		private function restoreSugestion():void {
			mensagemSugestao.visible = false;
			mensagemSugestao.texto.text = "Sugira uma música";
			discoGirando.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverSugestion);
			discoGirando.addEventListener(MouseEvent.CLICK, onMouseClickSugestion);												
		}
		
		public function onMouseOutSugestion(e:MouseEvent){
			mensagemSugestao.visible = false;			
		}
		
	}
	
}
