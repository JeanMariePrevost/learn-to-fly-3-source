package src.spaceinvader 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.audio.Sfx;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Player extends MovieClip 
	{
		protected var _speed:Number = 9;
		protected var _marginLeft:Number = 98;
		protected var _marginRight:Number = 570;
		
		protected var _bulletTime:Number = 0;
		protected var _bulletDuration:Number = 12;
		
		public function Player() 
		{
			super();
			_bulletTime = _bulletDuration;
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			if (!stage) {
				destroy();
				return;
			}
			
			if (Input.metaLeft.isDown) {
				x -= _speed;
			}
			
			if (Input.metaRight.isDown) {
				x += _speed;
			}
			
			//trace(x);
			x = NumberUtils.constrain(x, _marginLeft, _marginRight);
			
			
			if (Input.metaBoost.isDown && _bulletTime <= 0) {
				var b:Bullet = new PlayerBullet();
				b.x = x;
				b.y = y - 30;
				GameScreen.instance.addChild(b);
				_bulletTime = _bulletDuration;
				Sfx.playInvaderPlayerFire();
			}
			
			_bulletTime -= 1;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
	}

}