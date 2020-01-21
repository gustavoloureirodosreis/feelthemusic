package auxiliares {
	import com.greensock.loading.DataLoader;
	
	import externo_ca.turbulent.media.ErrorEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class FuvogCalculator {
		//Passos essenciais no algoritmo a ser executado nessa classe:
		//1- Abrir o fuvog de cada música //OK
		//3- Guardar em um dicionário de fuvogs o id da música e sua força em cada fuvog //OK
		//4- Terminadas todas as músicas, ordenar o dicionário de fuvogs em ordem decrescente de força //OK
		//5- Terminada a ordenação, eliminar as músicas mais fracas que um determinado limite //OK
		
		public var fuvogs:Dictionary = new Dictionary();
		public var currentIndexGlobal:Number = 0;
		
		public function FuvogCalculator() {
			
		}
		
		public function calculaFuvogs(currentIndex:Number):void {
			//Atualiza index global
			currentIndexGlobal = currentIndex;
			
			//Cria os loaders 
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			
			if(currentIndex < FeelMusic.musicIDsArray.length) {
				//Índice "2" é o id, "4" é o nome
				trace("Começou processo para musica: "+FeelMusic.musicIDsArray[currentIndex][4]);
				request.url = "Musicas_Fuvog/" + FeelMusic.musicIDsArray[currentIndex][4] + "/all.json";
				loader.addEventListener(Event.COMPLETE, onOpenedJson);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.load(request);
			} else {
				finishCalculator();
			}
		}
		
		protected function onError(event:IOErrorEvent):void {
			trace("Não tem o json ou nao tem algo seguro da musica: "+FeelMusic.musicIDsArray[currentIndexGlobal][4]);
			trace("Erro foi: "+event.text);
			currentIndexGlobal++;
			calculaFuvogs(currentIndexGlobal);
		}
		
		protected function onOpenedJson(event:Event):void {
			//Parseia o Json para um Objeto agradável de percorrer
			var loader:URLLoader = URLLoader(event.target);
			var jsonArray:Object = JSON.parse(loader.data);
			var fuvogsDaMusica:Object = jsonArray["FTM-fuvogs"];
			
			//Ve o total de pontos no fuvogsDaMusica
			var totalDaMusica:Number = 0;
			for(var key0:String in fuvogsDaMusica) {
				totalDaMusica += Number(fuvogsDaMusica[key0]);
			}
			
			//Preenche o dicionário de fuvogs
			for(var key:String in fuvogsDaMusica) {
				var pontuacaoDaMusica:Number = Math.round(Number(fuvogsDaMusica[key])/totalDaMusica*100);
				if(fuvogs[key] == null) {
					trace("Nova chave: "+key);
					fuvogs[key] = new Array();
					fuvogs[key].push([FeelMusic.musicIDsArray[currentIndexGlobal][2].toString(),
						pontuacaoDaMusica]);
				} else {
					fuvogs[key].push([FeelMusic.musicIDsArray[currentIndexGlobal][2].toString(),
						pontuacaoDaMusica]);
				}
			}
			
			//Vai pra próxima música
			currentIndexGlobal++;
			calculaFuvogs(currentIndexGlobal);
		}
		
		private function finishCalculator():void {
			for(var key:String in fuvogs) {
				fuvogs[key] = fuvogs[key].sortOn("1", Array.NUMERIC | Array.DESCENDING);
				var valores:String = "[";
				var limit:int = 0;
				for each(var pair:Array in fuvogs[key]) {
					valores += "["+pair[0]+","+pair[1]+"],";
					limit++;
					if(limit >= 20) { break; }
				}
				valores = valores.substr(0,valores.length-2);
				valores += "]";
				var counterTemas:Number = 1;
				for each(var tema:Object in WordShuffler.themes) {
					if(tema.name==key /*&& tema.active*/) {
						trace("tema"+counterTemas+": {");
						trace("\t id:"+counterTemas+",");
						trace("\t active:"+[tema.active==true ? " true," : " false,"]);
						trace("\t name: \""+tema.name+"\",");
						trace("\t musics: "+valores+",");
						var content:String = "["; 
						for each(var word:String in tema.content) {
							content += "\""+word+"\", ";
						}
						content += "]";
						trace("\t content: "+content);
						trace("},");
						counterTemas++;
						break;
					}
				}
			}
		}

		public var googleapisKey:String = "AIzaSyCyvLKmSILhZMc3m9Zw1f1BHeVAN6pFgrY"
		public var currSong:Array = ["",""];
		public var allBrokenSongs:Array = [];
		public var brokenIndex:Number = 0;
		public function calculaBroken(index:int):void {
			
			brokenIndex = index;
			//Checa se tem assinatura
			var request:URLRequest = new URLRequest(
			"https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id="+FeelMusic.musicIDsArray[brokenIndex][3]+
			"&key="+googleapisKey);
			currSong = [FeelMusic.musicIDsArray[brokenIndex][4], FeelMusic.musicIDsArray[brokenIndex][0]];
			var loader:URLLoader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onCompleteLoadBroken);
			
			function onCompleteLoadBroken(event:Event):void {
				var json:Object = JSON.parse(event.target.data);
				var jsonItems:Object = json.items[0];
				if(jsonItems!=null) {
					if(jsonItems.regionRestriction==null) {
						calculateNext();
					} else {
						if(jsonItems.regionRestriction.allowed!=null && jsonItems.regionRestriction.allowed.indexOf("BR")==-1
						   || jsonItems.regionRestriction.blocked!=null && jsonItems.regionRestriction.blocked.indexOf("BR")>=0) {
							brokenVideo();
						} else {
							calculateNext();
						}
					}
				} else {
					brokenVideo();
				}
			}
		}
		
		protected function brokenVideo():void {
			trace("Música quebrada: "+currSong[0]+" diff: "+currSong[1]);
			allBrokenSongs.push(currSong);
			calculateNext();
		}
		
		protected function calculateNext():void {
			brokenIndex++;
			if(brokenIndex>=FeelMusic.musicIDsArray.length-1) {
				trace("Checou todas as músicas quebradas.");
				for each(var brokenSong:Array in allBrokenSongs) {
					trace("Quebrada: "+brokenSong[0]+" diff: "+brokenSong[1]);
				}
			} else {
				if(brokenIndex%100==0) {
					trace("Já checou: "+brokenIndex+" músicas");
				}
				calculaBroken(brokenIndex);			
			}
		}
	}
	
}