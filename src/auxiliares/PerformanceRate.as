package auxiliares  {
	
	import com.gamua.flox.Player;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import flox_entities.MyPlayer;
	
	
	public class PerformanceRate extends MovieClip {
		
		//Variáveis já no MC:
		public var medidor:MovieClip;	
		public var dancer:MovieClip;
		public var mascBtn:SimpleButton;
		public var femBtn:SimpleButton;
		
		//Outras:
		public var sexo:String = "F";
		public var visibleAntigo:Number = int.MAX_VALUE;
		
		public function PerformanceRate() {
			mascBtn.addEventListener(MouseEvent.CLICK, onSwapMale);
			femBtn.addEventListener(MouseEvent.CLICK, onSwapFem);
			showCurrSex();
		}
		
		private function commonSwap():void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.sexo = sexo;
			player.saveQueued();
			showCurrSex();						
		}

		protected function onSwapMale(event:MouseEvent):void {
			sexo="M";
			commonSwap();
		}
		
		
		protected function onSwapFem(event:MouseEvent):void {
			sexo="F";
			commonSwap();
		}
		
		private function showCurrSex():void {
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.sexo!=null && player.sexo=="M" || player.sexo=="F") {
				sexo = player.sexo;	
			}
			if(sexo=="M") {
				dancer["mulher1"].visible = false;
				dancer["homem1"].visible = true;
			} else if(sexo=="F") {
				dancer["homem1"].visible = false;
				dancer["mulher1"].visible = true;
			}
		}
		
		public function setSexo(_sexo:String):void {
			sexo = _sexo;
			showCurrSex();
		}
		
		public function refresh(direction:Number):void {
			if(direction>0) {
				TweenLite.to(medidor["ponteiro"], 0.5, 
				{rotation:medidor["ponteiro"].rotation + (110 - medidor["ponteiro"].rotation)/7, onComplete:updateMedidor});
			} else {
				TweenLite.to(medidor["ponteiro"], 0.5, 
				{rotation:medidor["ponteiro"].rotation - (110 + medidor["ponteiro"].rotation)/5, onComplete:updateMedidor});
			}
		}
		
		public function updateMedidor():void {
			if(medidor["ponteiro"].rotation > -100 && medidor["ponteiro"].rotation <= -30) {	
				medidor.gotoAndStop(2);
			} else if(medidor["ponteiro"].rotation > -30 && medidor["ponteiro"].rotation <= 30) {
				medidor.gotoAndStop(3);
			} else if(medidor["ponteiro"].rotation > 30 && medidor["ponteiro"].rotation <= 100){
				medidor.gotoAndStop(4);
			}
			updateDancers();
		}
		
		public function updateDancers():void {
			if(medidor["ponteiro"].rotation <= -54) {
				makeDancerVisible(1);
			} else if (medidor["ponteiro"].rotation > -54 && 
					   medidor["ponteiro"].rotation <= -18) {
				makeDancerVisible(2);
			} else if (medidor["ponteiro"].rotation > -18 && 
				medidor["ponteiro"].rotation <= 18) {
				makeDancerVisible(3);
			} else if (medidor["ponteiro"].rotation > 18 && 
				medidor["ponteiro"].rotation <= 54) {
				makeDancerVisible(4);
			} else {
				makeDancerVisible(5);
			}	
		}
		
		private function makeDancerVisible(visible:int):void {
			var maleKeyFrames:Array = [1,16,37,102,135];
			var femaleKeyFrames:Array = [1,16,37,102,135];
			if(visible!=visibleAntigo) {
				visibleAntigo = visible;
				dancer["homem1"].gotoAndPlay(maleKeyFrames[visible-1]);
				dancer["mulher1"].gotoAndPlay(maleKeyFrames[visible-1]);
			}
		}
	}
}
