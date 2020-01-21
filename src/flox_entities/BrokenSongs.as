package flox_entities
{
	import com.gamua.flox.Entity;

	public class BrokenSongs extends Entity {
		
		private var _currBroken:Array;
		
		public function BrokenSongs() {
			
		}
		
		public function get currBroken():Array
		{
			return _currBroken;
		}

		public function set currBroken(value:Array):void
		{
			_currBroken = value;
		}

	}
}