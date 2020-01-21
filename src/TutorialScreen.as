package  {
	
	import auxiliares.Settings;
	
	import com.gamua.flox.Player;
	import com.mixpanel.Mixpanel;
	
	import enums.MP_EVT;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import flox_entities.MyPlayer;
	
	
	public class TutorialScreen extends MovieClip {
		//Variáveis já no MC:
		public var opcaoSim:SimpleButton;
		public var opcaoNao:SimpleButton;
		public var confirmBtn:SimpleButton;
		public var welcomeMsg:MovieClip;
		public var askMsg:TextField;
		
		//Outras variáveis:
		public var acabou:Boolean = false;
		public var proxFrame:Number = 2;
		
		// Mixpanel
		private var mixpanel:Mixpanel;
		
		public function TutorialScreen() {
			// Inicia Mixpanel
			mixpanel = Settings.getInstance().mixpanel;
			
			var player:MyPlayer = Player.current as MyPlayer;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void {
			opcaoSim.addEventListener(MouseEvent.CLICK, onClickSim);
			opcaoNao.addEventListener(MouseEvent.CLICK, onClickNao);
			fillText(this.currentFrame);
			
			if(FeelMusic.musicId!=null) {
				for each(var quintuple:Array in FeelMusic.musicIDsArray) {
					if(quintuple[2] == FeelMusic.musicId) {
						welcomeMsg["music"].text = quintuple[4].split("-")[0]+"\n"+
							quintuple[4].split("-")[1];
						break;
					}
				}
			} else {
				welcomeMsg.visible = false;
				askMsg.y = 200;
				opcaoNao.y = 350;
				opcaoSim.y = 350;
			}
		}
		
		protected function onClickNao(event:MouseEvent):void {
			onNaoQuisTutorial();
			mixpanel.track(MP_EVT.TUTORIAL, {"Quis Ver": false});
		}
		
		protected function onClickSim(event:MouseEvent):void {
			onQuisTutorial();
			mixpanel.track(MP_EVT.TUTORIAL, {"Quis Ver": true});
		}		

		protected function onNaoQuisTutorial():void {
			var player:MyPlayer = Player.current as MyPlayer;
			player.jaViuTutorial = true;
			player.saveQueued();
			parent.removeChild(this);
		}
		
		protected function onQuisTutorial():void {
			this.gotoAndStop(proxFrame);
			fillText(proxFrame);
			proxFrame++;
			confirmBtn.addEventListener(MouseEvent.CLICK, onGoToproxFrame);
		}
			
		protected function onGoToproxFrame(event:MouseEvent):void {
			if(!acabou) {
				this.gotoAndStop(proxFrame);
				fillText(proxFrame);
				proxFrame++;
				if(proxFrame>5) { acabou = true; }
			} else {
				var player:MyPlayer = Player.current as MyPlayer;
				player.jaViuTutorial = true;
				player.viuTutorial = true;
				player.saveQueued();
				parent.removeChild(this);								
			}
		}
		
		private function fillText(cf:Number):void {
			if(cf==1) {
				askMsg.text = FeelMusic._("askMsg");
				welcomeMsg["welcomeMsg"].text = FeelMusic._("welcomeMsg");
			} else if(cf>1) {
				this["tutorialMsg"+(cf-1)].text = FeelMusic._("tutorialMsg"+(cf-1));
			}
		}
		
	}
	
}
