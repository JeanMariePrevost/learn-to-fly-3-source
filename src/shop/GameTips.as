package src.shop 
{
	/**
	 * ...
	 * @author 
	 */
	public class GameTips 
	{
		protected static var _tips:Vector.<String>;
		
		public static function getRandomTip():String {
			if (_tips == null) populateTips();
			var i:int = int(Math.random() * _tips.length - 0.01);
			
			return _tips[i];
		}
		
		public static function get tips():Vector.<String> {
			if (_tips == null) populateTips();
			return _tips;
		}
		
		protected static function populateTips():void {
			_tips = new Vector.<String>();
			
			addTip("Some stages can be stopped by holding (down)");
			addTip("Going very fast is often inefficient because of the air friction");
			addTip("Heavier bodies are hard to get off the ground, but they just ram through obstacles");
			addTip("Upgrading is generally less efficient than buying more stages and boosts");
			addTip("Stages are more cost-effective than boosts");
			addTip("Bodies with low top speed benefit less from powerful launchers");
			addTip("Propellers are very efficient but much slower than other options");
			addTip("You get lighter as stages and boosts are depleted, use this to your advantage");
			addTip("Use stronger stages first if you are heavy");
			addTip("Max lift tells you at what point an item starts losing efficiency from your total weight");
			addTip("Avoid going too far beyond max speed to reduce drag");
			addTip("Being lighter than an item's max lift gives you a slight boost in efficiency");
			addTip("You can drag stages and boosts around to reorganize them in the shop");
			addTip("Hold CTRL while clicking an item to sell it directly");
			addTip("Hold SHIFT while upgrading or downgrading will do it to the maximum");
			addTip("Hold shift while dragging a stage or boost to copy the item if you have enough cash");
			addTip("Wait until your speed drops below redzone before using boosts");
			addTip("Visit the Bonus Shop to buy permanent upgrades");
			addTip("Bonus Shop upgrades carry across different games on the same profile");
			addTip("Selling an item gives you all of its value back! Experiment!");
			addTip("Being heavier really helps in Payload Mode. Go figure.");
			addTip("Weight-reducing items do not reduce the weight of Payloads.");
			addTip("Max speed has to be maintained roughly 1 second to count, short spikes don't work!");
			addTip("Touching the ground too much will cause the day to end, so stay away!");
			addTip("Controls go too fast? Go to the advanced options to tweak the speed!");
			addTip("Game acts weird because of lag? Try disabling delta time in the advanced options.");
			addTip("Running out of fuel or falling down will end the day.");
			addTip("Some medals grant you permanent bonuses.");
			addTip("There's a code for the mobile app in LtF3, and a code for LtF3 in the mobile app!");
			addTip("You get bonus points and new items every time you complete a game in Story, Classic or Payload.");
			addTip("Use the following code in the iOS/Android Learn 2 fly app: ILoveSuperPingu");
			addTip("You can sometimes find baby penguins on this shop screen for secret stuff...");
			//addTip("");
			//addTip("");
			//addTip("");
			//addTip("");
			//addTip("");
		}
		
		protected static function addTip(tip:String):void {
			_tips.push(tip);
		}
		
		
	}

}