package flox_entities
{
	import com.gamua.flox.Entity;

	public class Invites extends Entity {
		private var _sent:Array;
		private var _currRankingDate:Date;
		private var _viramCurrRanking:Array;
		
		public function Invites() {
				
		}
		
		public function get viramCurrRanking():Array {
			return _viramCurrRanking;
		}

		public function set viramCurrRanking(value:Array):void {
			_viramCurrRanking = value;
		}

		public function get currRankingDate():Date {
			return _currRankingDate;
		}

		public function set currRankingDate(value:Date):void {
			_currRankingDate = value;
		}

		public function get sent():Array {
			return _sent;
		}

		public function set sent(value:Array):void {
			_sent = value;
		}

	}
}