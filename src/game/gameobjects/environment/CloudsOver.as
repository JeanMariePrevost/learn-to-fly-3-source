package src.game.gameobjects.environment 
{
	/**
	 * ...
	 * @author 
	 */
	public class CloudsOver extends Clouds 
	{
		
		public function CloudsOver() 
		{
			super();
			
			_minCloudsNodeScale = 2.5;
			_maxCloudsNodeScale = 5;
			_cloudCount = 5;
			_spawnZoneBuffer = 800;
		}
		
		override protected function addCloud():void {
			var cloud:CloudsOverNode = new CloudsOverNode(_viewDiagonal, _spawnDiagonal, _centerPoint, _minCloudsNodeScale, _maxCloudsNodeScale);
			addChild(cloud);
			_clouds.push(cloud);
			_unsortedClouds.push(cloud);
		}
	}

}