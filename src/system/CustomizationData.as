package src.system 
{
	import flash.net.registerClassAlias;
	/**
	 * Holds the saved data from player customization options
	 * @author 
	 */
	public class CustomizationData 
	{
		
		public var hat:int = 1;
		public var face:int = 1;
		public var suit:int = 1;
		public var body:int = 1;
		
		public var penguinHue:Number = 0.5;
		public var penguinBrightness:Number = 0.5;
		public var penguinSaturation:Number = 0.5;
		public var penguinContrast:Number = 0.5;
		
		public var shipHue:Number = 0.5;
		public var shipBrightness:Number = 0.5;
		public var shipSaturation:Number = 0.5;
		public var shipContrast:Number = 0.5;
		
		public var ownedHats:Vector.<Number> = new Vector.<Number>();
		public var ownedFaces:Vector.<Number> = new Vector.<Number>();
		public var ownedSuits:Vector.<Number> = new Vector.<Number>();
		public var ownedBodies:Vector.<Number> = new Vector.<Number>();
		
		public function CustomizationData() 
		{
			registerClassAlias("CustomizationData", CustomizationData);
			registerClassAlias("Vector", Vector);
			
			
		}
		
		public function playerOwnsHat(index:Number):Boolean {
			if (index <= 1) return true;//Always own basic skin
			return (ownedHats.indexOf(index) >= 0);
		}
		
		public function playerOwnsFace(index:Number):Boolean {
			if (index <= 1) return true;//Always own basic skin
			return (ownedFaces.indexOf(index) >= 0);
		}
		
		public function playerOwnsSuit(index:Number):Boolean {
			if (index <= 1) return true;//Always own basic skin
			return (ownedSuits.indexOf(index) >= 0);
		}
		
		public function playerOwnsBody(index:Number):Boolean {
			if (index <= 1) return true;//Always own basic skin
			return (ownedBodies.indexOf(index) >= 0);
		}
		
		
		/** True if added, false if already owned */
		public function addOwnedHat(index:Number):Boolean {
			if (playerOwnsHat(index) == false) {
				ownedHats.push(index);
				return true;
			}else {
				return false;
			}
		}
		
		/** True if added, false if already owned */
		public function addOwnedFace(index:Number):Boolean {
			if (playerOwnsFace(index) == false) {
				ownedFaces.push(index);
				return true;
			}else {
				return false;
			}
		}
		
		/** True if added, false if already owned */
		public function addOwnedSuit(index:Number):Boolean {
			if (playerOwnsSuit(index) == false) {
				ownedSuits.push(index);
				return true;
			}else {
				return false;
			}
		}
		
		/** True if added, false if already owned */
		public function addOwnedBody(index:Number):Boolean {
			if (playerOwnsBody(index) == false) {
				ownedBodies.push(index);
				return true;
			}else {
				return false;
			}
		}
		
		public function destroy():void {
			if (ownedHats) ownedHats.length = 0;
			ownedHats = null;
			if (ownedFaces) ownedFaces.length = 0;
			ownedFaces = null;
			if (ownedSuits) ownedSuits.length = 0;
			ownedSuits = null;
			if (ownedBodies) ownedBodies.length = 0;
			ownedBodies = null;
		}
		
		
		
	}

}