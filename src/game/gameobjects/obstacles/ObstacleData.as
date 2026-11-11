package src.game.gameobjects.obstacles 
{
	import src.game.gameobjects.obstacles.obstacles.*;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class ObstacleData 
	{
		protected static var _data:Vector.<ObstacleDataEntry>;
		
		
		public static function getObstacleType(altitude:Number):Class {
			buildData();
			
			var norm:Number = altitude / Global.spaceAltitude;
			
			if (_data == null || _data.length <= 0) {
				throw new Error("ObstacleData - getObstacleType() error: no obstacles data.");
				return null;
			}
			
			var totalOdds:Number = 0;
			
			for (var i:int = 0; i < _data.length; i++) {
				totalOdds += _data[i].spawnRates.valueAt(norm);
			}
			
			if (totalOdds <= 0) {
				throw new Error("ObstacleData - getObstacleType() error: no obstacle spawn at this altitude: [" + altitude + "].");
				return _data[0].obstacleClass;
			}
			
			var r:Number = Math.random() * totalOdds;
			
			for (var i:int = 0; i < _data.length; i++) {
				r -= _data[i].spawnRates.valueAt(norm);
				if (r <= 0) {
					return _data[i].obstacleClass;
				}
			}
			
			throw new Error("ObstacleData - getObstacleType() error: random value was outside odds range.");
			return _data[0].obstacleClass;
		}
		
		protected static function buildData():void {
			if (_data != null) {
				return;
			}
			
			_data = new Vector.<ObstacleDataEntry>()
			
			var e:ObstacleDataEntry;
			
			//levels work like: (space altitude ratio, odds of seeing obstacle)
			
			//"Level 1"
			
			e = newEntry(PaperPlane);
			e.spawnRates.addLevel(-1000, 1);
			e.spawnRates.addLevel(0, 1);
			e.spawnRates.addLevel(0.1, 0);
			
			e = newEntry(Kite);
			e.spawnRates.addLevel(0, 1);
			e.spawnRates.addLevel(0.15, 0);
			
			e = newEntry(Seagull);
			e.spawnRates.addLevel(0, 0.1);
			e.spawnRates.addLevel(0.1, 1);
			e.spawnRates.addLevel(0.2, 0);
			
			e = newEntry(FlappyBird);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.1, 0.3);
			e.spawnRates.addLevel(0.21, 0);
			
			e = newEntry(RCPlane);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.1, 1);
			e.spawnRates.addLevel(0.21, 0);
			
			
			
			//"Level 2"
			
			e = newEntry(Parachute);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(Albatross);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(HotAirBalloon);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(StudentDriver);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(StudentDriver2);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(StudentDriver3);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			e = newEntry(Drone);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.2, 0);
			e.spawnRates.addLevel(0.3, 1);
			e.spawnRates.addLevel(0.41, 0);
			
			
			
			
			//"Level 3"
			
			e = newEntry(Copter);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(RescueCopter);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(NewsCopter);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(MilitaryCopter);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(JetpackBaby);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(BigHotAirBalloon);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			e = newEntry(BananaPlane);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.4, 0);
			e.spawnRates.addLevel(0.5, 1);
			e.spawnRates.addLevel(0.61, 0);
			
			
			
			
			//"Level 4"
			
			e = newEntry(Zeppelin);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.6, 0);
			e.spawnRates.addLevel(0.7, 1);
			e.spawnRates.addLevel(0.81, 0);
			
			e = newEntry(Jet);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.6, 0);
			e.spawnRates.addLevel(0.7, 1);
			e.spawnRates.addLevel(0.81, 0);
			
			e = newEntry(BigPlane);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.6, 0);
			e.spawnRates.addLevel(0.7, 0.6);
			e.spawnRates.addLevel(0.81, 0);
			
			e = newEntry(titanFall);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.6, 0);
			e.spawnRates.addLevel(0.7, 0.3);
			e.spawnRates.addLevel(0.81, 0);
			
			
			
			//"Level 5"
			
			e = newEntry(Comet);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(Comet2);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(FastComet);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(Satelite);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(Satelite2);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.3);
			
			e = newEntry(SpaceCore);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(SpaceWaste);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(SpaceWaste2);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(Tardis);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.2);
			
			e = newEntry(PotatoGlados);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.2);
			
			e = newEntry(FrozenDodo);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.8);
			
			e = newEntry(Dodolith);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.5);
			
			e = newEntry(Saucer);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 1);
			
			e = newEntry(Mothership);
			e.spawnRates.addLevel(0, 0);
			e.spawnRates.addLevel(0.8, 0);
			e.spawnRates.addLevel(1, 0.2);
			
		}
		
		protected static function newEntry(obstacleClass:Class):ObstacleDataEntry {
			var e:ObstacleDataEntry = new ObstacleDataEntry();
			e.obstacleClass = obstacleClass;
			_data.push(e);
			return e;
		}
		
	}

}