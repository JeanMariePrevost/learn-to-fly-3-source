package lbg.inputmanager.inputcommands 
{
	import lbg.inputmanager.InputManager;
	/**
	 * ...
	 * @author 
	 */
	public class BasicCommands 
	{
		protected var _mouseButton:ICommandState;
		protected var _mouseWheelUp:ICommandState;
		protected var _mouseWheelDown:ICommandState;
		protected var _spaceBar:ICommandState;
		protected var _enter:ICommandState;
		protected var _esc:ICommandState;
		protected var _ctrl:ICommandState;
		protected var _shift:ICommandState;
		protected var _alt:ICommandState;
		protected var _arrowUp:ICommandState;
		protected var _arrowDown:ICommandState;
		protected var _arrowLeft:ICommandState;
		protected var _arrowRight:ICommandState;
		protected var _w:ICommandState;
		protected var _a:ICommandState;
		protected var _s:ICommandState;
		protected var _d:ICommandState;
		protected var _z:ICommandState;
		
		//Meta stands for arrow keys, wasd and zqsd up/down/left/right
		protected var _metaUp:ICommandState;
		protected var _metaDown:ICommandState;
		protected var _metaLeft:ICommandState;
		protected var _metaRight:ICommandState;
		
		//Any key commands, w/ w/o mouse
		protected var _anyKey:ICommandState;
		protected var _anyKeyOrMouse:ICommandState;
		
		public function BasicCommands(inputManager:InputManager) 
		{
			_mouseButton = inputManager.createCommand(null, true);
			_mouseWheelUp = inputManager.createCommand(null, false, true);
			_mouseWheelDown = inputManager.createCommand(null, false, false, true);
			_spaceBar = inputManager.createCommand([32]);
			_enter = inputManager.createCommand([13]);
			_esc = inputManager.createCommand([17]);
			_ctrl = inputManager.createCommand([17, 223]);
			_shift = inputManager.createCommand([16]);
			_alt = inputManager.createCommand([18]);
			_arrowUp = inputManager.createCommand([38]);
			_arrowDown = inputManager.createCommand([40]);
			_arrowLeft = inputManager.createCommand([37]);
			_arrowRight = inputManager.createCommand([39]);
			_w = inputManager.createCommand([87]);
			_a = inputManager.createCommand([65]);
			_s = inputManager.createCommand([83]);
			_d = inputManager.createCommand([68]);
			_z = inputManager.createCommand([90]);
			_metaUp = inputManager.createCommand([38, 87, 90]);
			_metaDown = inputManager.createCommand([40, 83]);
			_metaLeft = inputManager.createCommand([37, 65, 81]);
			_metaRight = inputManager.createCommand([39, 68]);
			
			_anyKey = inputManager.createAnyKeyCommand();
			_anyKeyOrMouse = inputManager.createAnyKeyCommand(true);
		}
		
		public function get mouseButton():ICommandState 
		{
			return _mouseButton;
		}
		
		public function get mouseWheelUp():ICommandState 
		{
			return _mouseWheelUp;
		}
		
		public function get mouseWheelDown():ICommandState 
		{
			return _mouseWheelDown;
		}
		
		public function get spaceBar():ICommandState 
		{
			return _spaceBar;
		}
		
		public function get enter():ICommandState 
		{
			return _enter;
		}
		
		public function get esc():ICommandState 
		{
			return _esc;
		}
		
		public function get ctrl():ICommandState 
		{
			return _ctrl;
		}
		
		public function get shift():ICommandState 
		{
			return _shift;
		}
		
		public function get alt():ICommandState 
		{
			return _alt;
		}
		
		public function get arrowUp():ICommandState 
		{
			return _arrowUp;
		}
		
		public function get arrowDown():ICommandState 
		{
			return _arrowDown;
		}
		
		public function get arrowLeft():ICommandState 
		{
			return _arrowLeft;
		}
		
		public function get arrowRight():ICommandState 
		{
			return _arrowRight;
		}
		
		public function get w():ICommandState 
		{
			return _w;
		}
		
		public function get a():ICommandState 
		{
			return _a;
		}
		
		public function get s():ICommandState 
		{
			return _s;
		}
		
		public function get d():ICommandState 
		{
			return _d;
		}
		
		public function get z():ICommandState 
		{
			return _z;
		}
		
		public function get metaUp():ICommandState 
		{
			return _metaUp;
		}
		
		public function get metaDown():ICommandState 
		{
			return _metaDown;
		}
		
		public function get metaLeft():ICommandState 
		{
			return _metaLeft;
		}
		
		public function get metaRight():ICommandState 
		{
			return _metaRight;
		}
		
		public function get anyKey():ICommandState 
		{
			return _anyKey;
		}
		
		public function get anyKeyOrMouse():ICommandState 
		{
			return _anyKeyOrMouse;
		}
		
	}

}