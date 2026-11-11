package src.game.gameobjects.player.rudder 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.game.GameMediator;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.Player;
	import src.game.MouseControlIndicator;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class SimpleRudder implements IPlayerGear 
	{
		protected var _item:GameStateItem;
		protected var _player:Player;
		
		protected var _smoothSteeringLeft:Number = 0;
		protected var _smoothSteeringRight:Number = 0;
		
		protected var _mouseControlIndicator:MouseControlIndicator;
		
		public function SimpleRudder(player:Player, item:GameStateItem) 
		{
			_player = player;
			_item = item;
			
			_mouseControlIndicator = new MouseControlIndicator()
			_player.getMovieClip().addChild(_mouseControlIndicator);
			_mouseControlIndicator.alpha = 0;
			
			Main.guiTickSignal.add(updateMouseAngle);
		}
		
		/** The torque of the body + flat bonuses */
		public function get flatTorque():Number {
			return _player.item.statTorque + StatHooks.rudderFlat.value;
		}
		
		public function tick(delta:Number):void 
		{
			if (ProfileState.instance.optionMouseControl >= 1) {
				tickMouseControl(delta);
				return; //No regular control when mouse-controlled
			}
			
			
			var steeringMultFromOptions:Number = ProfileState.instance.optionSteeringPower;
			
			if (ProfileState.instance.optionSmoothSteering <= 0) {
				//Direct steering
				if (Input.metaLeft.isDown) {
					applyRudderSteering(-flatTorque, delta);
				}else if (Input.metaRight.isDown) {
					applyRudderSteering(flatTorque, delta);
				}
			}else {
				//Smooth steering
				if (Input.metaLeft.isDown) {
					_smoothSteeringLeft += delta;
					_smoothSteeringRight *= 0.9;
					_smoothSteeringRight -= delta * 2;
				}else if (Input.metaRight.isDown) {
					_smoothSteeringRight += delta;
					_smoothSteeringLeft *= 0.9;
					_smoothSteeringLeft -= delta * 2;
				}else {
					_smoothSteeringRight *= 0.9;
					_smoothSteeringLeft *= 0.9;
					_smoothSteeringLeft -= delta * 2;
					_smoothSteeringRight -= delta * 2;
				}
				
				_smoothSteeringLeft = NumberUtils.constrain(_smoothSteeringLeft, 0, Global.defaultFramerate * ProfileState.instance.optionSmoothSteering);
				_smoothSteeringRight = NumberUtils.constrain(_smoothSteeringRight, 0, Global.defaultFramerate * ProfileState.instance.optionSmoothSteering);
				
				//trace("_smoothSteeringLeft:", _smoothSteeringLeft);
				//trace("_smoothSteeringRight:", _smoothSteeringRight);
				
				if (_smoothSteeringLeft != 0 || _smoothSteeringRight != 0) {
					var steeringValue:Number = _smoothSteeringRight - _smoothSteeringLeft;
					
					if (steeringValue >= 0) {
						steeringValue = NumberUtils.interpolate2(0, 1, 0, Global.defaultFramerate * ProfileState.instance.optionSmoothSteering, steeringValue, 0.8);
					}else {
						steeringValue = NumberUtils.interpolate2(0, -1, 0, Global.defaultFramerate * ProfileState.instance.optionSmoothSteering, Math.abs(steeringValue), 0.8);
					}
					
					//trace("Steering:", steeringValue);
					
					applyRudderSteering(steeringValue * flatTorque, delta);
				}
			}
			
			_player.dragTorque(1-(0.1*NumberUtils.interpolate(delta,1,0.4)));
			
		}
		
		public function tickMouseControl(delta:Number):void 
		{
			if (_player == null) {
				destroy();
				return;
			}
			
			_player.dragTorque(1-(0.1*NumberUtils.interpolate(delta,1,0.4)));
			
			//Mouse control
			if (ProfileState.instance.optionMouseControl >= 1) {
				
				var mouseAngle:Number = updateMouseAngle();
				
				//Apply steering
				applyRudderSteering(GameMediator.mouseControlValue * flatTorque, delta);
				
			}else {
				_mouseControlIndicator.alpha = 0;
			}
			
			_player.dragTorque(1-(0.1*NumberUtils.interpolate(delta,1,0.4)));
			//trace("Ang velocity =", _player.getBody().angularVel);
		}
		
		/** Returns the mouse angle from player and moves the indicator */
		public function updateMouseAngle(delta:Number = 1):Number {
			if (_player == null) return 0;
			
			if (ProfileState.instance.optionMouseControl >= 1) {
				//Get angle
				if (_player.getMovieClip()) {
					var p:MovieClip = _player.getMovieClip();
					
					var mouseX:Number = p.mouseX;
					var mouseY:Number = p.mouseY;
					
					var mouseAngle:Number = Trig.angleFromDisplacement(mouseX, mouseY, true);
					
					_mouseControlIndicator.rotation = mouseAngle;
					
					var distance:Number = Math.sqrt(((p.mouseX * p.mouseX) + (p.mouseY * p.mouseY)));
					_mouseControlIndicator.scaleX = distance * 0.01;
				}
				
				//Indicator
				if (ProfileState.instance.optionMouseControl == 1) {
					_mouseControlIndicator.alpha = NumberUtils.interpolate2(0, 1, 0, 70, Math.abs(mouseAngle + 90) , 0.8);
					_mouseControlIndicator.visible = true;
				}else {
					_mouseControlIndicator.alpha = 0;
				}
				
				
				//Calculate steering amount
				var mouseSteering:Number;
				var steeringAngle:Number = mouseAngle + 90;
				if (steeringAngle >= 180 && steeringAngle <= 270) {
					steeringAngle = NumberUtils.interpolate2( -90, -180, 270, 180, steeringAngle);
				}
				if (steeringAngle >= 0) {
					mouseSteering = NumberUtils.interpolate2(0, 1, 0, 90, steeringAngle, 2.2, true);
				}else {
					mouseSteering = NumberUtils.interpolate2(0, -1, 0, -90, steeringAngle, 2.2, true);
				}
				
				//trace("mouseSteering:", mouseSteering);
				GameMediator.changeMouseControlValue(mouseSteering);//Put in mediator for items to know what mouse control value is (used by at least spin boosters)
				
				return mouseAngle;
			}else {
				_mouseControlIndicator.alpha = 0;
				_mouseControlIndicator.visible = false;
				return 0;
			}
		}
		
		/** Takes an item torque value and delta, then applies steering accordingly */
		public function applyRudderSteering(torque:Number, delta:Number):void {
			_player.applyRotation(torque * delta * StatHooks.rudderMult.value * ProfileState.instance.optionSteeringPower);
		}
		
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function destroy():void 
		{
			Main.guiTickSignal.remove(updateMouseAngle);
			if (_item) _item.destroy();
			_item = null;
			_player = null;
			
			if (_mouseControlIndicator) DisplayObjectUtil.removeAllChildFrom(_mouseControlIndicator, true);
			_mouseControlIndicator = null;
			
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		
		
		
	}

}