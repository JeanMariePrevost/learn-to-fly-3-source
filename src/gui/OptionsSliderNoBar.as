package src.gui 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class OptionsSliderNoBar extends OptionsSlider 
	{
		
		public var txtBar:TextField;
		
		public function OptionsSliderNoBar() 
		{
			super();
			
			txtBar.text = "";
			txtBar.mouseEnabled = false;
			
		}
		
	}

}