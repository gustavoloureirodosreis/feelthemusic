package auxiliares
{
	import com.gamua.flox.Player;
	import com.mixpanel.Mixpanel;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flashx.textLayout.events.ModelChange;
	
	import flox_entities.MyPlayer;

	public class Settings {
		
		private static const MIXPANEL_TOKEN_DEV:String = '87eb6c83f3191f0c36f13f6d1d1e4ec5';
		private static const MIXPANEL_TOKEN_PROD:String = 'f5777ac5f341abe1da172c3011abfd50';
		public static const LOCALE_URL:String = '../locale/';
		
		private static var instance:Settings;
		
		private var _isDev:Boolean;
		private var _mixpanel:Mixpanel;

		public function Settings() {
			if (instance) {
				throw new Error("Singleton class. User getInstance() method instead.");
			}
		}
		
		public static function getInstance():Settings {
			if (!instance) {
				instance = new Settings();
			}
			return instance;
		}
		
		public function init(loaderInfo:LoaderInfo):void {
			// detect environment
			var url:String = loaderInfo.url;
			var devPattern:RegExp = /^https?:\/\/(localhost|127.0.0.1)/i;
			_isDev = devPattern.test(url);
			
			// init Mixpanel
			if (_isDev) {
				_mixpanel = new Mixpanel(MIXPANEL_TOKEN_DEV);
			} else {
				_mixpanel = new Mixpanel(MIXPANEL_TOKEN_PROD);
			}
		}
		
		public function get isDev():Boolean {
			return _isDev;
		}
		
		public function get mixpanel():Mixpanel {
			return _mixpanel;
		}
		
		public static function checkPlayerUpdates(parentMC:MovieClip, emailPlayer:String, usernamePlayer:String, friends:Array):void {
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Atualiza as informações recebidas se elas forem novas
			propertiesUpdate(parentMC, emailPlayer, usernamePlayer, friends);
			
			if (!Settings.getInstance().isDev) {
				//Envia para url "/loginFTM" um URLRequest acusando login
				var urlDailyStreak:URLRequest = new URLRequest("/loginFTM");
				var loaderDailyStreak:Loader = new Loader();
				loaderDailyStreak.load(urlDailyStreak);
				
				//Envia para url "/flash.controller.php" quadro das palavras mestradas atualmente
				var masteredWords:Array = new Array();
				for each(var word:String in player.expressAcertadas) {
					if(Number(player.expressBem[player.expressAcertadas.indexOf(word)])>=10) {
						masteredWords.push(word);
					}
				}
				var palavras:Object = {};
				palavras.masters = masteredWords;
				
				var params:URLVariables = new URLVariables();
				params.acao     =   "palavras_masters"; //default
				params.dados    =   JSON.stringify(palavras);
				params.idplayer =   player.playerKey;
				
				var request3:URLRequest = new URLRequest();
				request3.method = URLRequestMethod.POST;
				request3.data = params;
				request3.url = "https://www.backpacker.com.br/flash.controller.php";
				
				var loader3:URLLoader = new URLLoader();
				loader3.load(request3);
			}
			
			//Checa se tem compras
			var data:URLVariables = new URLVariables();
			data.email = player.email;
			var request:URLRequest = new URLRequest("https://loja.backpacker.com.br/api/payments");
			request.data = data;
			
			var loader:URLLoader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onCompleteLoaderCompra);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorLoadHandler);
			function onCompleteLoaderCompra(event:Event):void {
				var json:Object = JSON.parse(event.target.data);
				var comprasDoJson:Array = json.items;
				var modificou:Boolean = false;
				for each(var compra:Object in comprasDoJson) {
					if(player.compras.indexOf(compra.id)==-1) {
						//Adiciona compra no flox e dá as moedas pro jogador
						player.nrCoins += Number(compra.ftm_coins);
						player.compras.push(compra.id);
						modificou = true;
					}
				}
				if(modificou) {
					player.saveQueued();
				}
			}
			
			//Checa se tem assinatura
			var request2:URLRequest = new URLRequest("https://loja.backpacker.com.br/api/subscriptions");
			request2.data = data;
			
			var loader2:URLLoader = new URLLoader();
			loader2.load(request2);
			loader2.addEventListener(Event.COMPLETE, onCompleteLoaderAssinatura);
			
			function onCompleteLoaderAssinatura(event:Event):void {
				var json:Object = JSON.parse(event.target.data);
				var arrayItens:Array = json.items;
				if(arrayItens.length>0) {
					var interiorItens:Object = arrayItens[0];
					if(interiorItens.status=="paid" && player.compras.indexOf("premium")==-1) {
						player.compras.push(interiorItens.id);
						player.compras.push("premium");
						player.nrCoins += 1000;
						player.saveQueued();
					} else if(interiorItens.status!="paid" && player.compras.indexOf("premium")>=0) {
						player.compras.splice(player.compras.indexOf("premium"),1);
						player.saveQueued();
					} 
				}
			}
			function errorLoadHandler(e:IOErrorEvent):void {
				trace("Erro de checagem de compra/assinatura: "+e.toString());
			}
			
			//Checa se tira assinatura advinda de invites
			for each(var compra:String in player.compras) {
				if(compra!=null && compra.indexOf("expiry30plus")>=0) {
					var oldDate:Date = compra.split("expiry30plus: ")[1] as Date;
					var todayDate:Date = new Date();
					
					//Checa se a diferença é maior que 30 dias
					if(todayDate.time - oldDate.time > 1000*60*60*24*30) {
						player.compras.splice(player.compras.indexOf(compra), 1);
						player.compras.splice(player.compras.indexOf(compra)-1,1);
						player.saveQueued();
					}
					break;
				}
			}
			
			//Checa se tem músicas a dar por causa de promoção
			if(FeelMusic.codPromo!=null && !FeelMusic.ehGuest) {
				//var request3:URLRequest = new URLRequest("promo.json");
				var request4:URLRequest = new URLRequest("json/promo/promo.json");
				var loader4:URLLoader = new URLLoader();
				loader4.load(request4);
				loader4.addEventListener(Event.COMPLETE, onCompleteLoaderPromo);
				
				function onCompleteLoaderPromo(event:Event):void {
					var json:Object = JSON.parse(event.target.data);
					var arrayMusicIDs:Array = json[FeelMusic.codPromo];
					var player:MyPlayer = Player.current as MyPlayer;
					var modPlayer:Boolean = false;
					var musicNames:Array = new Array();
					for each(var musicID:String in arrayMusicIDs) {
						for each(var quintuple:Array in FeelMusic.musicIDsArray) {
							if(quintuple[2]==musicID) {
								musicNames.push([quintuple[0], quintuple[4]]);
								break;
							}
						}
						if(player.temas.indexOf(musicID)==-1) {
							player.temas.push(musicID);
							modPlayer = true;
						}
					}
					if(modPlayer) {
						player.saveQueued();
					}
					
					//Mostra PopUp com as músicas em questão
					var popUp:PopUp = new PopUp();
					popUp.bringPopUp(parentMC);
					//parentMC só pode ser startScreen
					parentMC.setPopUpListener(popUp);
					popUp.showPromoMusics(musicNames);
				}
			} 
			
			//Checa se tem tema de modo curso pra liberar
			if(FeelMusic.curso!=null) {
				WordShuffler.themes = FeelMusic.curso;
				var modPlayer2:Boolean = false;
				for each(var cursoTheme:Object in WordShuffler.themes) {
					var dateNow:Number = new Date().time;
					if(dateNow > new Date(cursoTheme.datainicio).time && player.temas.indexOf(cursoTheme.name)==-1) {
						player.temas.push(cursoTheme.name);
						for each(var musicPair:Array in cursoTheme.musics) {
							if(player.temas.indexOf(musicPair[0])==-1) {
								player.temas.push(musicPair[0]);
							}
						}
						modPlayer2 = true;
					}
				}
				if(modPlayer2) {
					player.saveQueued();
				}
			}
		}
		
		private static function propertiesUpdate(parentMC:MovieClip, emailPlayer:String, usernamePlayer:String, friends:Array):void {
			var player:MyPlayer = Player.current as MyPlayer;
			
			//Tipo de perfil e alunos (users de antes de 23/02/2015)
			if(player.tipoPerfil==null) {
				player.tipoPerfil = "a definir";
				player.alunos = new Array();
				player.saveQueued();
			}
			//Achievements (users de antes de 21/01/2015)
			if(player.achievements==null) {
				player.achievements = [["Actions I",0,0],["Actions II",0,0],["Actions III",0,0]];
				player.saveQueued();
			}
			//Item de sugerir musica e de ver letra (users de antes de 26/02/2015)
			if(player.itens.length==6 || player.itens.length==7) {
				player.itens.push(20);
				if(player.itens.length==7) { player.itens.push(20); }
				player.saveQueued();
			}
			//Atualiza expressBem
			if(player.expressBem==null) {
				player.expressBem = new Array();
				if(player.expressAcertadas==null) {
					player.expressAcertadas = new Array();
				}
				for each(var palavra:String in player.expressAcertadas) {
					player.expressBem.push("0");
				}
				player.saveQueued();
			} else {
				var modified:Boolean = false;
				for each(var palavra2:String in player.expressBem) {
					if(palavra2==null) {
						player.expressBem[player.expressBem.indexOf(palavra2)] = Math.round(Math.random()*10);
						modified = true;
					}
				}
				if(modified) {
					player.saveQueued();
				}
			}
			//Email
			if(emailPlayer!=player.email) {
				player.email = emailPlayer;
				player.saveQueued();
			}
			//Username
			if(usernamePlayer!=player.username){
				player.username = usernamePlayer;
				player.saveQueued();
			}
			//Amigos
			if(friends!=null){
				if(friends.length!=player.friends.length) {
					player.friends = friends;
					player.saveQueued();
				} else {
					for each(var friend:String in player.friends){
						if(friends.indexOf(friend)==-1){
							player.friends = friends;
							player.saveQueued();
							break;
						}
					}
				}
			}			
		}
		
		public static function changeGameLanguage(lang:String):void {
			if(lang=="es") {
				//Atualiza os temas
				WordShuffler.themes = WordShuffler.es_themes;
				//Atualiza as palavras-secretas
				WordShuffler.trickyWords = WordShuffler.es_trickyWords;
				//Troca músicas dadas no inicio do jogo
				FeelMusic.musicasNivelUm = FeelMusic.es_musicasNivelUm;
			}
		}
		
	}
}
