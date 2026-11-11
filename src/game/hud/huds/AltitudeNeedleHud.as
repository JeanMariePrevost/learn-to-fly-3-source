package src.game.hud.huds 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class AltitudeNeedleHud extends HudComponent 
	{
		protected const INTERVAL_SIZE:Number = 1000;
		
		public var scroll:MovieClip;
		
		protected var _jumpDistance:Number;
		protected var _textFields:Vector.<TextField>;
		protected var _values:Vector.<Number>;
		
		public function AltitudeNeedleHud() 
		{
			super();
			
			initTextFields();
		}
		
		override public function init():void 
		{
			super.init();
			GameMediator.updatePlayerAltitude.add(onAltitudeChange);
		}
		
		protected function initTextFields():void {
			_textFields = new Vector.<TextField>();
			
			_textFields.push(scroll.txt1);
			_textFields.push(scroll.txt2);
			_textFields.push(scroll.txt3);
			_textFields.push(scroll.txt4);
			_textFields.push(scroll.txt5);
			
			_values = new Vector.<Number>();
			
			_values.push(0);
			_values.push(0);
			_values.push(0);
			_values.push(0);
			_values.push(0);
			
			_jumpDistance = Math.abs(_textFields[1].y - _textFields[0].y);
			
			updateTextFields(0);
		}
		
		protected function onAltitudeChange(alt:Number):void {
			updateTextFields(alt);
		}
		
		protected function updateTextFields(alt:Number):void {
			setTextFieldValue(0, alt +  2 * INTERVAL_SIZE);
			setTextFieldValue(1, alt +  1 * INTERVAL_SIZE);
			setTextFieldValue(2, alt);
			setTextFieldValue(3, alt -  1 * INTERVAL_SIZE);
			setTextFieldValue(4, alt -  2 * INTERVAL_SIZE);
			
			scroll.y = 0 + (_jumpDistance * ((alt - _values[2]) / INTERVAL_SIZE));
		}
		
		protected function setTextFieldValue(index:uint, alt:Number):void {
			var thousands:Number = Math.floor(alt / 1000);
			_values[index] = thousands * 1000;
			if (thousands > 0) {
				_textFields[index].text = thousands.toFixed() + "k";
			}else if (thousands < 0) {
				_textFields[index].text = "";
			}else {
				_textFields[index].text = "0";
			}
		}
		
		protected function compareTextFieldsY(itemA:TextField, itemB:TextField):Number {
			if (itemA.y < itemB.y) return -1; //ITEM A is before ITEM B
			else if (itemA.y > itemB.y) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same y
		}		
	}

}