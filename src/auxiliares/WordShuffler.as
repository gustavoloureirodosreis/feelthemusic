package auxiliares {
	import com.gamua.flox.Player;
	
	import flash.display.MovieClip;
	
	import flox_entities.MyPlayer;
	
	public class WordShuffler {
		public var wordOpt:XML = new XML();
		public var versosInfo:Array = new Array();

		//Tricky words 
		public static var trickyWords:Array = [["they're","their","there"], ["than","then","them"], ["to","too","two"],
										["your","you're","you"],["tough","though","thought"], ["here", "hear", "her"], 
										["until","untie","anvil"], ["alright", "all right","right"],["word", "world", "words"],
										["week", "weak", "meek"], ["bad", "dad", "sad"], ["accept", "except", "excerpt"],
										["adverse", "averse", "adversary"], ["affect", "effect", "infect"], ["through", "throughout", "throw"],
										["allowed", "aloud", "loud"], ["bare", "bear", "beer"], ["break", "brake", "brick"],
										["coarse", "course", "curse"], ["store", "story", "storey"], ["sight", "cite", "site"],
										["its", "it's", "it"], ["already", "all ready", "all read"], ["lose", "loose", "lousy"],
										["buy", "by", "bye"], ["flash", "flesh", "flush"], ["want", "won't", "wont"]];
		
		public static var es_trickyWords:Array = [["muy","mucho"],["pero","sino"],["aquií","acá"],["el","lo"], ["al", "a"],
										["ablando", "hablando"], ["amo", "hamo"], ["as", "has"], ["bate", "vate"], ["callado", "cayado"],
										["echa", "hecha"], ["echo", "hecho"], ["grabe", "grave"], ["hice", "ice"], ["riza", "risa"],
										["tasa", "taza"], ["vez", "ves"], ["verás", "veraz"], ["pero", "perro"], ["hasta, hacia"],
										["A", "Ha"], ["Abollar", "Aboyar"], ["Abrasar", "Abrazar"], ["Asesinar", "Acecinar"], 
										["Acerbo", "Acervo"], ["Acético", "Ascético"], ["Adolecente", "Adolescente"], ["Abría", "Habría"],
										["Agitó", "Ajito"], ["Alaban", "Halaban"], ["Ahí", "Ay"], ["Alón", "Halon"], ["Ampón", "Hampón"], 
										["Arte", "Harté"], ["Aprehender", "Aprender"], ["Arrollar", "Arroyar"], ["As", "Has"], 
										["Asada", "Azada"], ["Asar", "Azar"], ["Ascenso", "Asenso"], ["Asía", "Hacia"], ["Asta", "Hasta"], 
										["Atajo", "Hatajo"], ["Aya", "Halla"], ["hablando", "Ablando"], ["Bah", "Va"], ["Bacante", "Vacante"],
										["Bacía", "Vacía"], ["Bacilo", "Vacilo"], ["Baqueta", "Vaqueta"], ["Baca", "Vaca"], ["Bario", "Vario"],
										["Barón", "Varón"], ["Basto", "Vasto"], ["Baya", "Valla"], ["Balido", "Válido"], ["Bazo", "Vaso"],
										["Bello", "Vello"], ["Ben", "Ven"], ["Bienes", "Vienes"], ["Botar", "Votar"], ["Bracero", "Brasero"],
										["Brasa", "Braza"], ["Caba", "Cava"], ["Cause", "Cauce"], ["Cabo", "Cavo"], ["Callado", "Cayado"], 
										["Callo", "Cayo"], ["Cansas", "Kansas"], ["Casa", "Caza"], ["Cazar", "Casar"], ["Cebo", "Sebo"], ["Cede", "Sede"],
										["Cegar", "Segar"], ["Cena", "Sena"], ["Cenador", "Senador"], ["Cerrar", "Serrar"], ["Cesión", "Sesión"], ["Cien", "Sien"],
										["Ciervo", "Siervo"], ["Cima", "Sima"], ["Cimiente", "Simiente"], ["Cita", "Sita"], ["Cocer", "Coser"], 
										["Concejo", "Consejo"], ["Corso", "Corzo"], ["Desecha", "Deshecha"], ["Encausar", "Encauzar"], ["Errar", "Herrar"],
										["Ética", "Hética"], ["Faces", "Fases"], ["Gallo", "Gayo"], ["Gaza", "Gasa"], ["Gira", "Jira"], ["Grabar", "Gravar"],
										["Halá", "Ala"], ["Hierba", "Hierva"], ["Hierro", "Yerro"], ["Hojear", "Ojear"], ["Hola", "Ola"], ["Hecho", "Echo"], 
										["Honda", "Onda"], ["Hora", "Ora"], ["Hiena", "Llena"], ["Huso", "Uso"], ["Incipiente", "Insipiente"], ["Kilo", "Quilo"],
										["Losa", "Loza"], ["Malla", "Maya"], ["Masa", "Maza"], ["Meza", "Mesa"], ["Pulla", "Puya"], ["Rallar", "Rayar"],
										["Rasa", "Raza"], ["Rebelar", "Revelar"], ["Sabia", "Savia"], ["Sake", "Saqué"], ["Sacarías", "Zacarías"], 
										["Sueco", "Zueco"], ["Sumo", "Zumo"], ["Tuvo", "Tubo"], ["Tazar", "Tasar"], ["Tasa", "Taza"], ["Vos", "Voz"]];
		
		
		//Famílias de palavras
		//Preposições
		public static var prepositions:Array = ["aboard", "about", "above", "across", "after", "against", "along", "amid",
		"among", "around", "as", "at", "before", "behind", "below", "beneath", "beside", "besides", "between", "beyond",
		"but", "by", "concerning", "considering", "despite", "down", "during", "except", "excepting", "excluding", "following",
		"for", "from", "in", "inside", "into", "like", "minus", "near", "of", "off", "on", "onto", "opposite", "outside",
		"over", "past", "per", "plus", "regarding", "round", "save", "since", "than", "through", "to", "toward",
		"towards", "under", "underneath", "unlike", "until", "up", "upon", "versus", "with", "within", "without"];
		
		//Pronomes
		public static var pronouns:Array = ["I", "you", "he", "she", "it", "we", "they", "me", "her", "him", "it",
									"us", "them", "my", "your", "his", "its", "our", "their", "mine", "yours",
									"theirs", "myself", "himself", "herself", "ourself", "ourselves", "themselves"];
		
		//Temas
		public static var es_themes:Object = 
		{
			tema1: {
				id: "1",
				active: true,
				name: "Artículos definidos",
				musics: [[12,54],[13,41],[292,39],[486,38],[281,35],[484,34],[283,33],[61,33],[256,33],[1,33],
					[57,32],[552,32],[437,32],[16,32],[576,32],[272,32],[546,31],[321,31],[512,31],[59,30]],
				content: ["el", "la", "los", "las", "lo"]
			},
			tema2: {
				id: "2",
				active: true,
				name: "Artículos indefinidos",
				musics: [[659,22],[557,22],[215,22],[298,22],[599,20],[50,20],[503,19],[511,19],[255,19],
					[200,18],[232,18],[195,18],[228,17],[583,17],[657,17],[162,17],[424,17],[258,17],[642,17],[187,16]],
				content: ["un", "una", "unos", "unas"]
			},
			tema3: {
				id: "3",
				active: true,
				name: "Pronombres personales",
				musics: [[273,64],[633,60],[15,60],[332,57],[614,57],[668,56],[136,56],[275,55],[275,55],
					[236,54],[226,54],[147,53],[630,53],[253,53],[102,52],[188,51],[230,50],[337,49],[247,49],[409,49]],
				content: ["yo", "me", "mí", "conmigo", "nosotras", "nosotros", "nos", 
					"tú", "te", "ti", "contigo", "vosotros", "vosotras", "vos", "él",
					"ella", "se", "si", "consigo"]
			},
			tema4: {
				id: "4",
				active: true,
				name: "Saludos",
				musics: [[547,7],[440,4],[13,1],[110,1],[45,1],[62,1],[378,1],[416,1],[138,1],[211,1]],
				content: ["Hola", "Buenos días", "Qué tal", "Buenas tardes", "Buenas noches", "Qué pasas", "Buenas"]
			},
			tema5: {
				id: "5",
				active: true,
				name:"Haber - Presente",
				musics: [[421,56],[44,43],[28,41],[453,40],[551,40],[259,38],[42,37],[152,35],[275,34],[459,32],
					[519,31],[262,30],[249,30],[203,30],[20,29],[654,27],[36,27],[422,27],[220,26],[191,26]],
				content: ["he", "has", "ha", "hay", "hemos", "habéis", "han"]
			},
			tema6: {
				id: "6",
				active: true,
				name:"Ser - Presente",
				musics: [[210,58],[591,57],[663,57],[230,50],[239,44],[124,34],[664,31],[558,31],[101,30],[609,30],
					[544,30],[211,29],[214,29],[280,29],[537,29],[357,29],[161,28],[612,28],[455,28],[246,28]],
				content: ["soy", "eres", "es", "somos", "sois", "son"]
			},
			tema7: {
				id: "7",
				active: true,
				name:"Numeros Cardinales",
				musics: [[508,6],[388,6],[432,5],[605,4],[629,4],[126,4],
					[398,3],[430,3],[72,3],[652,3],[112,3],[669,3],[628,3],[20,2],[242,2],[63,2],[346,2],[593,2],[548,2],[27,2]],
				content: ["uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez", 
				"once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve", "veinte"]
			},
			tema8: {
				id: "8",
				active: true,
				name:"Despedidas",
				musics:[[213,46],[423,40],[546,39],[57,39],[576,39],[436,38],[374,38],[513,38],[310,36],[16,36],[608,36],[222,36],[121,36],[375,35],[522,35],[536,35],[562,35],[514,35],[260,35],[654,35]],
				content: ["Adiós!", "Hasta", "mañana!", "Hasta", "la", "vista!", "Hasta", "luego!", "Fue", "un", 
					"placer!", "Recuerdos!", "Saludos", "para", "todos!", "Que", "lo", "pases", "bien!", "Chau!"]
			},
			tema9: {
				id: "9",
				active: true,
				name:"Pronombre interrogativos",
				musics: [],
				content: ["qué", "dónde", "quién", "cómo", "quiénes", "cuándo", "cuál", "cuáles", "cuánto", "cuánta",
					"cuántas", "cuántos"]
			},
			tema10: {
				id: "10",
				active: true,
				name: "Numeros ordinales",
				musics: [],
				content: ["primero", "segundo", "tercero", "cuarto", "quinto", "sexto", "séptimo",
					"octavo", "noveno", "décimo", "vigésimo"]
			}
		}
		
		public static var themes:Object = 
		{
			tema70: {
				id:"70",
				active: false,
				name: "Animals",
				musics: [[7824,4],[8514,3],[4391,3],[11415,2],[8371,2],[7346,2],[11731,2],[6334,2],[11738,2],[11737,2],[5588,2],[6000,1],[11733,1],[11732,1],[11735,1],[5987,1],[11659,1],[10227,1],[10224,1],[5040,1]],
				content: ["animal", "cat", "dog", "dogs", "cats", "pigs", "pig", "fish", "bird", "birds", "hummingbird", "chick", "chicks", "chicken", "snake","monkey", "lion", "sheep", "horse", "butterfly", "butterflies", "oil"]
			},		
			tema98: {
				id: "98",
				active: false,
				name: "Demonstrative pronouns",
				musics: [[1815,3],[3054,3],[9614,3],[883,3],[9390,3],[11895,2],[11934,2],[11633,2],[11616,2],[11718,2],[11453,2],[11445,2],[11205,2],[11490,2],[11154,2],[11137,2],[11057,2],[10900,2],[10714,2],[7444,1]],
				content: ["this", "these", "that", "those"]
			},
			tema45: {
				id: "45",
				active: true,
				name: "Questions/Answers",
				musics: [[8558,4],[3794,4],[7098,3],[7427,3],[8473,3],[1812,3],[9020,3],[6138,3],[8423,3],[6461,3],[5323,3],[8124,3],[11853,2],[11858,2],[11765,2],[11915,2],[11883,2],[11738,2],[11592,2],[11562,1]],
				content: ["what", "when", "how", "cause", "cause", "where", "who", "why", "what's", "because","who's", "cuz", "which", "answer", "asking"]
			},
			tema76: {
				id:"76",
				active: false,
				name: "Dolch Words - Primer",
				musics: [[1859,6],[4977,5],[4758,5],[1852,5],[4923,5],[1220,4],[1440,4],[992,4],[11948,4],[1851,4],[5454,4],[1855,4],[6443,4],[9909,4],[5647,4],[1867,4],[9657,4],[9547,4],[2311,4],[3391,1]],
				content: ["all", "am", "are", "at", "ate", "be", "black", "brown", "but", "came", "did", "do", "eat", "four", "get", "good", "have", "he", "into", "like", "must", "new", "no", "now", "on", "our", "out", "please", "pretty", "ran", "ride", "saw", "say", "she", "so", "soon", "that", "there", "they", "this", "too", "under", "want", "was", "well", "went", "what", "white", "who", "will", "with", "yes"]
			},
			tema87: {
				id:"87",         
				active: false,
				name: "Conditionals",
				musics: [[2365,4],[850,3],[11710,3],[950,3],[1749,3],[2484,3],[11950,3],[2585,3],[2651,3],[3650,3],[7832,3],[4944,3],[7821,3],[10846,3],[11873,3],[9614,3],[9326,3],[6280,3],[6576,3],[6626,1]],
				content: ["would", "had", "could", "won\'t", "will", "if","had", "were", "have", "I\'ll"]
			},
			tema22: {
				id: "22",
				active: true,
				name: "Nature II",
				musics: [[4232,3],[8311,3],[11308,2],[11748,2],[11370,2],[10969,2],[10686,2],[10359,2],[9464,2],[9251,2],[8776,2],[8741,2],[7336,2],[8685,2],[8570,2],[8514,2],[4266,2],[8089,2],[8027,2],[502,1]],
				content: ["earth", "wind", "cool", "water", "sea", "summer", "ice", "ocean", "river", "clouds","dawn", "stone", "sight", "heat", "silence", "thunder", "storm", "noise", "dust", "skies","snow", "tree", "flame", "rose", "shadow"]
			},
			tema120: {
				id: "120",
				active: false,
				name: "Present continuous I",
				musics: [[11950,5],[1274,5],[8255,5],[6729,5],[6699,4],[8569,4],[6367,4],[9577,4],[938,4],[6326,4],[230,4],[10069,4],[1869,4],[1899,4],[3783,4],[4872,4],[3610,4],[2752,4],[1701,3],[1459,1]],
				content: ["going", "feeling", "looking", "waiting", "coming", "living", "getting", "trying", "falling", "running", "burning", "thinking", "making", "walking", "talking","holding", "saying", "dancing", "taking", "giving", "standing", "loving", "calling", "doing", "leaving", "breaking", "watching"]
			},
			tema120: {
				id: "120",
				active: false,
				name: "Present continuous I",
				musics: [[11950,5],[1274,5],[8255,5],[6729,5],[6699,4],[8569,4],[6367,4],[9577,4],[938,4],[6326,4],[230,4],[10069,4],[1869,4],[1899,4],[3783,4],[4872,4],[3610,4],[2752,4],[1701,3],[1459,1]],
				content: ["going", "feeling", "looking", "waiting", "coming", "living", "getting", "trying", "falling", "running", "burning", "thinking", "making", "walking", "talking","holding", "saying", "dancing", "taking", "giving", "standing", "loving", "calling", "doing", "leaving", "breaking", "watching"]
			},
			tema39: {
				id: "39",
				active: false,
				name: "Concepts III",
				musics: [[6727,3],[544,3],[9152,3],[7143,3],[10841,2],[9261,2],[9251,2],[949,2],[8849,2],[8215,2],[7425,2],[6332,2],[7379,2],[7240,2],[7221,2],[5304,2],[6783,2],[980,2],[11873,2],[587,1]],
				content: ["step", "blame", "sex", "story", "memories", "power", "ways", "secret", "peace", "pride","sign", "darkness", "shame", "thoughts", "freedom", "memory", "style", "bout", "mmm", "ego"]
			},
			tema32: {
				id: "32",
				active: false,
				name: "Adjectives IV",
				musics: [[1954,4],[8294,2],[8293,2],[8216,2],[7662,2],[7179,2],[6238,2],[3073,2],[6596,2],[6410,2],[6351,2],[992,2],[11898,2],[5645,2],[11308,2],[1312,2],[2329,2],[1303,2],[1037,2],[1234,1]],
				content: ["tight", "clear", "sweat", "higher", "lucky", "sad", "glad", "scared", "darling", "sexy","single", "broke", "empty", "stuck", "insane", "magic", "stronger", "clean", "crowd", "nice"]
			},
			tema57: {
				id: "57",
				active: true,
				name: "Abstract Nouns I",
				musics: [[4923,5],[1880,5],[1852,5],[1879,4],[2451,4],[1647,4],[11950,3],[1460,3],[1311,3],[7391,3],[575,3],[9543,3],[1257,3],[9614,3],[9786,3],[10042,3],[5922,3],[7295,3],[1920,3],[2137,1]],
				content: ["time", "way", "life", "mind", "things", "thing", "end", "name", "dream", "thought","help", "hell", "dreams", "chance", "truth", "kind", "death", "fear", "ride", "shot"]
			},
			tema114: {
				id: "114",
				active: false,
				name: "Connectors",
				musics: [[2439,8],[10249,8],[10244,8],[4021,7],[2244,7],[7400,7],[2443,7],[2438,7],[2490,7],[2433,7],[1163,6],[8533,6],[8494,6],[1178,6],[8529,6],[1162,6],[1164,6],[4130,6],[8306,6],[8261,1]],
				content: ["and", "but", "because", "if", "or", "than", "n", "while", "though"]
			},
			tema95: {
				id: "95",
				active: false,
				name: "Countries and nationalities",
				musics: [[11505,4],[10748,1],[3229,1],[2242,1],[10554,1],[132,1],[2193,1],[9904,1],[9901,1],[8672,1],[8660,1],[1843,1],[6212,1],[6160,1],[5600,1],[5493,1],[11462,1],[10471,1],[5029,1],[10731,1]],
				content: ["brazil", "usa", "america", "french", "korea", "china", "africa", "japan"]
			},
			tema29: {
				id: "29",
				active: true,
				name: "Concrete Objects II",
				musics: [[8261,6],[1280,6],[8741,4],[7642,2],[6605,2],[5620,2],[11409,2],[4256,2],[8314,2],[7659,2],[3440,2],[3425,2],[2964,2],[2099,2],[1980,2],[1864,2],[73,2],[709,2],[3881,1],[7695,1]],
				content: ["window", "piece", "point", "diamonds", "radio", "clothes", "drugs", "diamond", "ball", "bottle","seat", "dress", "book", "hoes", "bullet", "bomb", "bow", "tattoo", "grave", "cup"]
			},
			tema59: {
				id: "59",
				active: true,
				name: "Location II",
				musics: [[6388,3],[11483,2],[9009,2],[8164,2],[4292,2],[7225,2],[6557,2],[7286,2],[4950,2],[5581,1],[11578,1],[11574,1],[5132,1],[4797,1],[9983,1],[4397,1],[9072,1],[44,1],[4223,1],[8811,1]],
				content: ["top", "closer", "above", "middle", "everywhere", "nowhere", "outside", "between", "front", "somewhere","near", "ahead", "edge", "within", "underneath", "here's", "beyond", "anywhere", "wherever"]
			},
			tema9: {
				id: "9",
				active: false,
				name: "Basic verbs I",
				musics: [[11950,3],[11694,2],[11222,2],[10069,2],[8773,2],[8569,2],[8255,2],[7647,2],[7642,2],[7250,2],[7081,2],[6783,2],[6729,2],[6699,2],[6493,2],[230,2],[6326,2],[6279,2],[6367,2],[5304,1]],
				content: ["going", "feeling", "looking", "waiting", "coming", "living", "getting", "trying", "falling", "running","burning", "thinking", "making", "walking", "talking", "holding", "saying", "dancing", "taking", "giving"]
			},
			tema119: {
				id: "119",
				active: false,
				name: "There be",
				musics: [[7633,4],[11179,2],[10533,2],[8434,2],[8391,2],[8232,2],[8217,2],[6761,2],[7218,2],[480,2],[6626,2],[6576,2],[6557,2],[5132,2],[4292,2],[1251,2],[1235,2],[61,1],[11948,1],[11943,1]],
				content: ["there's", "there"]
			},
			tema77: {
				id:"77",         
				active: false,
				name: "Dolch Words - 1st Grade",
				musics: [[7400,7],[4540,7],[1772,6],[1237,5],[11948,5],[1927,5],[3711,5],[1953,5],[11911,5],[2236,5],[9745,5],[2063,5],[11824,5],[10746,5],[8306,5],[8219,5],[6709,5],[11763,4],[11744,4],[11858,1]],
				content: ["after", "again", "an", "any", "as", "ask", "by", "could", "every", "fly", "from", "give", "giving", "had", "has", "her", "him", "his", "how", "just", "know", "let", "live", "may", "of", "old", "once", "open", "over", "put", "round", "some", "stop", "take", "thank", "them", "then", "think", "walk", "were", "when"]
			},
			tema34: {
				id: "34",
				active: false,
				name: "Actions VII",
				musics: [[7472,2],[9929,2],[9727,2],[9584,2],[9193,2],[8965,2],[1462,2],[11823,2],[5270,2],[4264,2],[3072,2],[2916,2],[11622,1],[11569,1],[11568,1],[5689,1],[5695,1],[11234,1],[11233,1],[5322,1]],
				content: ["sit", "shoot", "act", "pass", "laugh", "smoke", "begin", "deny", "fill", "forgive","happen", "moves", "spend", "track", "wear", "cross", "starts", "pick", "grab", "survive"]
			},
			tema41: {
				id: "41",
				active: true,
				name: "Interjections/Greetings II",
				musics: [[1772,7],[9152,6],[8511,5],[11824,5],[3660,4],[1237,4],[8219,4],[1163,4],[8489,4],[1851,4],[8558,4],[8314,4],[9929,4],[10514,4],[11419,4],[7251,3],[6695,3],[20,3],[2076,3],[11409,1]],
				content: ["okay", "wah", "woah", "huh", "ohhh", "woohoo", "thank", "pop", "knock", "hay","c'mon", "gimme", "ho", "ooooh", "woo", "yea", "oo", "welcome", "ahh"]
			},
			tema33: {
				id: "33",
				active: false,
				name: "Adjectives III",
				musics: [[8298,3],[11621,3],[9390,3],[8480,3],[4046,3],[11444,2],[11317,2],[10963,2],[10654,2],[9251,2],[8977,2],[9881,2],[9432,2],[8334,2],[8654,2],[8239,2],[7836,2],[7771,2],[7618,2],[7496,1]],
				content: ["blue", "whole", "fool", "full", "fast", "low", "bitches", "dirty", "loud", "white","red", "perfect", "afraid", "slow", "stupid", "different", "drunk", "mad", "straight", "harder"]
			},
			tema111: {
				id: "111",
				active: false,
				name: "Possessive case",
				musics: [[1870,5],[6969,2],[11414,2],[10900,2],[4737,2],[8795,2],[8308,2],[2104,2],[8312,1],[77,1],[8488,1],[7305,1],[3647,1],[7311,1],[3043,1],[3038,1],[9179,1],[9149,1],[8761,1],[8738,1]],
				content: ["shady's", "body's", "heaven's", "body's", "heart's", "someone's", "man's", "world's", "party's", "daddy's", "baby's", "else's", "music's", "devil's", "head's", "god's", "mother's", "winter's", "father's", "girl's", "other's", "somebody's", "feeling's", "everyone's", "tomorrow's", "yesterday's", "future's", "hell's", "me's", "mind's", "sky's", "backstreet's", "lover's", "night's", "valentine's"]
			},
			tema122: {
				id: "122",
				active: false,
				name: "Object pronouns",
				musics: [[10244,8],[10249,8],[2637,7],[10272,7],[1772,6],[1850,6],[8533,6],[2174,6],[6976,6],[6135,6],[9164,6],[8494,6],[4130,6],[6625,6],[1927,5],[20,5],[1861,5],[1880,5],[11824,5],[2429,1]],
				content: ["me", "you", "him", "her", "it", "us", "you", "them"]
			},
			tema112: {
				id: "112",
				active: false,
				name: "Toys and pets",
				musics: [[7824,4],[4391,3],[8514,3],[11737,2],[11738,2],[8371,2],[11731,2],[11415,2],[10351,2],[8767,2],[2115,2],[7346,2],[6334,2],[5588,2],[4256,2],[11733,1],[5749,1],[10715,1],[10708,1],[4797,1]],
				content: ["cat", "dog", "dogs", "cats", "pigs", "pig", "fish", "bird", "birds","hummingbird", "chick", "chicks", "chicken", "snake", "monkey", "doll", "lion", "ball", "train", "horse", "castle"]
			},
			tema60: {
				id: "60",
				active: true,
				name: "Moods",
				musics: [[4807,4],[1954,4],[8124,3],[1868,3],[1097,3],[8298,3],[5651,3],[11051,2],[11082,2],[11050,2],[9557,2],[9518,2],[10370,2],[10216,2],[8195,2],[8216,2],[11674,2],[11590,2],[7569,2],[11781,1]],
				content: ["alone", "free", "dead", "alive", "alright", "ready", "happy", "full", "dirty", "afraid","drunk", "sad", "glad", "scared", "single", "broke", "empty", "stuck", "safe", "weak"]
			},
			tema61: {
				id: "61",
				active: true,
				name: "Using Objects",
				musics: [[8558,4],[910,3],[5520,3],[3756,3],[5562,3],[5409,3],[8389,3],[7093,3],[11425,3],[9020,3],[11476,2],[11166,2],[10728,2],[11623,2],[11842,2],[11644,2],[10093,2],[10519,2],[9937,2],[9891,1]],
				content: ["give", "put", "show", "shake", "touch", "open", "bring", "hide", "control", "gave","throw", "drop", "pull", "catch", "use", "carry", "rise", "push", "send", "pick","grab", "hang", "lift"]
			},
			tema101: {
				id: "101",
				active: false,
				name: "Places in a town",
				musics: [[8219,3],[1237,3],[7805,3],[8473,3],[11620,2],[11360,2],[11109,2],[11027,2],[10539,2],[9193,2],[8688,2],[9905,2],[8364,2],[8314,2],[9836,2],[8130,2],[5799,2],[7392,2],[7337,2],[7182,1]],
				content: ["home", "place", "room", "ground", "town", "road", "city", "club", "street", "house","land", "school", "streets", "places", "store", "bank", "hotel", "coffee", "shop", "church", "post", "cinema", "station", "hospital","park", "parking", "fireplace"]
			},
			tema84: {
				id:"84",
				active: false,
				name: "Present Continuous",
				musics: [[11950,3],[11734,2],[11694,2],[11222,2],[6279,2],[11146,2],[10732,2],[10688,2],[6064,2],[10574,2],[10421,2],[10233,2],[10221,2],[10069,2],[9577,2],[9260,2],[9207,2],[8984,2],[8933,2],[8773,1]],
				content: ["going", "feeling", "looking", "waiting", "coming", "living", "getting", "trying", "falling", "running", "burning", "thinking", "making", "walking", "talking", "holding", "saying", "dancing", "taking", "giving", "standing", "loving", "calling", "doing", "leaving", "breaking", "watching","telling", "losing","playing", "dying", "moving", "crying", "killing", "dreaming", "screaming", "missing", "singing", "sitting", "turning", "fighting", "lying", "shining", "beating", "having", "growing", "sleeping", "chasing", "letting", "bleeding", "breathing", "searching"]
			},
			tema26: {
				id: "26",
				active: false,
				name: "Actions VIII",
				musics: [[1879,4],[2244,3],[8395,3],[11623,2],[10999,2],[9627,2],[9891,2],[8860,2],[8800,2],[9348,2],[8246,2],[270,2],[6557,2],[8053,2],[5323,2],[2977,2],[646,2],[2336,2],[1265,2],[38,1]],
				content: ["waste", "write", "crack", "hang", "flow", "celebrate", "ends", "steal", "escape", "remind","heal", "wash", "return", "lock", "count", "cover", "dry", "race", "deal", "spin","clap", "paint", "share", "lift"]
			},
			tema107: {
				id: "107",
				active: false,
				name: "Likes and dislikes",
				musics: [[7304,5],[8353,5],[3050,4],[8333,4],[1417,3],[8441,3],[5520,3],[8818,3],[85,3],[1927,3],[8606,3],[10048,3],[7356,3],[3794,3],[3597,3],[10254,3],[5875,3],[5562,3],[2163,3],[10758,1]],
				content: ["love", "like", "adore", "adores", "likes", "loves", "hate", "mind", "minds", "dislike", "hates", "dislikes", "detest", "detests"]
			},
			tema78: {
				id:"78",
				active: false,
				name: "Dolch Words - 2nd Grade",
				musics: [[2637,6],[1878,6],[1262,5],[7199,5],[1880,5],[8243,5],[1485,4],[1685,4],[7660,4],[7751,4],[10221,4],[11461,4],[11338,4],[9244,4],[9506,4],[8473,4],[8395,4],[10666,4],[1240,4],[11544,1]],
				content: ["always", "around", "because", "been", "before", "best", "both", "buy", "call", "cold", "does", "don't", "fast", "first", "five", "found", "gave", "goes", "green", "its", "made", "many", "off", "or", "pull", "read", "right", "sing", "sit", "sleep", "tell", "their", "these", "those", "upon", "us", "use", "very", "wash", "which", "why", "wish", "work", "would", "write", "your"]
			},
			tema15: {
				id: "15",
				active: false,
				name: "Pronouns",
				musics: [[7633,4],[1331,3],[2491,3],[7811,3],[11822,2],[11645,2],[11409,2],[6969,2],[11265,2],[11038,2],[10957,2],[10483,2],[6552,2],[10417,2],[6529,2],[10407,2],[9973,2],[6610,2],[620,2],[9961,1]],
				content: ["every", "nothing", "everything", "something", "another", "other", "myself", "someone", "everybody", "yourself","nobody", "any", "anything", "somebody", "each", "such", "everyone"]
			},
			tema10: {
				id: "10",
				active: true,
				name: "Abstract Nouns II",
				musics: [[4982,3],[4278,3],[8566,3],[1292,3],[935,3],[89,3],[11146,2],[10841,2],[10270,2],[9585,2],[8130,2],[8103,2],[11822,2],[11538,2],[7955,2],[11788,2],[8617,2],[8046,2],[7273,2],[7161,1]],
				content: ["sin", "wonder", "beat", "fear", "heaven", "town", "game", "hell", "war", "beauty","chance", "music", "truth", "kind", "death", "reason", "part", "step", "waste"]
			},
			tema73: {
				id:"73",
				active: false,
				name: "Food",
				musics: [[4232,3],[8198,3],[1216,3],[4159,2],[7897,1],[5874,1],[97,1],[4797,1],[4792,1],[8627,1],[8570,1],[8633,1],[1928,1],[1932,1],[7886,1],[7807,1],[1279,1],[2916,1],[11308,1],[8866,1]],
				content: ["bread", "sugar", "water", "milk", "milky", "salt", "pizza", "coffee", "chicken", "fish", "food", "orange", "apple","banana", "strawberry"]
			},
			tema128: {
				id: "128",
				active: false,
				name: "Modal Verbs",
				musics: [[2387,3],[7405,3],[1327,3],[4029,3],[1861,3],[4223,3],[11853,2],[11934,2],[11920,2],[11895,2],[11710,2],[11483,2],[11461,2],[11729,2],[6080,2],[339,2],[11426,2],[11362,2],[483,2],[11277,1]],
				content: ["can", "could", "may", "might", "must", "mustn't", "should", "shouldn't", "ought"]
			},
			tema85: {
				id:"85",
				active: false,
				name: "Past tense",
				musics: [[7427,3],[11665,3],[6735,2],[240,2],[11650,2],[6731,2],[11426,2],[11365,2],[11297,2],[10957,2],[6279,2],[10914,2],[6144,2],[10539,2],[5985,2],[9856,2],[9599,2],[5726,2],[9080,2],[9074,1]],
				content: ["broked", "used", "wanted", "saw", "tried", "felt", "loved", "started", "tired", "went", "found", "met", "meant", "turned", "knew", "held", "learned", "called", "began", "changed", "died", "walked", "won", "kept", "looked", "lost", "needed", "kissed", "saved", "played", "locked", "passed", "asked"]
			},
			tema117: {
				id: "117",
				active: false,
				name: "Describing personality",
				musics: [[5588,3],[7643,3],[6131,3],[8420,3],[3527,3],[10830,2],[11218,2],[10963,2],[10489,2],[10462,2],[10900,2],[10437,2],[11876,2],[11308,2],[9948,2],[9881,2],[9560,2],[8477,2],[8440,2],[17,1]],
				content: ["good", "sweet", "pretty", "fun", "perfect", "lucky", "sexy", "nice", "special", "funny", "great", "bad", "crazy", "fool", "stupid", "mad", "insane", "stronger", "adorable", "kind", "calm", "quiet", "gentle", "confident", "shiny", "awful","creepy", "brave", "cruel", "honest", "selfish", "wise", "sincere", "generous", "bright", "fearless", "talented"]
			},
			tema48: {
				id: "48",
				active: true,
				name: "Body II",
				musics: [[5854,2],[8128,2],[8792,2],[6199,2],[6341,2],[11714,1],[4803,1],[7809,1],[7798,1],[7818,1],[3637,1],[7358,1],[6728,1],[6720,1],[6505,1],[6502,1],[6507,1],[5762,1],[5761,1],[11319,1]],
				content: ["knees", "mouth", "hair", "voice", "tear", "bleed", "brain", "stare", "wings", "heartbeat","scars", "bones", "finger"]
			},
			tema19: {
				id: "19",
				active: true,
				name: "Body",
				musics: [[7633,7],[3267,5],[11746,5],[4276,5],[1585,5],[9707,5],[2356,5],[11645,5],[1485,5],[11822,4],[7348,4],[11444,4],[2490,4],[11362,4],[3010,4],[170,4],[2290,4],[2328,4],[7590,4],[3824,1]],
				content: ["eye", "hand", "head", "face", "pain", "tear", "body", "blood", "arm", "voice","feet", "blind"]
			},
			tema19: {
				id: "19",
				active: true,
				name: "Body",
				musics: [[7633,7],[3267,5],[11746,5],[4276,5],[1585,5],[9707,5],[2356,5],[11645,5],[1485,5],[11822,4],[7348,4],[11444,4],[2490,4],[11362,4],[3010,4],[170,4],[2290,4],[2328,4],[7590,4],[3824,1]],
				content: ["eye", "hand", "head", "face", "pain", "tear", "body", "blood", "arm", "voice","feet", "blind"]
			},
			tema62: {
				id: "62",
				active: true,
				name: "Movements",
				musics: [[8210,5],[1228,5],[2236,4],[10766,4],[9621,4],[8610,4],[6696,4],[1301,4],[7722,4],[2235,3],[2421,3],[2095,3],[2306,3],[2091,3],[1313,3],[11765,3],[86,3],[2783,3],[1286,3],[2854,1]],
				content: ["go", "come", "turn", "stop", "run", "leave", "fall", "stay", "walk", "stand","fly", "wait", "comes", "move", "jump", "follow", "pass", "moves", "track", "cross","flow", "escape", "return", "spin"]
			},
			tema24: {
				id: "24",
				active: true,
				name: "People/Beings",
				musics: [[1870,5],[2637,4],[2306,3],[3708,3],[2651,3],[9358,2],[9802,2],[9235,2],[9750,2],[10048,2],[8155,2],[8795,2],[9122,2],[8439,2],[5929,2],[5927,2],[1207,2],[8189,2],[7405,2],[3010,1]],
				content: ["dj", "son", "kids", "men", "angels", "evil", "father", "guy", "queen", "stranger","angel", "lord", "children", "women", "devil", "jesus", "family", "human", "hero", "couple","lovers", "brother", "killer", "pa'"]
			},
			tema97: {
				id: "97",
				active: false,
				name: "Possessive adjectives",
				musics: [[5278,5],[1852,5],[8895,4],[5562,4],[7633,4],[5520,4],[910,4],[10666,4],[11313,4],[8459,4],[1262,4],[8243,4],[4514,4],[11824,4],[10915,4],[2112,4],[1853,4],[6792,3],[6789,3],[6091,1]],
				content: ["my", "your", "his", "her", "its", "their", "our"]
			},
			tema11: {
				id: "11",
				active: false,
				name: "Adjectives II",
				musics: [[4807,4],[8487,3],[8124,3],[5030,3],[3527,3],[1868,3],[7087,3],[11460,2],[11496,2],[11775,2],[11762,2],[11050,2],[11317,2],[11188,2],[11082,2],[9762,2],[11027,2],[9383,2],[9214,2],[9193,1]],
				content: ["best", "sure", "deep", "alright", "happy", "fool", "lone", "ready", "crazy", "young","bitch", "broken", "easy", "whole", "alive", "fine", "strong", "next", "final"]
			},
			tema80: {
				id:"80",
				active: false,
				name: "Dolch words - Nouns I",
				musics: [[4807,4],[7824,4],[3299,3],[8395,3],[4253,3],[7825,3],[777,3],[9920,3],[9929,3],[1927,3],[7093,3],[3179,3],[6328,3],[10763,3],[3219,3],[8454,3],[9390,3],[4582,3],[9621,3],[6280,1]],
				content: ["apple", "baby", "back", "ball", "bear", "bed", "bell", "bird", "birthday", "boat", "box", "boy", "bread", "brother", "cake", "car", "cat", "chair", "chicken", "children", "Christmas", "coat", "corn", "cow", "day", "dog", "doll", "door", "duck", "egg", "eye", "farm", "farmer"]
			},	
			tema64: {
				id: "64",
				active: true,
				name: "Properties",
				musics: [[9622,4],[2375,3],[11797,3],[9707,3],[11617,3],[5030,3],[6138,3],[8472,3],[1920,3],[1237,3],[8219,3],[7087,3],[11333,2],[11342,2],[11393,2],[11414,2],[10841,2],[11804,2],[11082,2],[11682,1]],
				content: ["new", "own", "real", "TRUE", "old", "next", "sure", "easy", "wild", "whole","different", "crowd", "strange", "supposed", "fake", "awake", "final", "tough", "holy", "fair"]
			},
			tema28: {
				id: "28",
				active: true,
				name: "Thoughts/Feelings",
				musics: [[7304,5],[11911,5],[8353,5],[2493,4],[8459,4],[10356,4],[8333,4],[8361,4],[11953,3],[3152,3],[3288,3],[3065,3],[3050,3],[3041,3],[3053,3],[3597,3],[3656,3],[2749,3],[11166,3],[3756,1]],
				content: ["love", "know", "want", "wanna", "feel", "need", "keep", "believe", "hold", "wish","remember", "feels", "hope", "forget", "mean", "knew", "hate", "knows", "matter", "miss"]
			},
			tema35: {
				id: "35",
				active: false,
				name: "Actions VI",
				musics: [[8124,3],[1868,3],[11781,2],[11729,2],[11748,2],[11655,2],[11050,2],[10949,2],[11377,2],[10170,2],[10359,2],[9776,2],[9738,2],[9109,2],[8571,2],[8390,2],[10073,2],[8359,2],[8308,2],[8194,1]],
				content: ["cut", "raise", "pray", "push", "check", "become", "send", "read", "reach", "win","shout", "grow", "hurts", "fade", "speak", "lead", "bet", "pretend", "buy", "looks"]
			},
			tema110: {
				id: "110",
				active: false,
				name: "Objects",
				musics: [[8261,6],[1280,6],[8298,3],[7825,3],[777,3],[8939,2],[8884,2],[10216,2],[11861,2],[11224,2],[8389,2],[8314,2],[8807,2],[8767,2],[8573,2],[8228,2],[7853,2],[28,2],[6897,2],[7659,1]],
				content: ["money", "phone", "ring", "clothes", "drugs", "dress", "book", "cup", "bed", "car", "wall", "walls", "mirror", "glass", "picture", "train", "radio", "bottles", "window", "piece", "ball", "bottle", "bow", "lights"]
			},
			tema44: {
				id: "44",
				active: true,
				name: "Thoughts/Feelings II",
				musics: [[11950,3],[10440,2],[9506,2],[8970,2],[8773,2],[8695,2],[8342,2],[196,2],[8108,2],[5695,2],[4090,2],[2523,2],[2508,2],[2334,2],[400,2],[5437,1],[5318,1],[11063,1],[11018,1],[11014,1]],
				content: ["understand", "seems", "trust", "wants", "seem", "worth", "loves", "faith", "worry", "turns","means", "realize", "feelings", "treat", "deserve", "desire"]
			},
			tema46: {
				id: "46",
				active: true,
				name: "Places",
				musics: [[1870,5],[1237,4],[8219,4],[9152,3],[8473,3],[7805,3],[10393,2],[9193,2],[11027,2],[9905,2],[9836,2],[8364,2],[8314,2],[11360,2],[8368,2],[7392,2],[11620,2],[7337,2],[7182,2],[6984,1]],
				content: ["home", "room", "ground", "road", "city", "club", "street", "house", "land", "school","streets", "places", "hollywood", "den", "york"]
			},
			tema88: {
				id:"88",
				active: false,
				name: "Subject pronouns",
				musics: [[3474,11],[4791,10],[1871,9],[2433,9],[2452,8],[7407,8],[8353,8],[8138,8],[7839,7],[2491,7],[2474,7],[2485,7],[7402,7],[7400,7],[6444,7],[4946,7],[2459,7],[2439,7],[4540,7],[2443,1]],
				content: ["I", "You", "He", "She", "It", "We", "You", "They"]
			},
			tema38: {
				id: "38",
				active: false,
				name: "Concepts II",
				musics: [[3488,3],[1292,3],[8479,3],[7824,3],[11538,2],[10970,2],[11890,2],[11876,2],[10841,2],[10270,2],[10264,2],[11146,2],[9585,2],[5459,2],[8215,2],[8130,2],[7955,2],[3092,2],[7729,2],[7694,1]],
				content: ["game", "truth", "kind", "death", "word", "smile", "fear", "ride", "war", "music","part", "town", "heaven", "reason", "taste", "wonder", "trouble", "mess", "sin", "bout"]
			},
			tema12: {
				id: "12",
				active: true,
				name: "Time",
				musics: [[4303,4],[10768,4],[2163,3],[2244,3],[2306,3],[2545,3],[3673,3],[11838,3],[4380,3],[4483,3],[1625,3],[4717,3],[8096,3],[7430,3],[8040,3],[9874,3],[4787,3],[9804,3],[5113,3],[1393,1]],
				content: ["now", "never", "night", "tonight", "again", "ever", "then", "still", "always", "before","forever", "after", "today", "once", "sometimes", "moment", "anymore", "late", "morning", "tomorrow"]
			},
			tema56: {
				id: "56",
				active: true,
				name: "Talking",
				musics: [[89,3],[11203,2],[11039,2],[10534,2],[10051,2],[9951,2],[9926,2],[9109,2],[9074,2],[8980,2],[4875,2],[8568,2],[8479,2],[8423,2],[7838,2],[7594,2],[7472,2],[7328,2],[6133,2],[11892,1]],
				content: ["say", "tell", "said", "hear", "call", "lie", "talk", "told", "lies", "guess","heard", "listen", "ask", "promise", "says", "swear", "scream", "shut", "shout", "speak"]
			},
			tema108: {
				id: "108",
				active: false,
				name: "Modal verbs",
				musics: [[5582,3],[9225,3],[1249,3],[5683,3],[4223,3],[11873,3],[1327,3],[1753,3],[1861,3],[4029,3],[4010,3],[9157,3],[6280,3],[2387,3],[2558,3],[3196,3],[11710,3],[7388,3],[2700,3],[8230,1]],
				content:  ["can", "could", "may", "might", "must", "shall", "will", "should", "ought", "would", "can't", "I'd", "wouldn't", "couldn't", "we'd", "should've", "shouldn't"]
			},
			tema58: {
				id: "58",
				active: true,
				name: "Abstract Nouns III",
				musics: [[8149,5],[1863,3],[10514,3],[20,3],[11877,2],[11915,2],[11924,2],[11827,2],[11614,2],[11875,2],[11838,2],[11423,2],[6792,2],[11415,2],[11218,2],[11177,2],[10573,2],[10538,2],[5225,2],[9746,1]],
				content: ["shame", "thoughts", "freedom", "memory", "bout", "ego", "kick", "beauty", "problem", "attack","fate", "price", "message", "wit", "luck", "doubt", "life's", "misery", "sense"]
			},
			tema123: {
				id: "123",
				active: false,
				name: "Articles/Indefinites",
				musics: [[8245,14],[1264,14],[8138,8],[10249,8],[3643,8],[1144,8],[10244,8],[1132,8],[11438,8],[1107,7],[4700,7],[4877,7],[4758,7],[4450,7],[5146,7],[1166,7],[1146,7],[1157,7],[6444,7],[1484,1]],
				content: ["the", "a", "an", "some", "any", "no"]
			},
			tema83: {
				id:"83",
				active: false,
				name: "Present Simple",
				musics: [[3474,11],[7667,5],[1228,5],[10231,5],[8210,5],[849,4],[519,4],[238,4],[11177,4],[6280,4],[9934,4],[3588,4],[3728,4],[4028,4],[6696,4],[5018,4],[8496,4],[7722,4],[7806,4],[10215,1]],
				content: ["get", "gets", "take", "takes", "brush", "brushes", "shave", "shaves", "wash", "washes", "put", "puts", "go", "goes", "sleep", "sleeps", "make", "makes", "cook", "cooks", "eat", "eats", "have", "has", "drink", "drinks", "clean", "cleans", "do", "does", "study", "studies", "drive", "drives", "come", "comes", "leave", "leaves", "check", "checks"]
			},
			tema127: {
				id: "127",
				active: false,
				name: "Infinitive and Gerund",
				musics: [[11950,3],[11694,2],[11222,2],[10069,2],[9577,2],[8984,2],[8773,2],[6279,2],[8569,2],[8390,2],[8350,2],[8255,2],[7647,2],[7642,2],[7365,2],[7261,2],[7250,2],[7081,2],[6783,2],[6729,1]],
				content: ["going", "feeling", "looking", "waiting", "coming","living", "getting", "trying", "falling", "running","burning", "thinking", "making", "walking", "talking","holding", "saying", "dancing", "taking", "giving","standing", "loving", "calling", "doing", "leaving"]
			},
			tema134: {
				id: "134",
				active: false,
				name: "Articles",
				musics: [[1264,14],[8245,14],[1132,8],[8138,8],[1144,8],[10249,8],[10244,8],[11438,8],[1107,7],[1146,7],[1157,7],[1772,7],[1851,7],[1859,7],[2722,7],[1166,7],[1484,7],[4286,7],[4450,7],[4758,1]],
				content: ["a", "an", "the"]
			},
			tema115: {
				id: "115",
				active: false,
				name: "Quantifiers",
				musics: [[8489,9],[1125,8],[1163,8],[2244,8],[7617,7],[7832,7],[4467,7],[8352,7],[10758,7],[7633,7],[5318,7],[9547,7],[11873,7],[2093,6],[2208,6],[2163,6],[11746,6],[1585,6],[3059,6],[2236,1]],
				content: ["much", "many", "lot", "few", "both", "enough", "some", "any", "several", "none", "every", "each", "all", "little", "no"]
			},
			tema115: {
				id: "115",
				active: false,
				name: "Quantifiers",
				musics: [[8489,9],[1125,8],[1163,8],[2244,8],[7617,7],[7832,7],[4467,7],[8352,7],[10758,7],[7633,7],[5318,7],[9547,7],[11873,7],[2093,6],[2208,6],[2163,6],[11746,6],[1585,6],[3059,6],[2236,1]],
				content: ["much", "many", "lot", "few", "both", "enough", "some", "any", "several", "none", "every", "each", "all", "little", "no"]
			},
			tema49: {
				id: "49",
				active: true,
				name: "Conjunctions",
				musics: [[2490,11],[4024,11],[1162,11],[7199,11],[1178,10],[1262,10],[8243,10],[8080,10],[5321,10],[2439,10],[5328,10],[10775,10],[4385,10],[4188,10],[10923,9],[379,9],[8652,9],[10735,9],[7369,9],[1143,1]],
				content: ["and", "but", "if", "or", "than", "n", "while", "though", "whatever"]
			},
			tema49: {
				id: "49",
				active: true,
				name: "Conjunctions",
				musics: [[2490,11],[4024,11],[1162,11],[7199,11],[1178,10],[1262,10],[8243,10],[8080,10],[5321,10],[2439,10],[5328,10],[10775,10],[4385,10],[4188,10],[10923,9],[379,9],[8652,9],[10735,9],[7369,9],[1143,1]],
				content: ["and", "but", "if", "or", "than", "n", "while", "though", "whatever"]
			},
			tema72: {
				id:"72",
				active: false,
				name: "Clothing",
				musics: [[11738,3],[9390,3],[4870,3],[4792,3],[10200,3],[6461,3],[11895,2],[11934,2],[11915,2],[11933,2],[11592,2],[10906,2],[11616,2],[10900,2],[11490,2],[10586,2],[10570,2],[10518,2],[11172,2],[10371,1]],
				content: ["dress", "shirt", "pants", "coat", "skirt", "tie", "boots", "glasses", "bag", "hat", "sweater", "suit"]
			},
			tema91: {
				id:"91",
				active: false,
				name: "Short answers",
				musics: [[3474,11],[4791,10],[1871,9],[2433,9],[7407,8],[8138,8],[7839,8],[2452,8],[11400,8],[8353,8],[10514,7],[2485,7],[8510,7],[7402,7],[7400,7],[7369,7],[238,7],[2338,7],[6444,7],[10231,1]],
				content: ["do", "am", "I", "Yes", "No", "don't", "not", "she's", "he's", "you","are", "she", "he", "they", "they're", "doesn't", "does", "aren't"]
			},
			tema90: {
				id:"90",
				active: false,
				name: "Indefinite articles",
				musics: [[1264,14],[8245,14],[1132,8],[11438,8],[1144,8],[10249,8],[8138,8],[10244,8],[2722,7],[7400,7],[3643,7],[1859,7],[5540,7],[4286,7],[1484,7],[4450,7],[8080,7],[1107,7],[10428,7],[4758,1]],
				content: ["a", "an"]
			},
			tema89: {
				id:"89",
				active: false,
				name: "Verb be",
				musics: [[8138,6],[2451,6],[8261,5],[1280,5],[1880,5],[11948,5],[1852,5],[11400,5],[11056,4],[1297,4],[4792,4],[659,4],[238,4],[4977,4],[7811,4],[7803,4],[7633,4],[7339,4],[7337,4],[10666,1]],
				content: ["I'm", "be", "is", "it's", "you're", "are", "she's", "im", "we're", "there's", "that's", "he's", "they're", "isn't", "aren't"]
			},
			tema40: {
				id: "40",
				active: false,
				name: "Concepts IV",
				musics: [[8149,5],[9909,3],[10514,3],[20,3],[1863,3],[11827,2],[11614,2],[11875,2],[11838,2],[11877,2],[11924,2],[10573,2],[11218,2],[10538,2],[11423,2],[11177,2],[9746,2],[9392,2],[8770,2],[8609,1]],
				content: ["kick", "beauty", "problem", "attack", "fate", "price", "love's", "message", "wit", "luck","doubt", "fantasy", "romance", "songs", "movie", "life's", "misery", "sense", "fame", "games"]
			},
			tema75: {
				id:"75",      
				active: false,
				name: "Dolch Words - Pre-primer",
				musics: [[1264,14],[8245,14],[1871,12],[3474,11],[4791,10],[7407,9],[2722,9],[1144,9],[2452,9],[2433,9],[7839,9],[1146,9],[7368,9],[2338,8],[10244,8],[2472,8],[8138,8],[11438,8],[4540,8],[1132,1]],
				content: ["a", "and", "away", "big", "blue", "can", "come", "down", "find", "for", "funny", "go", "help", "here", "I", "in", "is", "it", "jump", "little", "look", "make", "me", "my", "not", "one", "play", "red", "run", "said", "see", "the", "three", "to", "two", "up", "we", "where", "yellow", "you"]
			},
			tema31: {
				id: "31",
				active: true,
				name: "Interjections/Greetings",
				musics: [[4143,29],[4791,9],[1772,7],[2469,7],[1262,5],[8243,5],[9929,4],[455,4],[2463,4],[11517,4],[2251,4],[7835,4],[11643,4],[11505,4],[89,4],[1163,4],[5402,4],[4807,4],[1360,4],[6954,1]],
				content: ["oh", "yeah", "hey", "ooh", "ah", "uh", "please", "goodbye", "eh", "boom","damn", "whoa", "hello", "sorry", "bye", "oooh", "ha", "ohh", "fucking", "ok"]
			},
			tema125: {
				id: "125",
				active: false,
				name: "Passive Voice",
				musics: [[7427,3],[7392,2],[11650,2],[11365,2],[6731,2],[11297,2],[9843,2],[9074,2],[8707,2],[8400,2],[7780,2],[7462,2],[5323,2],[155,2],[3654,2],[2585,2],[5985,2],[5726,2],[5419,2],[2079,1]],
				content: ["loved", "given", "sent", "made", "used", "shown","told", "taugth", "taken", "felt", "called", "turned", "known", "started", "caught", "tried", "seen", "wanted", "broken", "turned", "changed", "kept", "saved", "played", "won", "held"]
			},
			tema36: {
				id: "36",
				active: false,
				name: "Actions V",
				musics: [[1855,3],[5187,2],[170,2],[11876,2],[11861,2],[11822,2],[11804,2],[11773,2],[11324,2],[11278,2],[4317,2],[11166,2],[10952,2],[4291,2],[9251,2],[9194,2],[9109,2],[4110,2],[9078,2],[8462,1]],
				content: ["saw", "pull", "says", "catch", "shot", "breath", "jump", "use", "born", "swear","scream", "eat", "carry", "follow", "rest", "keeps", "shut", "learn", "pay", "rise"]
			},
			tema103: {
				id: "103",
				active: false,
				name: "Prepositions of time",
				musics: [[1850,6],[6976,6],[6625,6],[8533,6],[6135,6],[4130,6],[8494,6],[1859,6],[9164,6],[1878,6],[2174,6],[1265,5],[10924,5],[891,5],[1280,5],[8261,5],[8511,5],[5615,5],[1880,5],[8246,1]],
				content:  ["in", "at", "on", "until", "after", "around", "before", "between", "ago", "past", "until", "till", "soon", "then", "into", "now", "long"]
			},
			tema16: {
				id: "16",
				active: true,
				name: "Basic Verbs II",
				musics: [[1861,3],[9577,2],[7614,2],[7365,2],[497,2],[3610,2],[3053,2],[2171,2],[4872,2],[5689,1],[9621,1],[9619,1],[9155,1],[9149,1],[4497,1],[9100,1],[9096,1],[8986,1],[8984,1],[4379,1]],
				content: ["standing", "loving", "calling", "doing", "leaving", "i'mma", "being", "gon'", "breaking", "watching","goin'", "losing", "playing", "dying", "moving", "lovin'", "crying", "killing", "telling", "dreaming"]
			},
			tema14: {
				id: "14",
				active: true,
				name: "Location",
				musics: [[1878,6],[6625,6],[8533,6],[2174,6],[8494,6],[4130,6],[1850,6],[1859,6],[6976,6],[9164,6],[6135,6],[1280,5],[10924,5],[1265,5],[2063,5],[10514,5],[891,5],[20,5],[1880,5],[11449,1]],
				content: ["in", "on", "up", "out", "down", "back", "away", "at", "right", "here","there", "into", "inside", "left", "side", "close", "far", "under", "behind", "round"]
			},
			tema92: {
				id:"92",
				active: false,
				name: "Adverbs of place",
				musics: [[11739,5],[9786,4],[7633,4],[373,3],[549,3],[11861,3],[4290,3],[4391,3],[1228,3],[5480,3],[10258,3],[8472,3],[4294,3],[1251,3],[17,3],[9977,3],[11449,3],[8232,3],[7093,3],[1311,1]],
				content: ["above", "down", "inside", "anywhere", "everywhere", "outside", "away", "here", "there", "backward","backwards", "near", "far", "up", "upstairs", "downstairs", "sideways", "around", "back", "round", "behind", "under","far", "close", "there", "under", "over", "nearby", "somewhere", "nowhere", "westwards", "upwards", "homewards"]
			},
			tema118: {
				id: "118",
				active: false,
				name: "Family and people",
				musics: [[7606,3],[7417,3],[5944,3],[5324,3],[1097,3],[9929,3],[9920,3],[1897,3],[7800,3],[7093,3],[6696,3],[1927,3],[9582,3],[10256,2],[10261,2],[10223,2],[10271,2],[11229,2],[11065,2],[10772,1]],
				content: ["sons", "daughter", "father", "mother", "baby", "girl", "girls", "boy", "boys", "mama", "child", "daddy", "son","kids", "children", "family", "women", "man", "men", "women", "couple", "brother", "sister"]
			},
			tema21: {
				id: "21",
				active: true,
				name: "Numbers/Quantities",
				musics: [[8511,5],[8741,4],[8489,4],[11873,4],[1590,3],[2867,3],[7427,3],[7273,3],[8487,3],[9762,3],[6610,3],[3991,3],[407,3],[6091,3],[4046,3],[8128,3],[11645,3],[4236,3],[4691,3],[5983,1]],
				content: ["one", "more", "only", "some", "much", "enough", "two", "times", "first", "many","bit", "three", "both", "lot", "very", "thousand", "hundred", "four", "second", "less","most", "half", "million", "number", "five", "miles", "six", "few"]
			},
			tema20: {
				id: "20",
				active: true,
				name: "Personal Pronouns",
				musics: [[3474,11],[4791,10],[2433,9],[1871,9],[10244,8],[2452,8],[4946,8],[8138,8],[10249,8],[7407,8],[7839,8],[8353,8],[10272,7],[10514,7],[8510,7],[6444,7],[2439,7],[2474,7],[7722,7],[7414,1]],
				content: ["you", "i", "me", "it", "my", "your", "we", "they", "she", "her","he", "our", "us", "them", "his", "myself", "mine", "him", "yourself", "their","its", "yours", "y'all", "mr"]
			},
			tema69: {
				id:"69", 
				active: false,
				name: "Adjectives",
				musics: [[7643,6],[6131,5],[8390,5],[1284,5],[9948,5],[8420,5],[8368,5],[2084,5],[3650,5],[393,4],[8477,4],[8418,4],[8430,4],[261,4],[7129,4],[2196,4],[8361,4],[2220,4],[2369,4],[8147,1]],
				content: ["good", "better", "beautiful", "best", "sweet", "strong", "pretty", "fine", "fun", "perfect", "lucky", "darling", "magic", "nice", "dear", "special", "simple", "funny", "great", "insane", "poor", "mad", "slow", "stupid", "low", "fool", "crazy", "bad", "hard", "fair", "soft", "elegant", "confident", "shiny", "lovely"]
			},
			tema69: {
				id:"69", 
				active: false,
				name: "Adjectives",
				musics: [[7643,6],[6131,5],[8390,5],[1284,5],[9948,5],[8420,5],[8368,5],[2084,5],[3650,5],[393,4],[8477,4],[8418,4],[8430,4],[261,4],[7129,4],[2196,4],[8361,4],[2220,4],[2369,4],[8147,1]],
				content: ["good", "better", "beautiful", "best", "sweet", "strong", "pretty", "fine", "fun", "perfect", "lucky", "darling", "magic", "nice", "dear", "special", "simple", "funny", "great", "insane", "poor", "mad", "slow", "stupid", "low", "fool", "crazy", "bad", "hard", "fair", "soft", "elegant", "confident", "shiny", "lovely"]
			},
			tema131: {
				id: "131",
				active: false,
				name: "Personal and possessive pronouns",
				musics: [[3474,11],[4791,10],[2433,9],[1871,9],[10244,8],[2452,8],[4946,8],[8138,8],[10249,8],[7407,8],[7839,8],[8353,8],[10272,7],[10514,7],[8510,7],[6444,7],[4540,7],[2469,7],[7722,7],[7414,1]],
				content: ["I", "You", "He", "She", "It", "We", "You", "They","my", "your", "his", "her", "its", "their", "our","me", "you", "him", "her", "it", "us", "you", "them"]
			},
			tema124: {
				id: "124",
				active: false,
				name: "Indefinites - Compounds",
				musics: [[7633,4],[6969,2],[11265,2],[9916,2],[9512,2],[8980,2],[8807,2],[8247,2],[11645,2],[7829,2],[7655,2],[4725,2],[547,2],[3824,2],[6810,2],[6610,2],[1585,2],[2208,2],[1266,2],[1331,1]],
				content: ["somebody", "someone", "anybody", "anyone", "anything", "nobody", "none", "nothing","everybody", "everyone", "everything"]
			},
			tema113: {
				id: "113",
				active: false,
				name: "Electronics and clothes",
				musics: [[11738,3],[10200,3],[9390,3],[4792,3],[4870,3],[6461,3],[11915,2],[11821,2],[11895,2],[11,2],[11933,2],[11592,2],[16,2],[11490,2],[11934,2],[11224,2],[11172,2],[10906,2],[11616,2],[7270,1]],
				content: ["lights", "phone", "ring", "radio", "dress", "shirt", "pants", "coat", "skirt", "tie", "tv", "boots", "glasses", "bag", "hat", "sweater", "suit"]
			},
			tema94: {
				id: "94",
				active: false,
				name: "Basic questions",
				musics: [[10231,5],[7667,5],[3588,4],[3794,4],[8558,4],[4028,4],[238,4],[7806,4],[11310,3],[11629,3],[11338,3],[11169,3],[11452,3],[10775,3],[11292,3],[10829,3],[10432,3],[10428,3],[11797,3],[9934,1]],
				content: ["what", "when", "how", "cause", "where", "who", "why", "what's", "where's", "because", "who's", "cuz", "which", "answer", "asking", "do", "did", "whose"]
			},
			tema63: {
				id: "63",
				active: true,
				name: "People/Beings II",
				musics: [[1870,5],[2637,4],[2306,3],[3708,3],[2651,3],[9358,2],[9802,2],[9235,2],[9750,2],[10048,2],[8155,2],[8795,2],[9122,2],[8439,2],[5929,2],[5927,2],[1207,2],[8189,2],[7405,2],[3010,1]],
				content: ["dj", "son", "kids", "men", "angels", "evil", "father", "guy", "queen", "stranger","angel", "lord", "children", "women", "devil", "jesus", "family", "human", "hero", "couple","lovers", "brother", "killer", "pa'"]
			},
			tema54: {
				id: "54",
				active: true,
				name: "Art/Entertainment",
				musics: [[3472,50],[1856,4],[11638,4],[11739,3],[7803,3],[5585,3],[1292,3],[4982,3],[7805,3],[9909,3],[8479,3],[7824,2],[10264,2],[10270,2],[8103,2],[7813,2],[7811,2],[10970,2],[7955,2],[8046,1]],
				content: ["rock", "party", "beat", "words", "song", "game", "word", "music", "story", "style","fantasy", "romance", "songs", "movie", "fame", "games"]
			},
			tema55: {
				id: "55",
				active: true,
				name: "Routine",
				musics: [[3474,11],[7978,5],[1868,3],[7806,3],[4317,3],[268,3],[8124,3],[8395,3],[11538,2],[11506,2],[11362,2],[11451,2],[11897,2],[11594,2],[10999,2],[10420,2],[9003,2],[11781,2],[8204,2],[11729,1]],
				content: ["dance", "play", "fight", "fuck", "sing", "work", "watch", "drink", "drive", "learn","pray", "read", "act", "smoke", "write", "celebrate", "wash", "count", "race", "paint"]
			},
			tema96: {
				id: "96",
				active: false,
				name: "Numbers 0-12",
				musics: [[8511,5],[8741,4],[8311,3],[2867,3],[7676,3],[8487,3],[5325,3],[9762,3],[11496,2],[11488,2],[11809,2],[11916,2],[11113,2],[11888,2],[9804,2],[11082,2],[9692,2],[9607,2],[8976,2],[8809,1]],
				content: ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten","eleven", "twelve"]
			},
			tema53: {
				id: "53",
				active: true,
				name: "Actions upon things",
				musics: [[9452,3],[7825,3],[1861,3],[11800,2],[11763,2],[11748,2],[11616,2],[11034,2],[11474,2],[10915,2],[10359,2],[11467,2],[10205,2],[11031,2],[10112,2],[10073,2],[10048,2],[10267,2],[28,2],[9949,1]],
				content: ["break", "lost", "care", "lose", "save", "burn", "hit", "kill", "hurt", "meet","pay", "cut", "win", "hurts", "buy", "shoot", "fill", "wear", "waste", "crack","heal", "lock", "cover", "dry", "deal", "share"]
			},
			tema130: {
				id: "130",
				active: false,
				name: "Wh-/How questions",
				musics: [[3474,11],[8138,8],[1280,7],[8261,7],[8067,6],[7667,6],[238,6],[1772,6],[5559,6],[5547,6],[2466,6],[8510,6],[5146,6],[4286,6],[8652,6],[10761,6],[2438,6],[1160,6],[2725,6],[10428,1]],
				content: ["what", "when", "how", "cause", "where", "who", "why", "what's", "where's", "because", "who's", "cuz", "which", "answer", "asking", "do", "d"]
			},
			﻿tema67: {
				id:"67",      
				active: false,
				name: "Numbers",
				musics: [[8511,10],[8741,8],[8487,6],[9762,6],[8009,5],[8311,5],[7427,5],[5183,5],[5325,5],[7676,5],[6450,5],[7273,5],[4046,5],[1460,5],[8563,5],[2867,5],[7846,5],[4684,5],[8514,5],[497,1]],
				content: ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven","twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "forty", "twenty", "nineteen", "fifty", "hundred", "thousand", "milion", "first", "second", "third", "fourth"]
			},
			﻿tema67: {
				id:"67",      
				active: false,
				name: "Numbers",
				musics: [[8511,10],[8741,8],[8487,6],[9762,6],[8009,5],[8311,5],[7427,5],[5183,5],[5325,5],[7676,5],[6450,5],[7273,5],[4046,5],[1460,5],[8563,5],[2867,5],[7846,5],[4684,5],[8514,5],[497,1]],
				content: ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven","twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "forty", "twenty", "nineteen", "fifty", "hundred", "thousand", "milion", "first", "second", "third", "fourth"]
			},
			tema18: {
				id: "18",
				active: true,
				name: "Prepositions",
				musics: [[891,9],[1871,8],[5615,8],[2916,8],[4239,8],[6499,8],[10775,7],[6453,7],[5537,7],[6595,7],[6503,7],[3743,7],[946,7],[1240,7],[8741,7],[8222,7],[1859,7],[11476,7],[11567,7],[2486,1]],
				content: ["to", "of", "for", "with", "from", "as", "by", "through", "about", "without","till", "until", "along", "til"]
			},
			tema18: {
				id: "18",
				active: true,
				name: "Prepositions",
				musics: [[891,9],[1871,8],[5615,8],[2916,8],[4239,8],[6499,8],[10775,7],[6453,7],[5537,7],[6595,7],[6503,7],[3743,7],[946,7],[1240,7],[8741,7],[8222,7],[1859,7],[11476,7],[11567,7],[2486,1]],
				content: ["to", "of", "for", "with", "from", "as", "by", "through", "about", "without","till", "until", "along", "til"]
			},
			tema79: {
				id:"79",
				active: false,
				name: "Dolch words - 3rd Grade",
				musics: [[2236,5],[8558,5],[8716,4],[8489,4],[9786,4],[5840,4],[5325,3],[5511,3],[6091,3],[5689,3],[4585,3],[4394,3],[4295,3],[6552,3],[5116,3],[5304,3],[4272,3],[5113,3],[4271,3],[6729,1]],
				content: ["about", "better", "bring", "carry", "clean", "cut", "done", "draw", "drink", "eight", "fall", "far", "full", "got", "grow", "hold", "hot", "hurt", "if", "keep", "kind", "laugh", "light", "long", "much", "myself", "never", "only", "own", "pick", "seven", "shall", "show", "six", "small", "start", "ten", "today", "together", "try", "warm"]
			},
			tema13: {
				id: "13",
				active: true,
				name: "Adverbs",
				musics: [[1262,5],[238,5],[8489,5],[8243,5],[2705,5],[2244,5],[1160,4],[1163,4],[1251,4],[11873,4],[5795,4],[1853,4],[1954,4],[11582,4],[9786,4],[9762,4],[10773,4],[11621,4],[2311,4],[2385,1]],
				content: ["all", "so", "like", "no", "just", "not", "over", "too", "around", "really","off", "well", "even", "maybe", "together", "yes", "else", "lonely", "apart", "kinda","anyway", "almost", "rather", "somehow", "slowly"]
			},
			tema102: {
				id: "102",
				active: false,
				name: "Opinion",
				musics: [[7388,3],[11689,2],[11543,2],[11166,2],[10743,2],[10354,2],[5984,2],[10254,2],[9626,2],[9618,2],[9560,2],[9380,2],[9083,2],[8773,2],[8214,2],[8181,2],[8173,2],[2385,2],[7794,2],[7392,1]],
				content: ["agree", "believe", "sure", "feel", "think"]
			},
			tema93: {
				id: "93",
				active: false,
				name: "Feelings adjectives",
				musics: [[4807,4],[8472,3],[11804,2],[11414,2],[10964,2],[9806,2],[9146,2],[9929,2],[8833,2],[7982,2],[7771,2],[7226,2],[742,2],[6740,2],[6585,2],[7086,2],[4586,2],[2964,2],[2503,2],[2494,1]],
				content: ["happy", "afraid", "sad", "glad", "scared", "feeling", "angry", "bad", "excited", "scared","satisfied", "down", "Mad", "furious", "upset", "tense", "nervous", "anxious", "tender", "kind", "pleased","agressive", "confident", "envious", "guilty", "joyful", "lonely", "suspicious", "jealous", "brave", "bored", "eager", "evil", "fair", "funny"]
			},
			tema116: {
				id: "116",
				active: false,
				name: "Describing appearance",
				musics: [[5840,4],[7633,4],[4758,4],[1485,3],[2486,3],[4046,3],[4688,3],[5849,3],[5645,3],[709,3],[1331,3],[5935,3],[9707,3],[11645,3],[11689,3],[11793,3],[6348,3],[7348,3],[10693,3],[7805,1]],
				content: ["fat", "thin", "tall", "black", "white", "red", "grey", "brown", "long", "dark", "high", "young", "deep", "blue", "straight", "tight", "clear", "stronger", "wide", "green", "small", "short", "round", "eyes", "head","face", "hand", "body", "arms", "feet", "eye", "skin", "knees", "mouth", "hair", "voice", "finger"]
			},
			tema25: {
				id: "25",
				active: false,
				name: "Adjectives V",
				musics: [[3597,3],[2063,3],[10841,2],[10760,2],[8860,2],[8368,2],[8668,2],[7872,2],[8173,2],[6064,2],[5698,2],[710,2],[6346,2],[3295,2],[2861,2],[2375,2],[3637,2],[1903,2],[1981,2],[1192,1]],
				content: ["dear", "special", "simple", "wide", "faster", "strange", "deeper", "supposed", "safe", "fake","awake", "worst", "silent", "final", "tough", "green", "funny", "holy", "small", "fair","weak", "great", "round", "poor"]
			},
			tema66: {
				id: "66",
				active: true,
				name: "Bad qualities",
				musics: [[5615,4],[3527,3],[8361,3],[8480,3],[5588,3],[11214,2],[11218,2],[10268,2],[9251,2],[8712,2],[10257,2],[9432,2],[7771,2],[11272,2],[7591,2],[7496,2],[7342,2],[6830,2],[6270,2],[6180,1]],
				content: ["last", "bad", "hard", "crazy", "wrong", "fool", "low", "bitches", "slow", "stupid","mad", "harder", "insane", "worst", "poor"]
			},
			tema42: {
				id: "42",
				active: false,
				name: "Locations II",
				musics: [[6388,3],[11483,2],[9009,2],[8164,2],[4292,2],[7225,2],[6557,2],[7286,2],[4950,2],[5581,1],[11578,1],[11574,1],[5132,1],[4797,1],[9983,1],[4397,1],[9072,1],[44,1],[4223,1],[8811,1]],
				content: ["top", "closer", "above", "middle", "everywhere", "nowhere", "outside", "between", "front", "somewhere","near", "ahead", "edge", "within", "underneath", "here's", "beyond", "anywhere", "wherever"]
			},
			tema100: {
				id: "100",
				active: false,
				name: "Prepositions of place",
				musics: [[6135,6],[9164,6],[2174,6],[1878,6],[6625,6],[8494,6],[1859,6],[8533,6],[6976,6],[4130,6],[1850,6],[1265,5],[8511,5],[891,5],[1280,5],[1880,5],[10924,5],[8246,5],[5615,5],[8261,1]],
				content: ["front", "in", "at", "on", "behind", "between", "across", "opposite", "next", "near","close", "beside", "above", "over", "under", "below", "among", "after", "by"]
			},
			tema43: {
				id: "43",
				active: true,
				name: "Past Verbs",
				musics: [[7427,3],[11665,3],[11426,2],[7379,2],[11365,2],[11224,2],[6279,2],[11035,2],[9080,2],[8413,2],[7832,2],[5718,2],[7829,2],[7462,2],[5025,2],[545,2],[6731,2],[6507,2],[4470,2],[6144,1]],
				content: ["broken", "used", "wanted", "seen", "tried", "felt", "loved", "caught", "started", "tired","went", "fell", "met", "meant", "turned", "known", "held", "called"]
			},
			tema30: {
				id: "30",
				active: true,
				name: "Concrete Objects",
				musics: [[1868,4],[7825,3],[3041,3],[8298,3],[1861,3],[777,3],[11536,2],[10829,2],[11224,2],[10002,2],[10216,2],[10112,2],[11819,2],[9265,2],[8807,2],[28,2],[8767,2],[8389,2],[11861,2],[8939,1]],
				content: ["money", "shit", "lights", "floor", "line", "door", "gun", "bed", "bass", "car","phone", "wall", "pieces", "walls", "mirror", "ring", "glass", "picture", "train", "bottles"]
			},
			tema37: {
				id: "37",
				active: false,
				name: "Concepts I",
				musics: [[3472,50],[1880,5],[1852,5],[11638,5],[4923,5],[1879,4],[7803,4],[2451,4],[1647,4],[1856,4],[11739,4],[1920,3],[2067,3],[11950,3],[5420,3],[2137,3],[2244,3],[5922,3],[2322,3],[2363,1]],
				content: ["time", "way", "life", "mind", "things", "thing", "end", "place", "rock", "name","dream", "thought", "party", "help", "beat", "words", "song", "hell", "dreams", "chance"]
			},
			tema81: {
				id:"81",
				active: false,
				name: "Dolch words - Nouns II",
				musics: [[6625,6],[8494,6],[1850,6],[6976,6],[4130,6],[6135,6],[9164,6],[2174,6],[8533,6],[1852,5],[4923,5],[4143,4],[2084,3],[17,3],[11784,3],[5480,3],[6541,3],[2883,3],[8424,3],[6348,1]],
				content: ["father", "feet", "fire", "fish", "floor", "flower", "game", "garden", "girl", "good-bye", "grass", "ground", "hand", "head", "hill", "home", "horse", "house", "kitty", "leg", "letter", "man", "men", "milk", "money", "morning", "mother", "name", "nest", "night"]
			},
			tema121: {
				id: "121",
				active: false,
				name: "Present continuous II",
				musics: [[6660,3],[5675,3],[11734,3],[542,3],[4953,3],[3405,3],[6712,3],[10421,3],[11146,3],[1266,3],[6794,3],[7614,3],[8247,3],[10574,2],[10905,2],[10605,2],[10645,2],[9447,2],[10676,2],[9113,1]],
				content: ["telling", "losing", "playing", "dying", "moving", "crying", "killing", "dreaming", "screaming", "missing", "singing", "sitting", "turning", "fighting", "lying","shining", "beating", "having", "growing", "sleeping", "chasing", "letting", "bleeding", "breathing", "seaching"]
			},
			tema121: {
				id: "121",
				active: false,
				name: "Present continuous II",
				musics: [[6660,3],[5675,3],[11734,3],[542,3],[4953,3],[3405,3],[6712,3],[10421,3],[11146,3],[1266,3],[6794,3],[7614,3],[8247,3],[10574,2],[10905,2],[10605,2],[10645,2],[9447,2],[10676,2],[9113,1]],
				content: ["telling", "losing", "playing", "dying", "moving", "crying", "killing", "dreaming", "screaming", "missing", "singing", "sitting", "turning", "fighting", "lying","shining", "beating", "having", "growing", "sleeping", "chasing", "letting", "bleeding", "breathing", "seaching"]
			},
			tema106: {
				id: "106",
				active: false,
				name: "Adverbs of frequency",
				musics: [[4303,6],[5113,6],[2545,6],[10768,6],[620,5],[6873,5],[6803,5],[8867,5],[1821,5],[6610,5],[10611,5],[817,5],[8303,5],[8800,4],[10417,4],[6861,4],[3455,4],[6681,4],[9148,4],[11235,1]],
				content: ["always", "usually", "often", "sometimes", "rarely", "seldom", "hardly", "ever", "never","twice", "once", "times"]
			},
			tema106: {
				id: "106",
				active: false,
				name: "Adverbs of frequency",
				musics: [[4303,6],[5113,6],[2545,6],[10768,6],[620,5],[6873,5],[6803,5],[8867,5],[1821,5],[6610,5],[10611,5],[817,5],[8303,5],[8800,4],[10417,4],[6861,4],[3455,4],[6681,4],[9148,4],[11235,1]],
				content: ["always", "usually", "often", "sometimes", "rarely", "seldom", "hardly", "ever", "never","twice", "once", "times"]
			},
			tema27: {
				id: "27",
				active: true,
				name: "Time II",
				musics: [[992,3],[10763,3],[8463,3],[11411,2],[3836,2],[9228,2],[8520,2],[7398,2],[7346,2],[11838,2],[5580,2],[5163,2],[102,2],[3617,2],[3299,2],[3179,2],[3054,2],[2765,2],[2375,2],[667,1]],
				content: ["past", "finally", "years", "since", "soon", "already", "yesterday", "yet", "christmas", "minute","nights", "future", "year", "everyday", "everytime", "someday", "hour", "sunday", "longer", "friday"]
			},
			tema86: {
				id:"86",
				active: false,
				name: "Present Perfect",
				musics: [[7405,3],[11308,2],[10432,2],[4272,2],[6254,2],[4573,2],[1401,2],[3925,2],[2591,2],[2111,2],[1864,2],[1688,2],[5758,1],[11429,1],[11427,1],[10554,1],[10553,1],[10523,1],[10522,1],[9791,1]],
				content: ["have", "has"]
			},
			tema47: {
				id: "47",
				active: true,
				name: "Past Verbs II",
				musics: [[8707,2],[2385,2],[11650,2],[11297,2],[10914,2],[9856,2],[9074,2],[5323,2],[8400,2],[7392,2],[2585,2],[2700,2],[3,1],[45,1],[5691,1],[5394,1],[11137,1],[5399,1],[5116,1],[10451,1]],
				content: ["learned", "begun", "changed", "died", "walked", "taken", "won", "kept", "looked", "loose","needed", "kissed", "saved", "played"]
			},
			tema68: {
				id:"68",      
				active: false,
				name: "Verb to be",
				musics: [[8138,6],[2451,6],[8261,5],[1280,5],[1880,5],[11948,5],[1852,5],[11400,5],[11056,4],[1297,4],[4792,4],[659,4],[238,4],[4977,4],[7811,4],[7803,4],[7633,4],[7339,4],[7337,4],[10666,1]],
				content: ["I'm", "be", "is", "it's", "you're", "are", "she's", "im", "we're", "there's", "that's", "he's", "they're", "isn't", "aren't"]
			},
			tema82: {
				id:"82",
				active: false,
				name: "Dolch words - Nouns III",
				musics: [[1880,5],[1237,4],[8219,4],[1647,4],[1086,3],[1292,3],[7805,3],[1311,3],[7811,3],[9786,3],[1440,3],[1460,3],[11750,3],[9152,3],[9265,3],[240,3],[8563,3],[5755,3],[8418,3],[2029,1]],
				content: ["paper", "party", "picture", "pig", "rabbit", "rain", "ring", "robin", "Claus", "school", "seed", "sheep", "shoe", "sister", "snow", "song", "squirrel", "stick", "street", "sun", "table", "thing", "time", "top", "toy", "tree", "watch", "water", "way", "wind", "window", "wood"]
			},
			tema23: {
				id: "23",
				active: true,
				name: "Basic verbs III",
				musics: [[3344,3],[7405,3],[10418,2],[11043,2],[9509,2],[7577,2],[11934,2],[9410,2],[8568,2],[8465,2],[8443,2],[8347,2],[8217,2],[7983,2],[7821,2],[7812,2],[7718,2],[4181,2],[483,2],[497,1]],
				content: ["made", "should", "done", "goes", "makes", "must", "came", "might", "took", "may","takes", "we've", "you'd", "couldn't", "wasn't", "cannot", "belong", "should've", "needs", "they'll","isn't", "we'd", "haven't"]
			}
		};
		
		//Array de probabilidades
		public var probArray:Array = [0.33, 0.33, 0.34];
		public var playerLevel:int = 1;
		
		public function WordShuffler(wdOpt:XML, versosInf:Array) {
			wordOpt = wdOpt;
			versosInfo = versosInf;
			var levelBar:LevelBar = new LevelBar();
			playerLevel = levelBar.getPlayerLevel();
			
			//Funções inicializadoras
			adjustProbability();
		}
		
		private function adjustProbability():void {
			//Checa se já pode ajustar as chances
			var player:MyPlayer = Player.current as MyPlayer;
			if(player.itens[1]>=3 && player.itens[3]>=3 && player.itens[5]>=3) {
				var percent1:Number = player.itens[0]/player.itens[1];
				var percent2:Number = player.itens[2]/player.itens[3];
				var percent3:Number = player.itens[4]/player.itens[5];
				probArray[0] = 0.2/(percent1+0.001);
				if(probArray[0] > 0.8) {
					probArray[0] = 0.8; 
				}
				probArray[1] = 0.2/(percent2+0.001);
				if(probArray[1] > 0.8 || probArray[0]+probArray[1]>1) {
					probArray[1] = 1 - probArray[0];	
				}
				probArray[2] = 0.2/(percent3+0.001);
				if(probArray[2] > 0.8 || probArray[0]+probArray[1]+probArray[2]>1) {
					probArray[2] = 1 - (probArray[0]+probArray[1]);
				}
			}
		}
		
		public function makeThreeOptions(verso:String, word:String):Array {
			var blocks:Array = verso.split(/ /g);
			var threeOptions:Array = new Array();
			var correctPos:int = 1;
			var blankType:int = 1;
			word = word.split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();
			if(word == "i") { word = "I"; };
			threeOptions.push(word);
			
			//Checa se tem rimas o suficiente para poder ter opção de rimas
			var podeTerRimas:Boolean = PlayScreenController.checkIfEnoughRhymes(wordOpt, verso);
			
			//Joga o dado principal
			var rand:Number = Math.random();
			
			//Vê primeiro se vai ser uma palavra da música
			if(rand<probArray[0] || !podeTerRimas) {
				var segundaPalavra:String = word;
				while(segundaPalavra == word || segundaPalavra.length<2) {
					var arrayAux:Array = versosInfo[Math.floor(Math.random()*versosInfo.length)][0].split(" ");
					segundaPalavra = unescapeString(arrayAux[Math.floor(Math.random()*arrayAux.length)]).
						split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();
				}
				threeOptions.push(segundaPalavra);
				var terceiraPalavra:String = segundaPalavra;
				while(terceiraPalavra == segundaPalavra || terceiraPalavra == word || terceiraPalavra.length<2) {
					arrayAux = versosInfo[Math.floor(Math.random()*versosInfo.length)][0].split(" ");
					terceiraPalavra = unescapeString(arrayAux[Math.floor(Math.random()*arrayAux.length)]).
						split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase();
				}
				threeOptions.push(terceiraPalavra);
				blankType = 1;
			}
			
			//Vê se vai ser rima como sempre
			else if(rand>=probArray[0] && rand<probArray[0]+probArray[1] && podeTerRimas) {
				var tamanho:Number = 0;
				var botaoAux:Number;
				var numeroAlternativa:Number;
				var counter:Number;
				var counterAuxiliar:Number;
				
				//Só continua com rimas se a palavra escolhida tem pelo menos duas rimas
				tamanho = wordOpt.word.(@value==word.split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase()).children().length();
				if(tamanho>=2) {
					numeroAlternativa = Math.floor(Math.random()*tamanho);
					var segundaPalavra2:String = String(wordOpt.word.(@value==word.split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase()).
						children()[numeroAlternativa]);
					threeOptions.push(segundaPalavra2);
					var terceiraPalavra2:String = word;
					while(word == terceiraPalavra2 || terceiraPalavra2 == segundaPalavra2) {
						numeroAlternativa = Math.floor(Math.random()*tamanho);
						terceiraPalavra2 = String(wordOpt.word.(@value==word.split(/[?!,.-;:\r\(\)]/g).join("").toLowerCase()).
							children()[numeroAlternativa]);
					}
					threeOptions.push(terceiraPalavra2);
	
					blankType = 2;
				} else {
					var randTricky:Number = Math.floor(Math.random()*trickyWords.length);
					threeOptions.push(trickyWords[randTricky][0]);
					threeOptions.push(trickyWords[randTricky][1]);
					
					blankType = 3;
				}
			} 
			
			//Por fim, vê se vão ser tricky words
			else if(rand>=probArray[0]+probArray[1] && rand<1 && podeTerRimas) {
				var achouRima:Boolean = false;
				for each(var trice:Array in trickyWords) {
					if(trice[0]==word || trice[1]==word || trice[2]==word) { 
						if(trice[2]==null) {
							if(trice[0]==word) { threeOptions.push(trice[1]); 
								threeOptions.push(trickyWords[Math.floor(Math.random()*trickyWords.length)]); }
							if(trice[1]==word) { threeOptions.push(trice[0]); 
								threeOptions.push(trickyWords[Math.floor(Math.random()*trickyWords.length)]); }
						} else {
							if(trice[0]==word) { threeOptions.push(trice[1]); threeOptions.push(trice[2]); }
							if(trice[1]==word) { threeOptions.push(trice[0]); threeOptions.push(trice[2]); }
							if(trice[2]==word) { threeOptions.push(trice[0]); threeOptions.push(trice[1]); }
							blankType = 3;
							achouRima = true;
						}
					}
				} 
				//Se chegou aqui é porque caiu no dado para ser tricky word, mas não achou em nenhum momento
				if(!achouRima) { return makeThreeOptions(verso, word); }
			}
			
			
			//Embaralha a ordem das opções
			var rand2:Number = Math.random();
			var auxString:String = "";
			if(rand2<0.33) {
				auxString = threeOptions[1]; threeOptions[1] = threeOptions[0]; threeOptions[0] = auxString; 
				correctPos = 2;
			} else if(rand2>=0.33 && rand2<0.66) {
				auxString = threeOptions[2]; threeOptions[2] = threeOptions[0]; threeOptions[0] = auxString; 				
				correctPos = 3;
			} else {}
			return [threeOptions, correctPos, blankType];	
		}
		
		private static function randomThirdOption(twoOptions:Array):String {
			var consonants:String = "bcdfghlmnprstw"; //Sem 'z','x','q','j','k', e 'v', que são raros
			var vowels:String = "aeiouy";
			var correctWord:String = twoOptions[0];
			var scrambledWord:String = correctWord;
			var posicaoNoMeio:Number = Math.floor(Math.random()*correctWord.length);
			if(correctWord.length>=6) { //Come uma letra se for uma palavra grande
				while(scrambledWord==correctWord || scrambledWord==twoOptions[1]) {
					scrambledWord = correctWord.replace(correctWord.charAt(posicaoNoMeio), "");
					posicaoNoMeio = Math.floor(Math.random()*correctWord.length);
				}
			} else { //Troca uma vogal por vogal ou consoante por consoante se for uma palavra pequena
				while(scrambledWord==correctWord || scrambledWord==twoOptions[1]) {
					if(vowels.indexOf(correctWord.charAt(posicaoNoMeio))!=-1) {
						scrambledWord = correctWord.replace(correctWord.charAt(posicaoNoMeio),vowels.charAt(Math.floor(Math.random()*vowels.length-1))); 	
					} else {
						scrambledWord = correctWord.replace(correctWord.charAt(posicaoNoMeio),consonants.charAt(Math.floor(Math.random()*consonants.length-1))); 							
					}
					posicaoNoMeio = Math.floor(Math.random()*correctWord.length);					
				}
			}
			return scrambledWord;
		}
		
		public static function analyseAnswer(option:String):String {
			var temaAbordado:String; 
			for each(var tema:Object in themes) {
				if(tema.active) {
					for each(var word:String in tema.content) {
						if(word==option) {
							temaAbordado = tema.name;
							return temaAbordado;
						}
					}
				}
			}
			return temaAbordado;
		}
		
		//Copiado do stackoverflow abaixo
		public static function unescapeString( input:String ):String {
			var result:String = "";
			var backslashIndex:int = 0;
			var nextSubstringStartPosition:int = 0;
			var len:int = input.length;
			
			do
			{
				// Find the next backslash in the input
				backslashIndex = input.indexOf( '\\', nextSubstringStartPosition );
				
				if ( backslashIndex >= 0 )
				{
					result += input.substr( nextSubstringStartPosition, backslashIndex - nextSubstringStartPosition );
					
					// Move past the backslash and next character (all escape sequences are
					// two characters, except for \u, which will advance this further)
					nextSubstringStartPosition = backslashIndex + 2;
					
					// Check the next character so we know what to escape
					var escapedChar:String = input.charAt( backslashIndex + 1 );
					switch ( escapedChar )
					{
						// Try to list the most common expected cases first to improve performance
						
						case '"':
							result += escapedChar;
							break; // quotation mark
						case '\\':
							result += escapedChar;
							break; // reverse solidus   
						case 'n':
							result += '\n';
							break; // newline
						case 'r':
							result += '\r';
							break; // carriage return
						case 't':
							result += '\t';
							break; // horizontal tab    
						
						// Convert a unicode escape sequence to it's character value
						case 'u':
							
							// Save the characters as a string we'll convert to an int
							var hexValue:String = "";
							
							var unicodeEndPosition:int = nextSubstringStartPosition + 4;
							
							// Make sure there are enough characters in the string leftover
							if ( unicodeEndPosition > len )
							{
								parseError( "Unexpected end of input.  Expecting 4 hex digits after \\u." );
							}
							
							// Try to find 4 hex characters
							for ( var i:int = nextSubstringStartPosition; i < unicodeEndPosition; i++ )
							{
								// get the next character and determine
								// if it's a valid hex digit or not
								var possibleHexChar:String = input.charAt( i );
								if ( !isHexDigit( possibleHexChar ) )
								{
									parseError( "Excepted a hex digit, but found: " + possibleHexChar );
								}
								
								// Valid hex digit, add it to the value
								hexValue += possibleHexChar;
							}
							
							// Convert hexValue to an integer, and use that
							// integer value to create a character to add
							// to our string.
							result += String.fromCharCode( parseInt( hexValue, 16 ) );
							
							// Move past the 4 hex digits that we just read
							nextSubstringStartPosition = unicodeEndPosition;
							break;
						
						case 'f':
							result += '\f';
							break; // form feed
						case '/':
							result += '/';
							break; // solidus
						case 'b':
							result += '\b';
							break; // bell
						default:
							result += '\\' + escapedChar; // Couldn't unescape the sequence, so just pass it through
					}
				}
				else
				{
					// No more backslashes to replace, append the rest of the string
					result += input.substr( nextSubstringStartPosition );
					break;
				}
				
			} while ( nextSubstringStartPosition < len );
			
			return result;
		}
		
		/**
		 * Determines if a character is a digit [0-9].
		 *
		 * @return True if the character passed in is a digit
		 */
		private static function isDigit( ch:String ):Boolean
		{
			return ( ch >= '0' && ch <= '9' );
		}
		
		/**
		 * Determines if a character is a hex digit [0-9A-Fa-f].
		 *
		 * @return True if the character passed in is a hex digit
		 */
		private static function isHexDigit( ch:String ):Boolean
		{
			return ( isDigit( ch ) || ( ch >= 'A' && ch <= 'F' ) || ( ch >= 'a' && ch <= 'f' ) );
		}
		
		/**
		 * Raises a parsing error with a specified message, tacking
		 * on the error location and the original string.
		 *
		 * @param message The message indicating why the error occurred
		 */
		private static function parseError( message:String ):void
		{
			throw new Error( message );
		}
		
	}
}