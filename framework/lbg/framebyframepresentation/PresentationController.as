package lbg.framebyframepresentation
{
	import controlmanager.AbstractControlManager;
	import controlmanager.ControlManagerCommand;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author LightBringer
	 */
	public class PresentationController extends AbstractControlManager 
	{
		public var previous:ControlManagerCommand;
		public var next:ControlManagerCommand;
		
		public function PresentationController(receiver:DisplayObjectContainer, detectMouseButton:Boolean=true, detectMouseWheel:Boolean=true, detectMouseMove:Boolean=false) 
		{
			super(receiver, detectMouseButton, detectMouseWheel, detectMouseMove);
			previous = new ControlManagerCommand(this);
			previous.addKeyMapping(37);
			previous.addKeyMapping(65);
			previous.addKeyMapping(188);
			previous.addMouseWheelUpMapping();
			
			next = new ControlManagerCommand(this);
			next.addKeyMapping(39);
			next.addKeyMapping(68);
			next.addKeyMapping(190);
			next.addMouseDownMapping();
			next.addMouseWheelDownMapping();
			
		}
		
	}

}