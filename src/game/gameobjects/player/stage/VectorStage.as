package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class VectorStage extends SimpleStage 
	{
		public var inner:MovieClip;
		public var fire:MovieClip;
		public var fireTarget:MovieClip;
		
		protected const _gimbalDegrees:Number = -30;
		
		protected var _baseFireScaleX:Number;
		protected var _baseFireScaleY:Number;
		protected var _fireDistance:Number;
		protected var _smokeCounter:Number = 0;
		
		public function VectorStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
			
			inner = _visual.mc.inner;
			fire = _visual.mc.fire;
			fireTarget = _visual.mc.inner.fireTarget;
			
			_baseFireScaleX = fire.scaleX;
			_baseFireScaleY = fire.scaleY;
			_fireDistance = fire.y;
			
			fire.visible = false;
			
			
			_visual.x = _player.tBottom.x;
			_visual.y = _player.tBottom.y;
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			//Detect direction
			var direction:Number = 0;//<0 left, >0 right
			
			if (ProfileState.instance.optionMouseControl >= 1) {
				//Mouse-controlled
				direction = GameMediator.mouseControlValue;
			}else {
				//Regular controls
				if (Input.metaLeft.isDown) {
					direction = -1;
				}else if (Input.metaRight.isDown) {
					direction = 1;
				}
			}
			
			//Move inner portion
			var gimbalTarget:Number = _gimbalDegrees * direction;
			
			if (direction != 0) {
				inner.rotation = NumberUtils.interpolate(inner.rotation, gimbalTarget, 0.05);
			}else {
				//Faster return
				inner.rotation = NumberUtils.interpolate(inner.rotation, gimbalTarget, 0.08);
			}
			fire.rotation = inner.rotation;
			var firePos:Point = DisplayObjectUtil.localToLocal2(fireTarget, fireTarget.parent, fire.parent);
			fire.x = firePos.x;
			fire.y = firePos.y;
			
			
			//Rest of stage action
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				//Torque
				if (direction >= 0.05 || direction <= -0.05) {
					_player.rudder.applyRudderSteering(direction * _item.statTorque, delta);
				}
				
				
				fire.visible = true;
				fire.scaleX = _baseFireScaleX + NumberUtils.randomRange(-0.07, 0.07);
				fire.scaleY = _baseFireScaleY + NumberUtils.randomRange(-0.12, 0.65);
				if (_smokeCounter <= 0) {
					_smokeCounter = 2;
					var p:AbstractParticle = Particles.builder.smokeWhiteQuick(firePos.x, firePos.y - 50, 0.95, 1.4, 18 + Math.random() * 6, DisplayObjectUtil.globalRotationOf(fire) + 90 + NumberUtils.randomBoth(6), _visual);
					p.vScale = 0.07;
					p.particleLife = 20;
				}else {
					_smokeCounter -= 1;
				}
			}else {
				fire.visible = false;
			}
		}
		
	}

}