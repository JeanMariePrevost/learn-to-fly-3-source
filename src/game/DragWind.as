package src.game 
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	
	/**
	 * ...
	 * @author 
	 */
	public class DragWind extends MovieClip 
	{
		protected var _player:Player;
		protected var _scale:Number;
		
		public function DragWind(player:Player) 
		{
			super();
			
			_player = player;
			
			_scale = (_player.playerBaseSpriteSize + 20) / width;
			scaleX = scaleY = _scale;
			//trace("Scale:", _scale);
			//trace("setupVisual", _scale, _player.playerBaseSpriteSize);
			
			alpha = 0;
			
			GameMediator.updatePlayerSpeed.add(onSpeed);
			GameMediator.updatePlayerDrag.add(onDrag);
		}
		
		private function onSpeed(speed:Number, angleInDegrees:Number):void 
		{
			rotation = angleInDegrees - _player.getMovieClip().rotation + 90;
		}
		
		private function onDrag(drag:Number):void 
		{
			//trace("Drag:", drag);
			var multFromSpeed:Number = NumberUtils.interpolate2(0, 1.5, 10, 30, _player.speed, 1.5);
			
			alpha = NumberUtils.interpolate2(0, multFromSpeed, 0.991, 0.97, drag, 1.5);
			
			scaleX = scaleY = _scale * NumberUtils.randomRange(0.98, 1.02);
			
			
		}
		
		public function destroy():void {
			_player = null;
			
			GameMediator.updatePlayerSpeed.remove(onSpeed);
			GameMediator.updatePlayerDrag.remove(onDrag);
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}