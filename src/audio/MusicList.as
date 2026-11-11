package src.audio 
{
	import lbg.debug.Log;
	/**
	 * ...
	 * @author 
	 */
	public class MusicList 
	{
		protected static var _list:Vector.<MusicEntry>;
		
		/** Get an entry by any track class name (e.g. "MusicRock1") */
		public static function getEntry(trackName:String):MusicEntry {
			buildList();
			
			for each(var e:MusicEntry in _list) {
				if (e.track1AsString == trackName || e.track2AsString == trackName || e.track3AsString == trackName) {
					return e;
				}
			}
			
			Log.log("MusicList getEntry() ERROR - could not find any entry for track name", trackName);
			
			return null;
		}
		
		public static function getClassOf(trackName:String):Class {
			buildList();
			
			for each(var e:MusicEntry in _list) {
				if (e.track1AsString == trackName) {
					return e.track1;
				}else if (e.track2AsString == trackName) {
					return e.track2;
				}else if (e.track3AsString == trackName) {
					return e.track3;
				}
			}
			
			Log.log("MusicList getClassOf() ERROR - could not find any entry for track name", trackName);
			
			return null;
		}
		
		protected static function buildList():void {
			if (_list) return;
			
			_list = new Vector.<MusicEntry>();
			
			var e:MusicEntry;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Bonus Shop 1";
			e.track1 = MusicBonusShop1;
			e.cost = 50;
			e.slotFrame = 3;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Bonus Shop 2";
			e.track1 = MusicBonusShop2;
			e.cost = 50;
			e.slotFrame = 3;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Bonus Shop 3";
			e.track1 = MusicBonusShop3;
			e.cost = 50;
			e.slotFrame = 3;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 1";
			e.track1 = MusicShop1;
			e.cost = 50;
			e.slotFrame = 2;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 2";
			e.track1 = MusicShop2;
			e.cost = 50;
			e.slotFrame = 2;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 3";
			e.track1 = MusicShop3;
			e.cost = 50;
			e.slotFrame = 2;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 4";
			e.track1 = MusicShop4;
			e.cost = 50;
			e.slotFrame = 2;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 5";
			e.track1 = MusicShop5;
			e.cost = 50;
			e.slotFrame = 2;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Shop 6";
			e.track1 = MusicShop6;
			e.cost = 50;
			e.slotFrame = 2;
			
			
			//Game tracks
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Main Theme";
			e.track1 = MusicPunk1;
			e.track2 = MusicPunk2;
			e.track3 = MusicPunk3;
			e.cost = 0;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Chill bird";
			e.track1 = MusicChill1;
			e.track2 = MusicChill2;
			e.track3 = MusicChill3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "EPIC";
			e.track1 = MusicEpic1;
			e.track2 = MusicEpic2;
			e.track3 = MusicEpic3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Surfin";
			e.track1 = MusicSurf1;
			e.track2 = MusicSurf2;
			e.cost = 75;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Old School";
			e.track1 = MusicRetro1;
			e.track2 = MusicRetro2;
			e.track3 = MusicRetro3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Hyped!";
			e.track1 = MusicHype1;
			e.track2 = MusicHype2;
			e.track3 = MusicHype3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Space Rock";
			e.track1 = MusicSpace1;
			e.track2 = MusicSpace2;
			e.track3 = MusicSpace3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Tough Rock";
			e.track1 = MusicRock1;
			e.track2 = MusicRock2;
			e.track3 = MusicRock3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Electro";
			e.track1 = MusicElectro1;
			e.track2 = MusicElectro2;
			e.track3 = MusicElectro3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Light & Bright";
			e.track1 = MusicCalm1;
			e.track2 = MusicCalm2;
			e.track3 = MusicCalm3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Hard Work";
			e.track1 = MusicHardWork1;
			e.track2 = MusicHardWork2;
			e.track3 = MusicHardWork3;
			e.cost = 100;
			e.slotFrame = 4;
			
			e = new MusicEntry();
			_list.push(e);
			e.title = "Arrogant Beat";
			e.track1 = MusicBeat1;
			e.track2 = MusicBeat2;
			e.track3 = MusicBeat3;
			e.cost = 100;
			e.slotFrame = 4;
			
			
		}
		
		
	}

}