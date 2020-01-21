package
{	
	import com.gamua.flox.utils.Base64;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import auxiliares.DifficultyCalculator;
	import auxiliares.PopUp;
	import auxiliares.Settings;
	import auxiliares.WordShuffler;
		
	public class FTM extends MovieClip {
		
		//Outras variáveis:
		private var email:String;
		private var idPlayer:String;
		private var tempId:String; 
		private var musicId:String;
		private var masterSongId:String;
		private var usernamePlayer:String;
		private var lang:String;
		private var nameFacebook:String;
		private var tipoUsuario:String;
		private var codPromo:String;
		private var gameLang:String;
		private var onFacebook:Boolean;
		private var curso:Object;
		
		public function FTM() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			// Dar init no Settings antes de qualquer outra coisa
			var settings:Settings = Settings.getInstance();
			settings.init(loaderInfo);
			
			var infos:Object;
			var game:FeelMusic;
			
			if (settings.isDev) {
				//Abaixo somente para testes internos
				infos =  {id: "generic_F19", username: "generic_id", friends: [], email: "teste@testa.com", onFacebook: false};
				//infos["musicId"] = decodeMusicId("NDE1"); //é o equivalente ao ID "415" (Ariana Grande - Intro)
				//infos["masterSongId"] = "94";//decodeMusicId("NDE1");
				infos["lang"] = "pt";
				//infos["gameLang"] = "es";
				//infos["codPromo"] = "4";
				//infos["curso"] = "teste";
				//infos["tipoUsuario"] = "1";
				game = new FeelMusic(infos);
				addChild(game);
				game.initFTM();
			} else {
				//Pega as informações que vem do flashvars (no caso de estarem carregando de fora do mundo):
				var parametros:Object = LoaderInfo(this.root.loaderInfo).parameters;
				email = parametros['email'];
				idPlayer = parametros['idPlayerFTM'];
				usernamePlayer = parametros['usernamePlayerFTM'];
				tempId = parametros['tempId'];
				lang = parametros['lang'];
				onFacebook = parametros['onFacebook'];
				nameFacebook = parametros['nameFacebook'];
				//Checa se vai jogar uma música direto
				musicId = decodeMusicId(parametros['musicId']);
				//Checa se vai pro modo de mestrar música com algum ID
				masterSongId = decodeMusicId(parametros['masterSongId']);
				//cod indica que existirão músicas a se dar por causa de promoção, e diz onde achá-las no json do servidor
				codPromo = decodeMusicId(parametros['cod']);
				//Checa se abre outra versão que não a default do jogo
				gameLang = parametros['game'];
				//0-adm, 1-editor, 2-gestor, 3-professor, 4-usuário comum
				tipoUsuario = parametros['tipoUsuario'];
				//Só recebe isso se estiver dentro de um modo curso
				if(parametros['curso']!=null) {
					try{
						var curso:Object = new Object();
						var cursoObject:Object = JSON.parse(parametros['curso']);
						curso = cursoObject.files;
					} 
					catch(error:Error){
						trace('Error: '+error.message);
					}
				}
				
				//Checa se é uma versão sem login (se é um visitante)
				if(tempId!=null && tempId!="") {
					var guestNum:int = Math.round(Math.random()*99999999);
					infos = {
						id: tempId,
						username: "Guest " + guestNum.toString(),
						musicId: musicId,
						onFacebook: onFacebook,
						nameFacebook: nameFacebook,
						lang: lang,
						tipoUsuario: tipoUsuario,
						codPromo: codPromo,
						curso: curso,
						gameLang: gameLang,
						masterSongId: masterSongId
					};
					game = new FeelMusic(infos);
					game.initFTMguest();
					addChild(game);	
				//Caso seja uma versão com login e não é do mundo (quando é do mundo chama-se métodos de FeelMusic.as por fora)
				} else if(idPlayer!=null && idPlayer!="") {
					infos =  {
						id: idPlayer,
						username: usernamePlayer,
						email: email,
						musicId: musicId,
						onFacebook: onFacebook,
						nameFacebook: nameFacebook,
						lang: lang,
						tipoUsuario: tipoUsuario,
						codPromo: codPromo,
						curso: curso,
						gameLang: gameLang,
						masterSongId: masterSongId
					};
					game = new FeelMusic(infos);
					game.initFTM(); 
					addChild(game);
				}
			}
			
			//Abaixo somente quando for calcular dificuldades de novas músicas
			//var diffCalc:DifficultyCalculator = new DifficultyCalculator();
		}
		
		private function decodeMusicId(musicId:String):String {
			if(!musicId) {
				return null;
			}
			try {
				musicId = Base64.decode(decodeURIComponent(musicId));
				return musicId;
			} catch (RangeError) {
				return null;
			}
			return null;
		}
	}
}
