package auxiliares {
	
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.mixpanel.Mixpanel;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import enums.MP_EVT;
	
	import flox_entities.MyPlayer;
	
	
	public class LevelBar extends MovieClip {
		//Variáveis já no MovieClip
		public var msgExp:TextField;
		public var levelNumber:TextField;
		public var fill:MovieClip;
		public var barra:MovieClip;
		public var estrela:MovieClip;
		
		//Outras variáveis
		public var levelsXP:Array = [0, 10, 20, 21, 22, 23, 24, 25, 26, 30,
									33, 34, 35, 36, 37, 38, 39, 40, 45, 50,
									53, 56, 59, 62, 65, 68, 71, 74, 77, 80,
									83, 86, 89, 92, 95, 98, 101, 104, 107, 110,
									115, 120, 125, 130, 135, 140, 145, 150, 175, 200,
									210, 220, 230, 240, 250, 260, 270, 280, 290, 300,
									325, 350, 375, 400, 425, 450, 475, 500, 525, 550,
									600, 650, 700, 750, 800, 850, 900, 950, 1000, 1050,
									1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 10000, 100000, 
									150000, 200000, 250000, 300000, 350000, 400000, 450000, 500000, 550000, 600000,
									int.MAX_VALUE]; //Do nível 1 pro 2 precisa de '10'.
		public var playerLevel:int = 0;
		public var expRestante:int = 0;
		public var parentGlobal:MovieClip;
		
		// Mixpanel
		private var mixpanel:Mixpanel;
		
		public function LevelBar() { 
			// Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			msgExp.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER, onShowExp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onStopShowExp);
		}
		
		protected function onStopShowExp(event:MouseEvent):void {
			msgExp.visible = false;				
		}
		
		protected function onShowExp(event:MouseEvent):void {
			msgExp.visible = true;
			msgExp.text = expRestante.toString()+"/"+levelsXP[playerLevel].toString();
		}
		
		public function getPlayerLevel():int {
			calculateLevel();
			return playerLevel;
		}
		
		public function setPlayerLevel():void {
			calculateLevel();
			//Preenche o resto da barra com o que faltar pro próximo level
			TweenLite.to(fill, 0.5, {x:fill.x + barra.width*(expRestante/levelsXP[playerLevel])});			
		}
		
		private function calculateLevel():void {
			var player:MyPlayer = Player.current as MyPlayer;
			var exp:int = player.experience;
			playerLevel = 0;
			fill.x = barra.x - fill.width;
			for each(var minRequired:int in levelsXP) {
				if(exp >= minRequired) {
					exp -= minRequired;
					playerLevel++;
				}
			}
			levelNumber.text = playerLevel.toString();
			expRestante = exp;			
		}
		
		public function addXP(newXP:Number, parent:MovieClip, primeiraIteracao:Boolean):void {
			parentGlobal = parent;
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Grava a nova xp no player
			if(primeiraIteracao) {
				player.experience += newXP;
				player.saveQueued();
			} else { 
				newXP = 0; //Porque já tá na expRestante o que queremos 
			}
			
			var fillSE:FillLevelSE = new FillLevelSE();
			fillSE.play(0,0,null);
			if(expRestante+newXP >= levelsXP[playerLevel]) {	
				TweenLite.to(fill, 1, {x:fill.x + barra.width});
				setTimeout(function():void{
					var levelUpSE:LevelUpSE = new LevelUpSE();
					levelUpSE.play(0,0,null);
					expRestante = (expRestante+newXP) - levelsXP[playerLevel];
					playerLevel++;
					levelNumber.text = playerLevel.toString();
					
					//Mostra a PopUp do novo level
					var popUp:PopUp = new PopUp();
					popUp.bringPopUp(parentGlobal);
					popUp.showNewLevel(playerLevel);
					popUp.addEventListener(Event.REMOVED_FROM_STAGE, onCheckForMoreXP);
				}, 1100);
				
				// Mixpanel
				mixpanel.track(MP_EVT.PASSOU_LEVEL, {
					"Level Atingido": playerLevel + 1
				});
			} else {
				var resto:int = (newXP == 0) ? expRestante : expRestante+newXP;
				TweenLite.to(fill, 1, {x:fill.x + barra.width*(resto/levelsXP[playerLevel])});
				dispatchEvent(new NavigationEvent(NavigationEvent.LEVELEDUP));
			}
		}
		
		protected function onCheckForMoreXP(event:Event):void {
			fill.x -= barra.width;
			addXP(expRestante, parentGlobal, false);				
		}
		
	}	
}
