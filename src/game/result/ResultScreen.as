package src.game.result 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.UiScaler;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultScreen extends Sprite 
	{
		protected const NODE_SPACING:Number = 55;
		protected const ANIM_DURATION:uint = 80;
		protected const START_Y:Number = 760;
		protected const SHOW_DELAY:uint = 75;
		
		
		//public var title:ResultTitle;
		
		public var bg:ResultBg;
		public var top:ResultTop;
		public var bottom:ResultBottom;
		
		public var nodes:Vector.<Node> = new Vector.<Node>();
		
		protected var _time:Number = 0;
		protected var _delay:Number = 0;
		
		protected var _nextNodeDelay:Number = 80;//Delay for first node, and increases as nodes are added
		protected var _nodeDelayStep:Number = 20;
		
		public function ResultScreen() 
		{
			super();
			
			
			top = new ResultTop();
			top.x = 360;
			//top.y = 100;
			top.txtLabel.text = "Results for day " + ProfileState.instance.currentGameState.day.value;
			addChild(top);
			
			bg = new ResultBg();
			bg.x = 360;
			bg.y = top.getRect(this).bottom;
			addChild(bg);
			bg.setHeight(50);
			
			bottom = new ResultBottom();
			bottom.x = 360;
			bottom.y = bg.getBottom();
			updateTotalTxt();
			addChild(bottom);
			
			y = START_Y;
			Main.unsafeTickSignal.add(tick);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		private function tick(delta:Number):void 
		{
			if (_delay < SHOW_DELAY) {
				_delay++;
			}else{
				//y = Easing.easeOutBack(_time, START_Y, -(START_Y - getCenterY()), ANIM_DURATION, 1);
				//y = Easing.easeOutElastic(_time, START_Y, -(START_Y - getCenterY()), ANIM_DURATION, 0,150);
				y = Easing.easeOutElastic(_time, START_Y, -(START_Y - getCenterY()), ANIM_DURATION, 0,100);
				_time ++;
				
				if (_time >= ANIM_DURATION) {
					Main.unsafeTickSignal.remove(tick);
				}
			}
		}
		
		public function forceShowUp():void {
			
			for each(var n:Node in nodes) {
				n.finishProgressBarNow();	
			}
			_delay = SHOW_DELAY;
			_time = ANIM_DURATION;
			tick(1);
		}
		
		public function get animationCompleted():Boolean {
			return _time >= ANIM_DURATION;
		}
		
		public function getTotalCash():Number {
			var totalCash:Number = 0;
			for each(var node:Node in nodes) {
				totalCash += node._cash;
			}
			return totalCash;
		}
		
		public function addNode(label:String, value:int, progressNorm:Number, hue:Number):Node {
			var node:Node = new Node();
			node.y = nodes.length * NODE_SPACING;
			//trace(node.y);
			nodes.push(node);
			node.label = label;
			node.cash = value;
			if (isNaN(progressNorm))progressNorm = 0;
			node.runProgressBar(_nextNodeDelay, progressNorm, hue);
			_nextNodeDelay += _nodeDelayStep;
			bg.addChild(node);
			setHeight(node.y + NODE_SPACING);
			updateTotalTxt();
			
			return node;
		}
		
		protected function updateTotalTxt():void {
			var cashLabel:String = "$ " + NumberUtils.numberDelimiter(getTotalCash());
			bottom.txtLabel.text = cashLabel;
		}
		
		public function setHeight(height:Number):void {
			bg.setHeight(height);
			bottom.y = bg.getBottom();
			
		}
		
		public function getCenterY():Number {
			//Centering
			var height:Number = bg.getHeight();
			return (270 - (height / 2));
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			bg.destroy();
			bg = null;
			top.destroy();
			top = null;
			bottom.destroy();
			bottom = null;
			
			var i:Node;
			for each (i in nodes) {
				i.destroy();
			}
			
			nodes = null;
		}
		
	}

}