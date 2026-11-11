package lbg.mousewheeltrap 
{
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	/**
	 * MouseWheelTrap - stops simultaneous browser/Flash mousewheel scrolling
	 * @author Liam O'Donnell
	 * @version 1.0
	 * @usage Simply call the static method MouseWheelTrap.setup(stage);
	 * @see http://www.spikything.com/blog/?s=mousewheeltrap for info/updates
	 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
	 * © 2009 spikything.com
	 *
	 * Permission is hereby granted, free of charge, to any person
	 * obtaining a copy of this software and associated documentation
	 * files (the "Software"), to deal in the Software without
	 * restriction, including without limitation the rights to use,
	 * copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the
	 * Software is furnished to do so, subject to the following
	 * conditions:
	 *
	 * The above copyright notice and this permission notice shall be
	 * included in all copies or substantial portions of the Software.
	 *
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	 * OTHER DEALINGS IN THE SOFTWARE.
	 */
	public class MouseWheelTrap
	{
		static private const JAVASCRIPT :String = "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;}}if(window.addEventListener){window.addEventListener('DOMMouseScroll',wheel,false);}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);";
		static private const JS_METHOD :String = "allowBrowserScroll";
		static private var _browserScrollEnabled :Boolean = true;
		static private var _mouseWheelTrapped :Boolean = false;
		private const INSTANTIATION_ERROR :String = "Don't instantiate com.spikything.utils.MouseWheelTrap directly. Just call MouseWheelTrap.setup(stage);";
		
		public function MouseWheelTrap()
		{
			throw new IllegalOperationError(INSTANTIATION_ERROR);
		}
		
		/// Sets up the Flash and the browser to deal with turning browser scrolling on/off as the mouse cursor enters and leaves the stage (a valid reference to stage is required)
		static public function setup(stage:Stage):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:* = null):void { allowBrowserScroll(false); } );
			stage.addEventListener(Event.MOUSE_LEAVE, function(e:* = null):void { allowBrowserScroll(true); } );
		}
		
		static private function allowBrowserScroll(allow:Boolean):void
		{
			createMouseWheelTrap();
			
			if (allow == _browserScrollEnabled)
				return;
			_browserScrollEnabled = allow;
			
			if (ExternalInterface.available) {
				try{
					ExternalInterface.call(JS_METHOD, _browserScrollEnabled);
				}catch (e:Error) {
					//Nothing
				}
				return;
			}
		}
		
		static private function createMouseWheelTrap():void
		{
			if (_mouseWheelTrapped) 
				return;
			_mouseWheelTrapped = true;
			
			if (ExternalInterface.available) {
				try{
					ExternalInterface.call("eval", JAVASCRIPT);
				}catch (e:Error) {
					//Nothing
				}
				return;
			}
		}
		
	}
	
}