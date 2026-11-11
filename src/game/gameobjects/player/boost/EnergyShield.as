package src.game.gameobjects.player.boost 
{
	import flash.geom.Rectangle;
	import lbg.utils.NumberUtils;
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameMediator;
	import src.game.StatHooks;
	import src.game.gameobjects.obstacles.Obstacle;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class EnergyShield extends SimpleBoost 
	{
		protected var _obstaclesWeightMod:Mod;
		
		public function EnergyShield(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_obstaclesWeightMod = StatHooks.obstacleMassMult.addMod2(0, 0.00000001);//Completely nullify obstacles mass
			GameMediator.obstacleHit.add(onObstacleHit);
		}
		
		protected function onObstacleHit(o:Obstacle):void {
			if (!o || !fuel || !leftVisual || !_hudSignal || !_player || !_obstaclesWeightMod) return;
			
			//trace(o, fuel, _hudSignal, _player);
			
			var fuelBeforeTick:Number = fuel.value;
			
			if (fuel.value > 0) {
				var dmg:Number = o.killObstacleFromShield(fuel.value);
				
				if (dmg > 0) {
					fuel.value-= dmg;
					leftVisual.alpha = 1;
					
				}
			}
			
			_hudSignal.dispatch(fuel.value / maxFuel);
			
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_obstaclesWeightMod.destroy();
				_player.updateBodyMass();
			}
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			//_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body
			leftVisual.alpha = 0;
			
			
			leftVisual.scaleX = leftVisual.scaleY = ((_player.playerBaseSpriteSize + 20) / leftVisual.width);
			
			//trace("setupVisual", leftVisual.scaleX, _player.playerBaseSpriteSize);
		}
		
		override public function tick(delta:Number):void 
		{
			//super.tick(delta);
			if (leftVisual.alpha > 1) leftVisual.alpha = 1;
			leftVisual.alpha -= 0.03 * delta;
			if (leftVisual.alpha < 0) leftVisual.alpha = 0;
			
			if (leftVisual.alpha <= 0) {
				if (leftVisual.parent) leftVisual.parent.removeChild(leftVisual);
			}else {
				if (!leftVisual.parent) _player.getMovieClip().addChild(leftVisual);
			}
			
		}
		
		
		
		/** Disregard normal params and override to make it centered on player */
		override public function setAnchor(leftX:Number, rightX:Number, leftRotation:Number, rightRotation:Number, Y:Number):void 
		{
			super.setAnchor(_player.getMovieClip().x, -_player.getMovieClip().x, _player.getMovieClip().rotation, 180 - _player.getMovieClip().rotation, _player.getMovieClip().y);
			//super.setAnchor(_player.tCenter.x, -_player.tCenter.x, _player.tCenter.rotation, 180 - _player.tCenter.rotation, _player.tCenter.y);
		}
		
		
	}

}