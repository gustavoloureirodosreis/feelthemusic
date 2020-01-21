package auxiliares  {
	
	import flash.display.MovieClip;
	
	
	public class TimeBar extends MovieClip {
		//Variáveis no MC:
		public var timeBarPointer:MovieClip;
		public var timeBarFill:MovieClip;
		
		//Outras variáveis:
		public var barWidth:Number = 500;
		public var totalDuration:Number = 0;
		
		public function TimeBar() { }
		
		public function setTime(duration:Number):void {
			totalDuration = duration;			
		}
		
		public function setBeginning(beginning:Number):void {
			timeBarPointer.x = (beginning/totalDuration)*barWidth;
		}
		
		public function refresh(currentTime:Number):void {
			timeBarFill.x = -500 + currentTime/totalDuration*barWidth;
		}
		
		public function refreshMP(currentTime:Number, yPoints:String, opPoints:String, pointerP1:MovieClip, pointerP2:MovieClip):void{
			refresh(currentTime);
			if(Number(yPoints)>=Number(opPoints)) {
				pointerP1.x = 220 + timeBarFill.x + timeBarFill.width;
				pointerP2.x = pointerP1.x - (Number(yPoints)-Number(opPoints))/50;
				if(pointerP2.x<220 || Number(opPoints)==0) { pointerP2.x = 220; }
			} else {
				pointerP2.x = 220 + timeBarFill.x + timeBarFill.width;
				pointerP1.x = pointerP2.x - (Number(opPoints)-Number(yPoints))/50;
				if(pointerP1.x<220 || Number(yPoints)==0) { pointerP1.x = 220; }
			}
		}
	}
}
