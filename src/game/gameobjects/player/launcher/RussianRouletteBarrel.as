package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import lbg.utils.ArrayUtils;
	import org.osflash.signals.Signal;
	import src.UiScaler;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class RussianRouletteBarrel extends MovieClip 
	{
		public var cylinder:MovieClip;
		public var fireSignal:Signal = new Signal(Number);
		public var spinSignal:Signal = new Signal();
		
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _targets:Vector.<MovieClip> = new Vector.<MovieClip>();
		protected var _bullets:Array = new Array();
		
		protected var _offset:int;//How offset bullets are after spinning. Used to determine which bullet is struck.
		
		public function RussianRouletteBarrel(item:GameStateItem) 
		{
			scaleX = scaleY = 1.4;
			x = 570;
			y = 230;
			
			GameCamera.instance.addChildToFixedLayer(this, 3);
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_wrapper.useDeltaTime = false;
			
			_targets.push(cylinder.target1);
			_targets.push(cylinder.target2);
			_targets.push(cylinder.target3);
			_targets.push(cylinder.target4);
			_targets.push(cylinder.target5);
			_targets.push(cylinder.target6);
			
			var i:int;
			var b:MovieClip;
			for (i = 0; i < item.statStageSlots; i++) {
				//Great shots
				b = new src.game.gameobjects.player.launcher.RussianRouletteBullet();
				b.gotoAndStop("great");
				_bullets.push(b);
			}
			for (i = 0; i < item.statSpecial; i++) {
				//bad shots
				b = new src.game.gameobjects.player.launcher.RussianRouletteBullet();
				b.gotoAndStop("bad");
				_bullets.push(b);
			}
			for (i = 0; i < (6 - item.statStageSlots - item.statSpecial); i++) {
				//good shots
				b = new src.game.gameobjects.player.launcher.RussianRouletteBullet();
				b.gotoAndStop("good");
				_bullets.push(b);
			}
			
			_bullets = ArrayUtils.shuffleArray(_bullets);
			
			for (i = 0; i < 6; i++) {
				cylinder.addChild(_bullets[i] as MovieClip);
				_bullets[i].x = _targets[i].x;
				_bullets[i].y = _targets[i].y;
			}
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.addOnce(spin);
			
			UiScaler.addAbsolute(this);
		}
		
		private function spin():void 
		{
			spinSignal.dispatch();
			_wrapper.setToSpecial();
			
			var i:int;
			_offset = int(Math.random() * 5.999);
			var loopedI:int;
			
			for (i = 0; i < 6; i++) {
				loopedI = (i + _offset >= 6) ? (i + _offset - 6): (i + _offset);
				_bullets[loopedI].x = _targets[i].x;
				_bullets[loopedI].y = _targets[i].y;
			}
			
			Main.unsafeTickSignal.add(tick);
		}
		
		private function tick(delta:Number):void 
		{
			if (_wrapper.currentLabel == "specialEnd") {
				_wrapper.setToDeath();
				//trace("BOOM!");
				switch(_bullets[_offset].currentLabel) {
					case "great":
						fireSignal.dispatch(2);
						break;
					case "good":
						fireSignal.dispatch(1);
						break;
					case "bad":
						fireSignal.dispatch(0);
						break;
					default:
						Log.log("RussianRouletteBarrel tick() error - Incorrect bullet currentLabel");
						fireSignal.dispatch(0);
						break;
				}
			}
		}
		
	}

}