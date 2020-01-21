package flox_entities {
	
	import com.gamua.flox.Entity;
	
	public class GameMatch extends Entity {
		private var sender:String;
		private var receiver:String;
		private var estilo:String;
		private var musica:String;
		private var betType:String
		private var winner:String;
		private var dateCreated:Date;
		private var senderInGameInfo:Array;
		private var receiverInGameInfo:Array;
		private var jaJogouRecEJaViuSender:String;
		
		
		public function GameMatch() {
			
		}

		public function get _jaJogouRecEJaViuSender():String
		{
			return jaJogouRecEJaViuSender;
		}

		public function set _jaJogouRecEJaViuSender(value:String):void
		{
			jaJogouRecEJaViuSender = value;
		}

		public function get _winner():String
		{
			return winner;
		}

		public function set _winner(value:String):void
		{
			winner = value;
		}

		public function get _betType():String
		{
			return betType;
		}

		public function set _betType(value:String):void
		{
			betType = value;
		}

		public function get _receiverInGameInfo():Array
		{
			return receiverInGameInfo;
		}

		public function set _receiverInGameInfo(value:Array):void
		{
			receiverInGameInfo = value;
		}

		public function get _musica():String
		{
			return musica;
		}

		public function set _musica(value:String):void
		{
			musica = value;
		}

		public function get _estilo():String
		{
			return estilo;
		}

		public function set _estilo(value:String):void
		{
			estilo = value;
		}

		public function get _senderInGameInfo():Array
		{
			return senderInGameInfo;
		}

		public function set _senderInGameInfo(value:Array):void
		{
			senderInGameInfo = value;
		}

		public function get _dateCreated():Date
		{
			return dateCreated;
		}

		public function set _dateCreated(value:Date):void
		{
			dateCreated = value;
		}

		public function get _receiver():String
		{
			return receiver;
		}

		public function set _receiver(value:String):void
		{
			receiver = value;
		}

		public function get _sender():String
		{
			return sender;
		}

		public function set _sender(value:String):void
		{
			sender = value;
		}

	}
}