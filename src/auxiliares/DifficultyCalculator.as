package auxiliares
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import z_nl.base42.subtitles.SubtitleParser;

	public class DifficultyCalculator {
		//Variáveis normais
		public var musicIDs:XML = new XML();
		public var difOriginal:Array = new Array();
		
		//Variáveis de informações 
		public var musicas:Array =
			["Incubus - Are You In", "Incubus - The Warmth", "Incubus - 11 A.M.", "Incubus - Friends And Lovers", "Incubus - Here In My Room", "Incubus - If Not Now, When", "Incubus - Adolescents", "Incubus - Black Heart Inertia", "Incubus - Make Yourself", "Incubus - Isadore", 
				"Incubus - Just A Phase", "Incubus - Agoraphobia", "Incubus - Sick, Sad Little World", "Incubus - Deep Inside", "Incubus - Paper Shoes", "Incubus - Admiration", "Incubus - Look Alive", "Incubus - Summer Romance (Anti-gravity Love Song)", "Incubus - A Kiss To Send Us Off", "Incubus - Thieves", 
				"Incubus - Have You Ever", "Incubus - Rogues", "Incubus - A Crow Left Of The Murder", "Incubus - Consequence", "Incubus - Quicksand", "Incubus - I Miss You", "Incubus - Pistola", "Incubus - The Original", "Incubus - Diamonds And Coal", "Incubus - I Miss You", 
				"Incubus - Out From Under", "Incubus - Clean", "Incubus - Switchblade", "Incubus - Neither of Us Can See", "Incubus - Midnight Swim", "Sheryl Crow - If It Makes You Happy", "Sheryl Crow - All I Wanna Do", "Sheryl Crow - Sweet Child O' Mine", "Sheryl Crow - A Change Would Do You Good", "Sheryl Crow - Summer Day", 
				"Lifehouse - You And Me", "Lifehouse - Broken", "Lifehouse - Blind", "Lifehouse - Take Me Away", "Lifehouse - From Where You Are", "Lifehouse - Somewhere In Between", "Lifehouse - Good Enough", "Lifehouse - First Time", "Lifehouse - Halfway Gone", "Lifehouse - All In", 
				"Lifehouse - You And Me", "Lifehouse - Breathing", "Lifehouse - By Your Side", "Lifehouse - Only One", "Lifehouse - Somewhere Only We Know", "Lifehouse - Always Somewhere Close", "Lifehouse - Who We Are", "Lifehouse - Learn You Inside Out", "Lifehouse - Butterfly", "Lifehouse - Disarray", 
				"Lifehouse - Nerve Damage", "Lifehouse - Climb", "Lifehouse - Better Part Of Me", "Lifehouse - Trying", "Lifehouse - Everybody Is Someone", "Lifehouse - Today", "Lifehouse - Eighties", "Lifehouse - Along The Way", "Lifehouse - Don't Wake Me When It's Over", "Switchfoot - Dare You To Move", 
				"Switchfoot - Learning To Breathe", "Switchfoot - When We Come Alive", "Switchfoot - Love Alone Is Worth The Fight", "Switchfoot - This Is Home", "Switchfoot - Meant To Live", "Switchfoot - On Fire", "Switchfoot - Dark Horses", "Switchfoot - Always", "Switchfoot - Stars", "Switchfoot - This Is Your Life", 
				"Switchfoot - Awakening", "Switchfoot - Restless", "Switchfoot - We Are One Tonight", "Switchfoot - The World You Want", "Switchfoot - Afterlife", "Switchfoot - Thrive", "Switchfoot - Yet", "Switchfoot - Twenty-Four", "Switchfoot - Mess Of Me", "Switchfoot - Hello Hurricane", 
				"Switchfoot - Vice Verses", "Switchfoot - American Dream", "Switchfoot - The Shadow Proves The Sunshine", "Switchfoot - Slipping Away", "Switchfoot - Saltwater Heart", "Switchfoot - Sing It Out", "Switchfoot - 24", "Switchfoot - Say It Like You Mean It", "Switchfoot - Yesterdays", "Switchfoot - Beautiful Letdown", 
				"Switchfoot - Back To The Beginning Again", "Switchfoot - The Blues", "Switchfoot - Happy is a Yuppie Word", "Switchfoot - Love Is The Movement", "Switchfoot - Blinding Light", "Switchfoot - Let Your Love Be Strong", "Switchfoot - More Than Fine", "Switchfoot - The Original", "Switchfoot - Ammunition", "Switchfoot - Daisy", 
				"Switchfoot - The War Inside", "Switchfoot - Innocence Again", "Switchfoot - Rise Above It", "Switchfoot - 4 12", "Switchfoot - Someday We'll Know", "Switchfoot - Golden", "Switchfoot - The Setting Sun", "Switchfoot - Innocence", "Simple Plan - Perfect", "Simple Plan - Welcome To My Life", 
				"Simple Plan - Saturday", "Simple Plan - Save You", "Simple Plan - When I'm Gone", "Simple Plan - What's New Scooby Doo", "Simple Plan - Jet Lag (feat. Natasha Bedingfield)", "Simple Plan - Shut Up", "Simple Plan - I'm Just a Kid", "Simple Plan - This Song Saved My Life", "Simple Plan - Addicted", "Simple Plan - Summer Paradise (feat. Sean Paul)", 
				"Simple Plan - I'd Do Anything", "Simple Plan - Happy Together", "Simple Plan - Perfect World", "Simple Plan - Untitled (How Could This Happen To Me)", "Simple Plan - Time To Say Goodbye", "Simple Plan - Try", "Simple Plan - The Rest of Us", "Simple Plan - Jump", "Simple Plan - Loser Of The Year", "Simple Plan - Can't Keep My Hands Off You (feat. Rivers Cuomo)", 
				"Simple Plan - God Must Hate Me", "Simple Plan - When I'm With You", "Simple Plan - Jet Lag (feat. Marie-Mai) (francês)", "Simple Plan - The Worst Day Ever", "Simple Plan - Promise", "Simple Plan - Meet You There", "Simple Plan - I Miss You", "Simple Plan - Anywhere Else But Here", "Simple Plan - The end", "Simple Plan - Grow Up", 
				"Simple Plan - You Don't Mean Anything", "Simple Plan - Barbie Girl", "Simple Plan - Holding On", "Simple Plan - Don't Wanna Think About You", "Simple Plan - Freaking Me Out (feat. Alex Gaskarth)", "Simple Plan - Fire In My Heart", "Simple Plan - Tell Me", "Simple Plan - I Won't Be There", "Simple Plan - Addicted", "Simple Plan - It's Not Easy (Being Green)", 
				"Simple Plan - Running Out Of Time", "Simple Plan - Welcome to My Life (MTV Hard Rock Live Version)", "Simple Plan - Any Given Sunday", "Simple Plan - Famous For Nothing", "Simple Plan - Twitter Song", "Panic! At The Disco - This Is Gospel", "Panic! At The Disco - Hallelujah", "Panic! At The Disco - Girls/Girls/Boys", "Panic! At The Disco - I Write Sins Not Tragedies", "Panic! At The Disco - Miss Jackson", 
				"Panic! At The Disco - Northern Downpour", "Panic! At The Disco - But It's Better If You Do", "Panic! At The Disco - Nicotine", "Panic! At The Disco - Build God, Then We'll Talk", "Panic! At The Disco - Ready To Go (Get Me Out Of My Mind)", "Panic! At The Disco - Far Too Young To Die", "Panic! At The Disco - Vegas Lights", "Panic! At The Disco - Let's Kill Tonight", "Panic! At The Disco - Collar Full", "Panic! At The Disco - The End Of All Things", 
				"Panic! At The Disco - C'mon (feat. Fun)", "Panic! At The Disco - Girl That You Love", "Panic! At The Disco - New Perspective", "Panic! At The Disco - The Calendar", "Panic! At The Disco - Hurricane", "Panic! At The Disco - Carry On My Wayward Son", "Panic! At The Disco - Memories", "Panic! At The Disco - We're So Starving", "Panic! At The Disco - True Love", "Panic! At The Disco - Introduction", 
				"Panic! At The Disco - Intermission", "Panic! At The Disco - Boys Will Be Boys", "Panic! At The Disco - Valerie", "Panic! At The Disco - Lullabye", "Panic! At The Disco - Why Cry", "Panic! At The Disco - Bohemian Rhapsody", "Panic! At The Disco - All My Life", "Panic! At The Disco - Killer Queen", "Panic! At The Disco - Karma Police", "Panic! At The Disco - In My Eyes", 
				"Panic! At The Disco - Three Little Birds", "Panic! At The Disco - Girlfriend In a Coma", "Panic! At The Disco - Pumped Up Kicks", "Panic! At The Disco - Open Hapiness", "Panic! At The Disco - Blackbird", "Panic! At The Disco - Middle Of Summer", "Panic! At The Disco - Round Here", "Panic! At The Disco - Don't Stop Belivin", "Panic! At The Disco - Dammit", "Panic! At The Disco - Maneater", 
				"Panic! At The Disco - Boss DJ", "Panic! At The Disco - Dog Days Are Over"]

		public var commonWords:Array = [["a"], ["ability"], ["able"], ["about"], ["about"], ["above"], ["above"], ["absence"], ["absolutely"], ["academic"], 
			["accept"], ["access"], ["accident"], ["accompany"], ["according to"], ["account"], ["account"], ["achieve"], ["achievement"], ["acid"], 
			["acquire"], ["across"], ["act"], ["act"], ["action"], ["active"], ["activity"], ["actual"], ["actually"], ["add"], 
			["addition"], ["additional"], ["address"], ["address"], ["administration"], ["admit"], ["adopt"], ["adult"], ["advance"], ["advantage"], 
			["advice"], ["advise"], ["affair"], ["affect"], ["afford"], ["afraid"], ["after"], ["after"], ["afternoon"], ["afterwards"], 
			["again"], ["against"], ["age"], ["agency"], ["agent"], ["ago"], ["agree"], ["agreement"], ["ahead"], ["aid"], 
			["aim"], ["aim"], ["air"], ["aircraft"], ["all"], ["all"], ["allow"], ["almost"], ["alone"], ["alone"], 
			["along"], ["along"], ["already"], ["alright"], ["also"], ["alternative"], ["alternative"], ["although"], ["always"], ["among"], 
			["amongst"], ["amount"], ["an"], ["analysis"], ["ancient"], ["and"], ["animal"], ["announce"], ["annual"], ["another"], 
			["answer"], ["answer"], ["any"], ["anybody"], ["anyone"], ["anything"], ["anyway"], ["apart"], ["apparent"], ["apparently"], 
			["appeal"], ["appeal"], ["appear"], ["appearance"], ["application"], ["apply"], ["appoint"], ["appointment"], ["approach"], ["approach"], 
			["appropriate"], ["approve"], ["area"], ["argue"], ["argument"], ["arise"], ["arm"], ["army"], ["around"], ["around"], 
			["arrange"], ["arrangement"], ["arrive"], ["art"], ["article"], ["artist"], ["as"], ["as"], ["as"], ["ask"], 
			["aspect"], ["assembly"], ["assess"], ["assessment"], ["asset"], ["associate"], ["association"], ["assume"], ["assumption"], ["at"], 
			["atmosphere"], ["attach"], ["attack"], ["attack"], ["attempt"], ["attempt"], ["attend"], ["attention"], ["attitude"], ["attract"], 
			["attractive"], ["audience"], ["author"], ["authority"], ["available"], ["average"], ["avoid"], ["award"], ["award"], ["aware"], 
			["away"], ["aye"], ["baby"], ["back"], ["back"], ["background"], ["bad"], ["bag"], ["balance"], ["ball"], 
			["band"], ["bank"], ["bar"], ["base"], ["base"], ["basic"], ["basis"], ["battle"], ["be"], ["bear"], 
			["beat"], ["beautiful"], ["because"], ["become"], ["bed"], ["bedroom"], ["before"], ["before"], ["before"], ["begin"], 
			["beginning"], ["behaviour"], ["behind"], ["belief"], ["believe"], ["belong"], ["below"], ["below"], ["beneath"], ["benefit"], 
			["beside"], ["best"], ["better"], ["between"], ["beyond"], ["big"], ["bill"], ["bind"], ["bird"], ["birth"], 
			["bit"], ["black"], ["block"], ["blood"], ["bloody"], ["blow"], ["blue"], ["board"], ["boat"], ["body"], 
			["bone"], ["book"], ["border"], ["both"], ["both"], ["bottle"], ["bottom"], ["box"], ["boy"], ["brain"], 
			["branch"], ["break"], ["breath"], ["bridge"], ["brief"], ["bright"], ["bring"], ["broad"], ["brother"], ["budget"], 
			["build"], ["building"], ["burn"], ["bus"], ["business"], ["busy"], ["but"], ["buy"], ["by"], ["cabinet"], 
			["call"], ["call"], ["campaign"], ["can"], ["candidate"], ["capable"], ["capacity"], ["capital"], ["car"], ["card"], 
			["care"], ["care"], ["career"], ["careful"], ["carefully"], ["carry"], ["case"], ["cash"], ["cat"], ["catch"], 
			["category"], ["cause"], ["cause"], ["cell"], ["central"], ["centre"], ["century"], ["certain"], ["certainly"], ["chain"], 
			["chair"], ["chairman"], ["challenge"], ["chance"], ["change"], ["change"], ["channel"], ["chapter"], ["character"], ["characteristic"], 
			["charge"], ["charge"], ["cheap"], ["check"], ["chemical"], ["chief"], ["child"], ["choice"], ["choose"], ["church"], 
			["circle"], ["circumstance"], ["citizen"], ["city"], ["civil"], ["claim"], ["claim"], ["class"], ["clean"], ["clear"], 
			["clear"], ["clearly"], ["client"], ["climb"], ["close"], ["close"], ["close"], ["closely"], ["clothes"], ["club"], 
			["coal"], ["code"], ["coffee"], ["cold"], ["colleague"], ["collect"], ["collection"], ["college"], ["colour"], ["combination"], 
			["combine"], ["come"], ["comment"], ["comment"], ["commercial"], ["commission"], ["commit"], ["commitment"], ["committee"], ["common"], 
			["communication"], ["community"], ["company"], ["compare"], ["comparison"], ["competition"], ["complete"], ["complete"], ["completely"], ["complex"], 
			["component"], ["computer"], ["concentrate"], ["concentration"], ["concept"], ["concern"], ["concern"], ["concerned"], ["conclude"], ["conclusion"], 
			["condition"], ["conduct"], ["conference"], ["confidence"], ["confirm"], ["conflict"], ["congress"], ["connect"], ["connection"], ["consequence"], 
			["conservative"], ["consider"], ["considerable"], ["consideration"], ["consist"], ["constant"], ["construction"], ["consumer"], ["contact"], ["contact"], 
			["contain"], ["content"], ["context"], ["continue"], ["contract"], ["contrast"], ["contribute"], ["contribution"], ["control"], ["control"], 
			["convention"], ["conversation"], ["copy"], ["corner"], ["corporate"], ["correct"], ["cos"], ["cost"], ["cost"], ["could"], 
			["council"], ["count"], ["country"], ["county"], ["couple"], ["course"], ["court"], ["cover"], ["cover"], ["create"], 
			["creation"], ["credit"], ["crime"], ["criminal"], ["crisis"], ["criterion"], ["critical"], ["criticism"], ["cross"], ["crowd"], 
			["cry"], ["cultural"], ["culture"], ["cup"], ["current"], ["currently"], ["curriculum"], ["customer"], ["cut"], ["cut"], 
			["damage"], ["damage"], ["danger"], ["dangerous"], ["dark"], ["data"], ["date"], ["date"], ["daughter"], ["day"], 
			["dead"], ["deal"], ["deal"], ["death"], ["debate"], ["debt"], ["decade"], ["decide"], ["decision"], ["declare"], 
			["deep"], ["deep"], ["defence"], ["defendant"], ["define"], ["definition"], ["degree"], ["deliver"], ["demand"], ["demand"], 
			["democratic"], ["demonstrate"], ["deny"], ["department"], ["depend"], ["deputy"], ["derive"], ["describe"], ["description"], ["design"], 
			["design"], ["desire"], ["desk"], ["despite"], ["destroy"], ["detail"], ["detailed"], ["determine"], ["develop"], ["development"], 
			["device"], ["die"], ["difference"], ["different"], ["difficult"], ["difficulty"], ["dinner"], ["direct"], ["direct"], ["direction"], 
			["directly"], ["director"], ["disappear"], ["discipline"], ["discover"], ["discuss"], ["discussion"], ["disease"], ["display"], ["display"], 
			["distance"], ["distinction"], ["distribution"], ["district"], ["divide"], ["division"], ["do"], ["doctor"], ["document"], ["dog"], 
			["domestic"], ["door"], ["double"], ["doubt"], ["down"], ["down"], ["draw"], ["drawing"], ["dream"], ["dress"], 
			["dress"], ["drink"], ["drink"], ["drive"], ["drive"], ["driver"], ["drop"], ["drug"], ["dry"], ["due"], 
			["during"], ["duty"], ["each"], ["ear"], ["early"], ["early"], ["earn"], ["earth"], ["easily"], ["east"], 
			["easy"], ["eat"], ["economic"], ["economy"], ["edge"], ["editor"], ["education"], ["educational"], ["effect"], ["effective"], 
			["effectively"], ["effort"], ["egg"], ["either"], ["either"], ["elderly"], ["election"], ["element"], ["else"], ["elsewhere"], 
			["emerge"], ["emphasis"], ["employ"], ["employee"], ["employer"], ["employment"], ["empty"], ["enable"], ["encourage"], ["end"], 
			["end"], ["enemy"], ["energy"], ["engine"], ["engineering"], ["enjoy"], ["enough"], ["enough"], ["ensure"], ["enter"], 
			["enterprise"], ["entire"], ["entirely"], ["entitle"], ["entry"], ["environment"], ["environmental"], ["equal"], ["equally"], ["equipment"], 
			["error"], ["escape"], ["especially"], ["essential"], ["establish"], ["establishment"], ["estate"], ["estimate"], ["even"], ["evening"], 
			["event"], ["eventually"], ["ever"], ["every"], ["everybody"], ["everyone"], ["everything"], ["evidence"], ["exactly"], ["examination"], 
			["examine"], ["example"], ["excellent"], ["except"], ["exchange"], ["executive"], ["exercise"], ["exercise"], ["exhibition"], ["exist"], 
			["existence"], ["existing"], ["expect"], ["expectation"], ["expenditure"], ["expense"], ["expensive"], ["experience"], ["experience"], ["experiment"], 
			["expert"], ["explain"], ["explanation"], ["explore"], ["express"], ["expression"], ["extend"], ["extent"], ["external"], ["extra"], 
			["extremely"], ["eye"], ["face"], ["face"], ["facility"], ["fact"], ["factor"], ["factory"], ["fail"], ["failure"], 
			["fair"], ["fairly"], ["faith"], ["fall"], ["fall"], ["familiar"], ["family"], ["famous"], ["far"], ["far"], 
			["farm"], ["farmer"], ["fashion"], ["fast"], ["fast"], ["father"], ["favour"], ["fear"], ["fear"], ["feature"], 
			["fee"], ["feel"], ["feeling"], ["female"], ["few"], ["few"], ["field"], ["fight"], ["figure"], ["file"], 
			["fill"], ["film"], ["final"], ["finally"], ["finance"], ["financial"], ["find"], ["finding"], ["fine"], ["finger"], 
			["finish"], ["fire"], ["firm"], ["first"], ["fish"], ["fit"], ["fix"], ["flat"], ["flight"], ["floor"], 
			["flow"], ["flower"], ["fly"], ["focus"], ["follow"], ["following"], ["food"], ["foot"], ["football"], ["for"], 
			["for"], ["force"], ["force"], ["foreign"], ["forest"], ["forget"], ["form"], ["form"], ["formal"], ["former"], 
			["forward"], ["foundation"], ["free"], ["freedom"], ["frequently"], ["fresh"], ["friend"], ["from"], ["front"], ["front"], 
			["fruit"], ["fuel"], ["full"], ["fully"], ["function"], ["fund"], ["funny"], ["further"], ["future"], ["future"], 
			["gain"], ["game"], ["garden"], ["gas"], ["gate"], ["gather"], ["general"], ["general"], ["generally"], ["generate"], 
			["generation"], ["gentleman"], ["get"], ["girl"], ["give"], ["glass"], ["go"], ["goal"], ["god"], ["gold"], 
			["good"], ["good"], ["government"], ["grant"], ["grant"], ["great"], ["green"], ["grey"], ["ground"], ["group"], 
			["grow"], ["growing"], ["growth"], ["guest"], ["guide"], ["gun"], ["hair"], ["half"], ["half"], ["hall"], 
			["hand"], ["hand"], ["handle"], ["hang"], ["happen"], ["happy"], ["hard"], ["hard"], ["hardly"], ["hate"], 
			["have"], ["he"], ["head"], ["head"], ["health"], ["hear"], ["heart"], ["heat"], ["heavy"], ["hell"], 
			["help"], ["help"], ["hence"], ["her"], ["her"], ["here"], ["herself"], ["hide"], ["high"], ["high"], 
			["highly"], ["hill"], ["him"], ["himself"], ["his"], ["his"], ["historical"], ["history"], ["hit"], ["hold"], 
			["hole"], ["holiday"], ["home"], ["home"], ["hope"], ["hope"], ["horse"], ["hospital"], ["hot"], ["hotel"], 
			["hour"], ["house"], ["household"], ["housing"], ["how"], ["however"], ["huge"], ["human"], ["human"], ["hurt"], 
			["husband"], ["i"], ["idea"], ["identify"], ["if"], ["ignore"], ["illustrate"], ["image"], ["imagine"], ["immediate"], 
			["immediately"], ["impact"], ["implication"], ["imply"], ["importance"], ["important"], ["impose"], ["impossible"], ["impression"], ["improve"], 
			["improvement"], ["in"], ["in"], ["incident"], ["include"], ["including"], ["income"], ["increase"], ["increase"], ["increased"], 
			["increasingly"], ["indeed"], ["independent"], ["index"], ["indicate"], ["individual"], ["individual"], ["industrial"], ["industry"], ["influence"], 
			["influence"], ["inform"], ["information"], ["initial"], ["initiative"], ["injury"], ["inside"], ["inside"], ["insist"], ["instance"], 
			["instead"], ["institute"], ["institution"], ["instruction"], ["instrument"], ["insurance"], ["intend"], ["intention"], ["interest"], ["interested"], 
			["interesting"], ["internal"], ["international"], ["interpretation"], ["interview"], ["into"], ["introduce"], ["introduction"], ["investigate"], ["investigation"], 
			["investment"], ["invite"], ["involve"], ["iron"], ["island"], ["issue"], ["issue"], ["it"], ["item"], ["its"], 
			["itself"], ["job"], ["join"], ["joint"], ["journey"], ["judge"], ["judge"], ["jump"], ["just"], ["justice"], 
			["keep"], ["key"], ["key"], ["kid"], ["kill"], ["kind"], ["king"], ["kitchen"], ["knee"], ["know"], 
			["knowledge"], ["labour"], ["labour"], ["lack"], ["lady"], ["land"], ["language"], ["large"], ["largely"], ["last"], 
			["last"], ["late"], ["late"], ["later"], ["latter"], ["laugh"], ["launch"], ["law"], ["lawyer"], ["lay"], 
			["lead"], ["lead"], ["leader"], ["leadership"], ["leading"], ["leaf"], ["league"], ["lean"], ["learn"], ["least"], 
			["leave"], ["left"], ["leg"], ["legal"], ["legislation"], ["length"], ["less"], ["less"], ["let"], ["letter"], 
			["level"], ["liability"], ["liberal"], ["library"], ["lie"], ["life"], ["lift"], ["light"], ["light"], ["like"], 
			["like"], ["likely"], ["limit"], ["limit"], ["limited"], ["line"], ["link"], ["link"], ["lip"], ["list"], 
			["listen"], ["literature"], ["little"], ["little"], ["little"], ["live"], ["living"], ["loan"], ["local"], ["location"], 
			["long"], ["long"], ["look"], ["look"], ["lord"], ["lose"], ["loss"], ["lot"], ["love"], ["love"], 
			["lovely"], ["low"], ["lunch"], ["machine"], ["magazine"], ["main"], ["mainly"], ["maintain"], ["major"], ["majority"], 
			["make"], ["male"], ["male"], ["man"], ["manage"], ["management"], ["manager"], ["manner"], ["many"], ["map"], 
			["mark"], ["mark"], ["market"], ["market"], ["marriage"], ["married"], ["marry"], ["mass"], ["master"], ["match"], 
			["match"], ["material"], ["matter"], ["matter"], ["may"], ["may"], ["maybe"], ["me"], ["meal"], ["mean"], 
			["meaning"], ["means"], ["meanwhile"], ["measure"], ["measure"], ["mechanism"], ["media"], ["medical"], ["meet"], ["meeting"], 
			["member"], ["membership"], ["memory"], ["mental"], ["mention"], ["merely"], ["message"], ["metal"], ["method"], ["middle"], 
			["might"], ["mile"], ["military"], ["milk"], ["mind"], ["mind"], ["mine"], ["minister"], ["ministry"], ["minute"], 
			["miss"], ["mistake"], ["model"], ["modern"], ["module"], ["moment"], ["money"], ["month"], ["more"], ["more"], 
			["morning"], ["most"], ["most"], ["mother"], ["motion"], ["motor"], ["mountain"], ["mouth"], ["move"], ["move"], 
			["movement"], ["much"], ["much"], ["murder"], ["museum"], ["music"], ["must"], ["my"], ["myself"], ["name"], 
			["name"], ["narrow"], ["nation"], ["national"], ["natural"], ["nature"], ["near"], ["nearly"], ["necessarily"], ["necessary"], 
			["neck"], ["need"], ["need"], ["negotiation"], ["neighbour"], ["neither"], ["network"], ["never"], ["nevertheless"], ["new"], 
			["news"], ["newspaper"], ["next"], ["next"], ["nice"], ["night"], ["no"], ["no"], ["no"], ["no-one"], 
			["nobody"], ["nod"], ["noise"], ["none"], ["nor"], ["normal"], ["normally"], ["north"], ["northern"], ["nose"], 
			["not"], ["note"], ["note"], ["nothing"], ["notice"], ["notice"], ["notion"], ["now"], ["nuclear"], ["number"], 
			["nurse"], ["object"], ["objective"], ["observation"], ["observe"], ["obtain"], ["obvious"], ["obviously"], ["occasion"], ["occur"], 
			["odd"], ["of"], ["off"], ["off"], ["offence"], ["offer"], ["offer"], ["office"], ["officer"], ["official"], 
			["official"], ["often"], ["oil"], ["okay"], ["old"], ["on"], ["on"], ["once"], ["once"], ["one"], 
			["only"], ["only"], ["onto"], ["open"], ["open"], ["operate"], ["operation"], ["opinion"], ["opportunity"], ["opposition"], 
			["option"], ["or"], ["order"], ["order"], ["ordinary"], ["organisation"], ["organise"], ["organization"], ["origin"], ["original"], 
			["other"], ["other"], ["other"], ["otherwise"], ["ought"], ["our"], ["ourselves"], ["out"], ["outcome"], ["output"], 
			["outside"], ["outside"], ["over"], ["over"], ["overall"], ["own"], ["own"], ["owner"], ["package"], ["page"], 
			["pain"], ["paint"], ["painting"], ["pair"], ["panel"], ["paper"], ["parent"], ["park"], ["parliament"], ["part"], 
			["particular"], ["particularly"], ["partly"], ["partner"], ["party"], ["pass"], ["passage"], ["past"], ["past"], ["past"], 
			["path"], ["patient"], ["pattern"], ["pay"], ["pay"], ["payment"], ["peace"], ["pension"], ["people"], ["per"], 
			["percent"], ["perfect"], ["perform"], ["performance"], ["perhaps"], ["period"], ["permanent"], ["person"], ["personal"], ["persuade"], 
			["phase"], ["phone"], ["photograph"], ["physical"], ["pick"], ["picture"], ["piece"], ["place"], ["place"], ["plan"], 
			["plan"], ["planning"], ["plant"], ["plastic"], ["plate"], ["play"], ["play"], ["player"], ["please"], ["pleasure"], 
			["plenty"], ["plus"], ["pocket"], ["point"], ["point"], ["police"], ["policy"], ["political"], ["politics"], ["pool"], 
			["poor"], ["popular"], ["population"], ["position"], ["positive"], ["possibility"], ["possible"], ["possibly"], ["post"], ["potential"], 
			["potential"], ["pound"], ["power"], ["powerful"], ["practical"], ["practice"], ["prefer"], ["prepare"], ["presence"], ["present"], 
			["present"], ["present"], ["president"], ["press"], ["press"], ["pressure"], ["pretty"], ["prevent"], ["previous"], ["previously"], 
			["price"], ["primary"], ["prime"], ["principle"], ["priority"], ["prison"], ["prisoner"], ["private"], ["probably"], ["problem"], 
			["procedure"], ["process"], ["produce"], ["product"], ["production"], ["professional"], ["profit"], ["program"], ["programme"], ["progress"], 
			["project"], ["promise"], ["promote"], ["proper"], ["properly"], ["property"], ["proportion"], ["propose"], ["proposal"], ["prospect"], 
			["protect"], ["protection"], ["prove"], ["provide"], ["provided"], ["provision"], ["pub"], ["public"], ["public"], ["publication"], 
			["publish"], ["pull"], ["pupil"], ["purpose"], ["push"], ["put"], ["quality"], ["quarter"], ["question"], ["question"], 
			["quick"], ["quickly"], ["quiet"], ["quite"], ["race"], ["radio"], ["railway"], ["rain"], ["raise"], ["range"], 
			["rapidly"], ["rare"], ["rate"], ["rather"], ["reach"], ["reaction"], ["read"], ["reader"], ["reading"], ["ready"], 
			["real"], ["realise"], ["reality"], ["realize"], ["really"], ["reason"], ["reasonable"], ["recall"], ["receive"], ["recent"], 
			["recently"], ["recognise"], ["recognition"], ["recognize"], ["recommend"], ["record"], ["record"], ["recover"], ["red"], ["reduce"], 
			["reduction"], ["refer"], ["reference"], ["reflect"], ["reform"], ["refuse"], ["regard"], ["region"], ["regional"], ["regular"], 
			["regulation"], ["reject"], ["relate"], ["relation"], ["relationship"], ["relative"], ["relatively"], ["release"], ["release"], ["relevant"], 
			["relief"], ["religion"], ["religious"], ["rely"], ["remain"], ["remember"], ["remind"], ["remove"], ["repeat"], ["replace"], 
			["reply"], ["report"], ["report"], ["represent"], ["representation"], ["representative"], ["request"], ["require"], ["requirement"], ["research"], 
			["resource"], ["respect"], ["respond"], ["response"], ["responsibility"], ["responsible"], ["rest"], ["rest"], ["restaurant"], ["result"], 
			["result"], ["retain"], ["return"], ["return"], ["reveal"], ["revenue"], ["review"], ["revolution"], ["rich"], ["ride"], 
			["right"], ["right"], ["right"], ["ring"], ["ring"], ["rise"], ["rise"], ["risk"], ["river"], ["road"], 
			["rock"], ["role"], ["roll"], ["roof"], ["room"], ["round"], ["round"], ["route"], ["row"], ["royal"], 
			["rule"], ["run"], ["run"], ["rural"], ["safe"], ["safety"], ["sale"], ["same"], ["sample"], ["satisfy"], 
			["save"], ["say"], ["scale"], ["scene"], ["scheme"], ["school"], ["science"], ["scientific"], ["scientist"], ["score"], 
			["screen"], ["sea"], ["search"], ["search"], ["season"], ["seat"], ["second"], ["secondary"], ["secretary"], ["section"], 
			["sector"], ["secure"], ["security"], ["see"], ["seek"], ["seem"], ["select"], ["selection"], ["sell"], ["send"], 
			["senior"], ["sense"], ["sentence"], ["separate"], ["separate"], ["sequence"], ["series"], ["serious"], ["seriously"], ["servant"], 
			["serve"], ["service"], ["session"], ["set"], ["set"], ["settle"], ["settlement"], ["several"], ["severe"], ["sex"], 
			["sexual"], ["shake"], ["shall"], ["shape"], ["share"], ["share"], ["she"], ["sheet"], ["ship"], ["shoe"], 
			["shoot"], ["shop"], ["short"], ["shot"], ["should"], ["shoulder"], ["shout"], ["show"], ["show"], ["shut"], 
			["side"], ["sight"], ["sign"], ["sign"], ["signal"], ["significance"], ["significant"], ["silence"], ["similar"], ["simple"], 
			["simply"], ["since"], ["since"], ["sing"], ["single"], ["sir"], ["sister"], ["sit"], ["site"], ["situation"], 
			["size"], ["skill"], ["skin"], ["sky"], ["sleep"], ["slightly"], ["slip"], ["slow"], ["slowly"], ["small"], 
			["smile"], ["smile"], ["so"], ["so"], ["social"], ["society"], ["soft"], ["software"], ["soil"], ["soldier"], 
			["solicitor"], ["solution"], ["some"], ["somebody"], ["someone"], ["something"], ["sometimes"], ["somewhat"], ["somewhere"], ["son"], 
			["song"], ["soon"], ["sorry"], ["sort"], ["sound"], ["sound"], ["source"], ["south"], ["southern"], ["space"], 
			["speak"], ["speaker"], ["special"], ["species"], ["specific"], ["speech"], ["speed"], ["spend"], ["spirit"], ["sport"], 
			["spot"], ["spread"], ["spring"], ["staff"], ["stage"], ["stand"], ["standard"], ["standard"], ["star"], ["star"], 
			["start"], ["start"], ["state"], ["state"], ["statement"], ["station"], ["status"], ["stay"], ["steal"], ["step"], 
			["step"], ["stick"], ["still"], ["stock"], ["stone"], ["stop"], ["store"], ["story"], ["straight"], ["strange"], 
			["strategy"], ["street"], ["strength"], ["strike"], ["strike"], ["strong"], ["strongly"], ["structure"], ["student"], ["studio"], 
			["study"], ["study"], ["stuff"], ["style"], ["subject"], ["substantial"], ["succeed"], ["success"], ["successful"], ["such"], 
			["suddenly"], ["suffer"], ["sufficient"], ["suggest"], ["suggestion"], ["suitable"], ["sum"], ["summer"], ["sun"], ["supply"], 
			["supply"], ["support"], ["support"], ["suppose"], ["sure"], ["surely"], ["surface"], ["surprise"], ["surround"], ["survey"], 
			["survive"], ["switch"], ["system"], ["table"], ["take"], ["talk"], ["talk"], ["tall"], ["tape"], ["target"], 
			["task"], ["tax"], ["tea"], ["teach"], ["teacher"], ["teaching"], ["team"], ["tear"], ["technical"], ["technique"], 
			["technology"], ["telephone"], ["television"], ["tell"], ["temperature"], ["tend"], ["term"], ["terms"], ["terrible"], ["test"], 
			["test"], ["text"], ["than"], ["thank"], ["thanks"], ["that"], ["that"], ["the"], ["theatre"], ["their"], 
			["them"], ["theme"], ["themselves"], ["then"], ["theory"], ["there"], ["there"], ["therefore"], ["these"], ["they"], 
			["thin"], ["thing"], ["think"], ["this"], ["those"], ["though"], ["though"], ["thought"], ["threat"], ["threaten"], 
			["through"], ["through"], ["throughout"], ["throw"], ["thus"], ["ticket"], ["time"], ["tiny"], ["title"], ["to"], 
			["to"], ["to"], ["today"], ["together"], ["tomorrow"], ["tone"], ["tonight"], ["too"], ["tool"], ["tooth"], 
			["top"], ["top"], ["total"], ["total"], ["totally"], ["touch"], ["touch"], ["tour"], ["towards"], ["town"], 
			["track"], ["trade"], ["tradition"], ["traditional"], ["traffic"], ["train"], ["train"], ["training"], ["transfer"], ["transfer"], 
			["transport"], ["travel"], ["treat"], ["treatment"], ["treaty"], ["tree"], ["trend"], ["trial"], ["trip"], ["troop"], 
			["trouble"], ["true"], ["trust"], ["truth"], ["try"], ["turn"], ["turn"], ["twice"], ["type"], ["typical"], 
			["unable"], ["under"], ["under"], ["understand"], ["understanding"], ["undertake"], ["unemployment"], ["unfortunately"], ["union"], ["unit"], 
			["united"], ["university"], ["unless"], ["unlikely"], ["until"], ["until"], ["up"], ["up"], ["upon"], ["upper"], 
			["urban"], ["us"], ["use"], ["use"], ["used"], ["used"], ["useful"], ["user"], ["usual"], ["usually"], 
			["value"], ["variation"], ["variety"], ["various"], ["vary"], ["vast"], ["vehicle"], ["version"], ["very"], ["very"], 
			["via"], ["victim"], ["victory"], ["video"], ["view"], ["village"], ["violence"], ["vision"], ["visit"], ["visit"], 
			["visitor"], ["vital"], ["voice"], ["volume"], ["vote"], ["vote"], ["wage"], ["wait"], ["walk"], ["walk"], 
			["wall"], ["want"], ["war"], ["warm"], ["warn"], ["wash"], ["watch"], ["water"], ["wave"], ["way"], 
			["we"], ["weak"], ["weapon"], ["wear"], ["weather"], ["week"], ["weekend"], ["weight"], ["welcome"], ["welfare"], 
			["well"], ["well"], ["west"], ["western"], ["what"], ["whatever"], ["when"], ["when"], ["where"], ["where"], 
			["whereas"], ["whether"], ["which"], ["while"], ["while"], ["whilst"], ["white"], ["who"], ["whole"], ["whole"], 
			["whom"], ["whose"], ["why"], ["wide"], ["widely"], ["wife"], ["wild"], ["will"], ["will"], ["win"], 
			["wind"], ["window"], ["wine"], ["wing"], ["winner"], ["winter"], ["wish"], ["with"], ["withdraw"], ["within"], 
			["without"], ["woman"], ["wonder"], ["wonderful"], ["wood"], ["word"], ["work"], ["work"], ["worker"], ["working"], 
			["works"], ["world"], ["worry"], ["worth"], ["would"], ["write"], ["writer"], ["writing"], ["wrong"], ["yard"], 
			["yeah"], ["year"], ["yes"], ["yesterday"], ["yet"], ["you"], ["young"], ["your"], ["yourself"], ["youth"]];		
		
			
		//Outras variáveis
		public var versosInfo:Array = new Array();
		public var loadedSubtitles:Boolean = false;
		public var timeFirstVerse:Number = 0;
		public var totalDeVersos:Number = 0;
		public var minSum:Number = 1000;
		public var maxSum:Number = 0;
		public var contMusica:Number = 0;
		public var youtubePlayer:ChromelessPlayer;
		public var _subtitles:Array;
		public var musicaAtual:String;
		
		public function DifficultyCalculator() {
			//Carrega o XML de musicsToIds
			var mtoidLoader:URLLoader = new URLLoader();
			mtoidLoader.load(new URLRequest("Musicas/Index/MusicsIDs.xml"));
			mtoidLoader.addEventListener(Event.COMPLETE, onLoadedMainXML);
		}
		
		protected function onLoadedMainXML(event:Event):void {
			musicIDs = new XML(event.target.data);
			calculaMusica(contMusica);			
		}
		
		private function calculaMusica(contMusica:Number):void {
			if(contMusica<musicas.length){
				musicaAtual = musicas[contMusica];
				var subtitle:DataLoader = new DataLoader("Musicas/" + musicas[contMusica] + "/legenda.srt");
				subtitle.addEventListener(LoaderEvent.COMPLETE, handleSubtitleLoaded);
				subtitle.addEventListener(LoaderEvent.ERROR, onError);
				subtitle.addEventListener(LoaderEvent.FAIL, onError);
				subtitle.addEventListener(LoaderEvent.IO_ERROR, onError);
				subtitle.load(true);				
			} else {
				trace("Menor dificuldade: "+minSum);
				trace("Maior dificuldade: "+maxSum);
				trace("\nDificuldades:\n");
				
				var difFinal:Number = 0;
				for(var i:int = 0;i<musicas.length;i++) {
					difFinal = Math.round(100*(difOriginal[i]-minSum)/(maxSum-minSum));
					if(difFinal==0){ difFinal = 1; }
					trace(musicas[i]+":$ "+difFinal);
				}
			}
		}
		
		protected function onError(event:LoaderEvent):void {
			contMusica++;
			calculaMusica(contMusica);			
		}
		
		private function handleSubtitleLoaded(event:Event):void {
			_subtitles = SubtitleParser.parseSRT(DataLoader(event.currentTarget).content);
			loadedSubtitles = true;
			setDuration(null);
		}
				
		public function setDuration(e:Event){
			var duration:Number = _subtitles[_subtitles.length-1].end;
			trace("duracao: "+duration);
			
			if(duration!=0) {	
				var auxSum1:Number = 0; 
				var auxSum2:Number = 0;
				var auxSum3:Number = 0;
				var auxSum4:Number = 0;
				
				//Calcula velocidade média de cada verso
				for each(var trio:Object in _subtitles){
					auxSum1 += (Number(trio.text.length)+0.001)/(Number(trio.end)-Number(trio.start)+0.001);
				}
				auxSum1 = auxSum1/_subtitles.length;
				trace("auxSum1: "+auxSum1);
				
				//Calcula frequência de versos
				auxSum2 = _subtitles.length/duration;
				trace("auxSum2: "+auxSum2);
				
				//Calcula quantidade de versos
				auxSum3 = _subtitles.length;
				trace("auxSum3: "+auxSum3);
				
				//"Calcula" quantas palavras são pertencentes às 2000 mais faladas
				var comuns:Number = 0;
				var total:Number = 0;
				for each(var trio2:Object in _subtitles){
					for each(var palavra:String in trio2.text.split(' ')){
						for each(var word:String in commonWords){
							if(palavra == word){
								comuns++;
								total++;
								break;
							}
						}
						total++;
					}
				}
				auxSum4 = comuns/total;
				trace("auxSum4: "+auxSum4);
				
				//Ajusta as variáveis para ficarem entre 0 e 1 a partir das medições empíricas de máx e min
				if(auxSum1<10) {auxSum1 = 0;}
				else if(auxSum1>20) {auxSum1 = 1;}
				else {	auxSum1 = (auxSum1-10)/(20-10); }
				
				if(auxSum2<0.15) {auxSum2 = 0;}
				else if(auxSum2>0.5) {auxSum2 = 1}
				else {	auxSum2 = (auxSum2-0.15)/(0.5-0.15); }
				
				if(auxSum3<15) {auxSum3 = 0;}
				else if(auxSum3>150) {auxSum3 = 1;}
				else { auxSum3 = (auxSum3-15)/(150-15); }
				
				difOriginal[contMusica] = 4.5*auxSum1+3*auxSum2+1*auxSum3+1.5*(1-auxSum4);
				trace("difOriginal de "+musicaAtual+": "+difOriginal[contMusica]);
				
				if(difOriginal[contMusica]<minSum){
					minSum = difOriginal[contMusica];
				}
				if(difOriginal[contMusica]>maxSum){
					maxSum = difOriginal[contMusica];
				}
			} else {
				trace("Musica "+musicaAtual+" ta bixada");
			}
			
			contMusica++;
			calculaMusica(contMusica);
		}
				
	}
}