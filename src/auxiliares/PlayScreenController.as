package auxiliares
{
	import com.gamua.flox.Player;
	import com.gamua.flox.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import flox_entities.MyPlayer;

	public class PlayScreenController {
		
		public static var masteredWords:Array = new Array();
		public static var songWords:Array = new Array();
		public static var setouMasteredWords:Boolean = false;
		
		public function PlayScreenController() {
			
		}
		
		public static function getMusicId(musica:String):String {
			var musicID:String = ""
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[4] == musica) {
					musicID = quintuple[2];
					break;
				}
			}
			return musicID;
		}
		
		public static function getMusicName(musicID:String):String {
			var musicName:String = ""
			for each(var quintuple:Array in FeelMusic.musicIDsArray) {
				if(quintuple[2] == musicID) {
					musicName = quintuple[4];
					break;
				}
			}
			return musicName;
		}
		
		public static function getProgPercentage():Array {
			var conhecidas:Array = new Array();
			var desconhecidas:Array = new Array();
			for each(var songWord:String in songWords) {
				if(masteredWords.indexOf(songWord)>=0) {
					conhecidas.push(songWord);
				} else if(desconhecidas.indexOf(songWord)==-1){
					desconhecidas.push(songWord);
				}
			}
			var percentFiltered:Number = Math.min(Math.round(conhecidas.length*1.25/songWords.length*100), 100);
			var retorno:Array = [conhecidas, percentFiltered, desconhecidas];
			return retorno;
		}
		
		public static function setSongWords(versosInfo:Array):void {
			for each(var trice:Array in versosInfo) {
				var verseWords:Array = trice[0].split(" ");
				for each(var verseWord:String in verseWords) {
					var wordClean = verseWord.split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();
					if(songWords.indexOf(wordClean)==-1 && wordClean.length>=1 && wordClean.indexOf("\r")==-1) {
						songWords.push(wordClean);
					}
				}
			}
		}
		
		//Calcula pontuação total da música considerando um combo fixo
		public static function totalPoinsWithCombo(numLacunas:Number):Number {
			var totalPointsWithCombo = 0;
			if(numLacunas>12) {
				totalPointsWithCombo = acrescimoNoCombo(3.6, numLacunas);
			} else {
				totalPointsWithCombo = acrescimoNoCombo(numLacunas/5, numLacunas);
			}
			return totalPointsWithCombo;
		}
		
		private static function acrescimoNoCombo(comboLocal:int, numVezes:Number):Number {
			var medidorSucesso:Number = 0.75;
			var acrescimo:Number = numVezes*(0.9+comboLocal)*Math.ceil(Math.exp(3+2.5*medidorSucesso));
			return acrescimo;
		}
		
		//Calcula quanto acrescentar na pontuação devido ao último acerto
		public static function acrescimoNaPontuacao(comboLocal:int, numVezes:Number, textAtual:MovieClip, subSpace:MovieClip):Number {
			var medidorSucesso = 0;
			if(textAtual!=null) {
				medidorSucesso = 1-((subSpace.y + subSpace.height-textAtual.height/3)-textAtual.y)/(subSpace.height);
				if(medidorSucesso<0) { medidorSucesso = Math.random(); }
			}
			return (1+comboLocal)*Math.ceil(Math.exp(3+2.5*medidorSucesso));
		}
		
		//Checa se o verso em questão tem pelo menos uma palavra com rimas o suficiente
		public static function checkIfEnoughRhymes(wordOpt:XML, sub:String):Boolean {
			var tester:Boolean = false;
			var contador:Number;
			var blocks = sub.split(/ /g);
			for(contador=0; contador<blocks.length; contador++){
				if(wordOpt.word.(@value==blocks[contador].split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase()).children().length()>=2 
				   && blocks[contador].split(/[?!,.-;:\r\(\)]/g).join("").length>=3) {
						tester = true;
						break;
				}
			}
			return tester;
		}
		
		//Retorna a legenda com uma lacuna no lugar de alguma palavra
		public static function criaNovaLegendaModificada(parentMC:Object, blocks:Array):String {
			var tamBlocks:Number;
			var qualPalavraDoVerso:Number = 0;
			parentMC.jaPosAsOpcoes = false;
			blocks = parentMC.textBoxes[parentMC.boxNew].textoBox.text.split(/ /g);
			qualPalavraDoVerso = selecionaPalavraDoVerso(parentMC, blocks);
			
			parentMC.omitido[parentMC["boxNew"]] = blocks[qualPalavraDoVerso].split(/[?!,.-;:\r\(\)]/g);
			parentMC.omitido[parentMC["boxNew"]] = parentMC.omitido[parentMC["boxNew"]].join("");
			parentMC.posicaoLegendaOld = parentMC.posicaoLegendaAtual;
			parentMC.posicaoLegendaAtual = parentMC.boxNew;
			
			//Preenche adaptativo
			parentMC["examination"].items[parentMC["examination"].items.length-1].question = "line"+parentMC.versoEmJogo+"["+qualPalavraDoVerso+"]";
			parentMC["examination"].items[parentMC["examination"].items.length-1].text = blocks[qualPalavraDoVerso];
			
			blocks[qualPalavraDoVerso] = "_____";
			return blocks.join(" ");
		}
		
		//Seleciona que lacuna do verso será selecionada para omitir
		public static function selecionaPalavraDoVerso(parentMC:Object, blocks:Array):Number{
			parentMC.novaLegendaComOmissao = false;
			
			//seta mastered words se precisar ainda
			preparaMasteredWords(setouMasteredWords);
			
			//Escolhe uma posicao aleatoria do blocks
			var posicPalavraEscolhida:Number = Math.floor(Math.random()*blocks.length);
			blocks[posicPalavraEscolhida] = blocks[posicPalavraEscolhida].split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();	
			parentMC.ultimaOmissao = blocks[posicPalavraEscolhida];
			
			//Checa se foi uma palavra vazia ou nao. Se foi, repete
			var rex:RegExp = /^[\s\r\n]*$/gim;
			if(parentMC.ultimaOmissao.match(rex).length>=1 || parentMC.ultimaOmissao.length==0) {
				return selecionaPalavraDoVerso(parentMC, blocks);
			}
			
			//Antes de retornar, checa se foi uma palavra mestrada.
			if(masteredWords.indexOf(parentMC.ultimaOmissao)>=0) {
				if(blocks.length==1) {
					//Se não tiver mais de uma palavra no verso, não adianta buscar outras
					return posicPalavraEscolhida;								
				} else {
					//Se tem mais de uma, procura uma não mestrada
					for(var i:int=0; i<blocks.length; i++) {
						blocks[i] = blocks[i].split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();
						if(masteredWords.indexOf(blocks[i])==-1) {
							parentMC.ultimaOmissao = blocks[i];
							posicPalavraEscolhida = i;
							break;
						}
					}
					return posicPalavraEscolhida;
				}
			} else {
				return posicPalavraEscolhida;			
			}
		}
		
		public static function preparaMasteredWords(masteredWordsBool:Boolean):void {
			if(!masteredWordsBool) {
				var player:MyPlayer = Player.current as MyPlayer;
				for each(var word:String in player.expressAcertadas) {
					if(Number(player.expressBem[player.expressAcertadas.indexOf(word)])>=10) {
						masteredWords.push(word);
					}
				}
				setouMasteredWords = true;
			}
		}
		
		//Grava expressões novas
		public static function novaExpressao(parentMC:Object, acertou:Boolean):void {
			var correctWord:String = parentMC['wBtn'+parentMC.btnCorreto].textoBtn.text;
			var temaAbordado:String = WordShuffler.analyseAnswer(correctWord);
			if(temaAbordado!=null) {
				parentMC.temasNaPartida.push([temaAbordado, ( acertou == true ? 1 : -1 )]);
			}
			//Lida com as expressões novas
			if(parentMC.auxExpressoesAcertadas.indexOf(correctWord)==-1) {
				parentMC.auxExpressoesAcertadas.push(correctWord);
			}
			if(parentMC.auxExpressBem[parentMC.auxExpressoesAcertadas.indexOf(correctWord)]==null) {
				parentMC.auxExpressBem[parentMC.auxExpressoesAcertadas.indexOf(correctWord)] = (acertou == true ? 1 : -1);
			} else {
				parentMC.auxExpressBem[parentMC.auxExpressoesAcertadas.indexOf(correctWord)] += (acertou == true ? 1 : -1);
			}
			//Lida com os tipos de lacuna
			if(acertou) {
				if(parentMC.blankType==1) { parentMC.auxItens[0]++; }
				else if(parentMC.blankType==2) { parentMC.auxItens[2]++; }
				else if(parentMC.blankType==3) { parentMC.auxItens[4]++; }				
			}
			if(parentMC.blankType==1) { parentMC.auxItens[1]++; }
			else if(parentMC.blankType==2) { parentMC.auxItens[3]++; }
			else if(parentMC.blankType==3) { parentMC.auxItens[5]++; }
		}
		
		//Animação ao escolher uma opção
		public static function showParticlesAround(parentMC:Sprite, target:MovieClip, colorTarget:Number):void {
			for(var i:int=1; i<=18; i++) {
				var angle:Number = Math.random()*20+20*(i-1);
				var particle:ParticleBalls = new ParticleBalls();
				parentMC.addChild(particle);
				particle.x = target.x;
				particle.y = target.y;
				TweenLite.to(particle, 0.3, {x:particle.x + 300*Math.sin(angle*Math.PI/180), 
					y:particle.y + 300*Math.cos(angle*Math.PI/180), rotation:angle,
					scaleX:2, scaleY:2, alpha:0.9, tint:colorTarget, onComplete: completeParticle(parentMC, particle)});
			}
		}
		
		public static function completeParticle(parentMC:Sprite, particle:ParticleBalls):void {
			setTimeout(function(){parentMC.removeChild(particle);}, 300);
		}
		
	}
}