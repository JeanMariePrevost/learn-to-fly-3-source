package src.game.gameobjects.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.game.GameCamera;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeadObstacle extends MovieClip 
	{
		protected var _gravity:Number = 0.5;
		protected var _drag:Number = 0.99;
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _vr:Number;
		protected var _vs:Number;//Vector SCALE, how fast it zooms out
		
		public function DeadObstacle(baseVisual:MovieClip, player:Player, collisionPower:Number) 
		{
			x = baseVisual.x;
			y = baseVisual.y;
			if (baseVisual.stage) baseVisual.parent.removeChild(baseVisual);
			addChild(baseVisual);
			baseVisual.x = 0;
			baseVisual.y = 0;
			GameCamera.instance.addChildToMovingLayer(this, 1);//debug - depth 0 by default
			
			Main.unsafeTickSignal.add(tick);
			
			//trace("collisionPower:", collisionPower);
			
			var angle:Number = Trig.angleToObject(player.getMovieClip(), this);
			var midAngle:Number = NumberUtils.interpolateRotation(Math.min(angle, player.speedAngle), Math.max(angle, player.speedAngle));
			var speed:Number = NumberUtils.randomRange(0.8, 1.2) * NumberUtils.interpolate2(5, 60, 0.5, 8, collisionPower, 0.9);
			
			//trace("Dead obstacle angles:", angle, player.speedAngle, ((angle + player.speedAngle) / 2), midAngle);
			//trace("Dead obstacle speed:", speed, "Power:", collisionPower, "PlayerSpeed:", player.speed);
			var howCloseToPlayerDirection:Number = NumberUtils.interpolate2(1, 0, 0, 180, Math.abs(midAngle - player.speedAngle));
			var adjustmentNorm:Number = NumberUtils.interpolate2(0.8, 0.2 + (howCloseToPlayerDirection * 0.6), 0, 35, player.speed);
			speed = NumberUtils.interpolate(speed, player.speed, adjustmentNorm);
			//trace("Adjusted:", speed);
			
			_vx = Trig.vectorX(speed, midAngle);
			_vy = Trig.vectorY(speed, midAngle);
			_vr = NumberUtils.randomBoth(3 + (collisionPower * 0.6));
			_vs = NumberUtils.randomRange(0.005, 0.02);
		}
		
		protected function tick(delta:Number):void {
			x += _vx;
			y += _vy;
			rotation += _vr;
			_vy += _gravity;
			_vx *= _drag;
			_vy *= _drag;
			_vr *= _drag;
			
			DisplayObjectUtil.setObjectTint(this, GameMediator.skyColor, NumberUtils.constrain(1 - scaleX, 0, 1));
			
			scaleX = scaleY = scaleX - _vs;
			if (scaleX <= 0) {
				Main.unsafeTickSignal.remove(tick);
				DisplayObjectUtil.removeAllChildFrom(this, true);
			}
		}
		
	}

}