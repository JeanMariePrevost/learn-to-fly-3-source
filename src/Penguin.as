package src 
{
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import src.system.ProfileState;
	
	/**
	 * This is the movieclip that is used to customize the penguin and have it appear inside bodies which can display it
	 * @author 
	 */
	public class Penguin extends MovieClip 
	{
		public var hats:MovieClip;
		public var hatsBehind:MovieClip;
		public var faces:MovieClip;
		public var facesBehind:MovieClip;
		public var suits:MovieClip;
		public var suitsBehind:MovieClip;
		
		
		public function Penguin() 
		{
			//trace("Loading penguin customizations...");
			try {
				gotoAndStop(ProfileState.instance.customizationData.body);
			}catch (e:Error) {
				Log.log("Penguin constructor error - Invalid custom body"); 
				gotoAndStop(1);
			}
			
			try {
				hats.gotoAndStop(ProfileState.instance.customizationData.hat);
				hatsBehind.gotoAndStop(ProfileState.instance.customizationData.hat);
			}catch (e:Error) {
				Log.log("Penguin constructor error - Invalid custom hat"); 
				hats.gotoAndStop(1);
				hatsBehind.gotoAndStop(1);
			}
			
			try {
				faces.gotoAndStop(ProfileState.instance.customizationData.face);
				facesBehind.gotoAndStop(ProfileState.instance.customizationData.face);
			}catch (e:Error) {
				Log.log("Penguin constructor error - Invalid custom face"); 
				faces.gotoAndStop(1);
				facesBehind.gotoAndStop(1);
			}
			
			try {
				suits.gotoAndStop(ProfileState.instance.customizationData.suit);
				suitsBehind.gotoAndStop(ProfileState.instance.customizationData.suit);
			}catch (e:Error) {
				Log.log("Penguin constructor error - Invalid custom suit"); 
				suits.gotoAndStop(1);
				suitsBehind.gotoAndStop(1);
			}
			
			var hue:Number = -180 + (360 * ProfileState.instance.customizationData.penguinHue);
			var brightness:Number = -100 + (200 * ProfileState.instance.customizationData.penguinBrightness);
			var saturation:Number = -100 + (200 * ProfileState.instance.customizationData.penguinSaturation);
			var contrast:Number = -100 + (200 * ProfileState.instance.customizationData.penguinContrast);
			
			var shipHue:Number = -180 + (360 * ProfileState.instance.customizationData.shipHue);
			var shipBrightness:Number = -100 + (200 * ProfileState.instance.customizationData.shipBrightness);
			var shipSaturation:Number = -100 + (200 * ProfileState.instance.customizationData.shipSaturation);
			var shipContrast:Number = -100 + (200 * ProfileState.instance.customizationData.shipContrast);
			
			hue -= shipHue;
			brightness -= shipBrightness;
			//saturation -= shipSaturation;
			//contrast -= shipContrast;
			
			if (hue > 180) hue -= 360;
			if (hue < -180) hue += 360;
			//if (brightness > 100) brightness -= 100;
			//if (brightness < -100) brightness += 100;
			//if (saturation > 100) saturation -= 100;
			//if (saturation < -100) saturation += 100;
			//if (contrast > 100) contrast -= 100;
			//if (contrast < -100) contrast += 100;
			
			if (hue != 0 || brightness != 0 || saturation != 0 || contrast != 0) {
				//trace("Adding color matrix to penguin");
				DisplayObjectUtil.setColorMatrix(this, hue, saturation, brightness, contrast);
			}else {
				//trace("Penguin has no color changes.");
			}
			
			
		}
		
		public function destroy():void {
			hats = null;
			hatsBehind = null;
			faces = null;
			facesBehind = null;
			suits = null;
			suitsBehind = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
		
	}

}