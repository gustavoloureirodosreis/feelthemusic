package auxiliares 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ProgressRate extends MovieClip {
		
		//Variáveis já no MC:
		public var filling:MovieClip;	
		public var barra:MovieClip
		public var estrela:MovieClip;
		
		//Outras:
		public var currentStarsNumber:Number=0;
		public var totalLacunas:Number = 0;
		public var pastAccuracy:Number = 0;
		
		public function ProgressRate() {
			filling.gotoAndStop(2);
			estrela["starsNumber"].text = "0";
		}
		
		public function refresh(currentAccuracy:Number):void{
			if(estrela["starsNumber"].text!="3") {
				if(currentAccuracy < 0.95) {
					var diffAccuracy = currentAccuracy - pastAccuracy;
		 			TweenLite.to(filling, 0.5, {x:filling.x + 3*barra.width*diffAccuracy, onComplete:checaSeUpou});
				} else {
					TweenLite.to(filling, 0.5, {x:barra.width-filling.width, onComplete:checaSeUpou});
				}
				pastAccuracy = currentAccuracy
			}
		}
		
		public function checaSeUpou():void{
			if(filling.x>=barra.width-filling.width) { 
				currentStarsNumber++;
				estrela["starsNumber"].text = currentStarsNumber.toString();
				
				if(estrela["starsNumber"].text!="3") {
					TweenLite.to(filling, 0.5, {x:filling.x-barra.width}); 
				}
				
				//Faz efeito quando sobe de nivel
				TweenLite.to(estrela, 0.5, {x:350, y:-25, ease:Back.easeOut, scaleX:2, scaleY:2,
					glowFilter:{color:0xFFD700, alpha:1, blurX:5, blurY:5, strength:8}, onComplete:estrelaBack});
			}
		}
		
		public function estrelaBack():void{
			TweenLite.to(estrela, 0.5, {x:113, y:-35, ease:Back.easeOut, scaleX:1, scaleY:1,
			glowFilter:{color:0xFFD700, alpha:1, blurX:1, blurY:1, strength:5, quality:3}, delay:0.66});
		}
	}
}