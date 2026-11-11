package src.game 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import src.ScreenManager;
	import src.audio.Audio;
	import src.game.classicmode.Slope;
	import src.game.gameobjects.GameObject;
	import src.gui.Cutscene;
	import src.gui.Transition;
	import src.Main;
	import src.MedalCheck;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameEngineClassic extends GameEngine 
	{
		protected static var _instance:GameEngineClassic;
		protected var _slope:GameObject;
		
		static public function get instance():GameEngineClassic 
		{
			//if (_instance == null) _instance = new GameEngine();
			return _instance;
		}
		
		static public function initInstance():GameEngineClassic 
		{
			if (_instance == null) {
				_instance = new GameEngineClassic();
				return _instance;
			}else {
				throw new Error("GameEngine.initInstance() Instance already exists");
				return _instance;
			}
		}
		
		static public function destroy():void 
		{
			if (_instance) _instance.destroy();
		}
		
		public function GameEngineClassic() 
		{
			super();
		}
		
		override protected function setupGameEngine():void 
		{
			super.setupGameEngine();
			
			_windEngine.destroy();
			removeSubscriber(_windEngine);
			_windEngine = new WindEngineNull();
			addSubscriber(_windEngine);
			
			removeSubscriber(_obstacleController);
			_obstacleController.destroy();
			_obstacleController = null;
			
			_spaceIndicator.destroy();
			_spaceIndicator = null;
			
			if (_launcher.item.statBoostSlots == 2) {
				trace("Classic mode -> Launcher uses slope");
				_slope = new Slope();
				_camera.addChildToMovingLayer(_slope.getMovieClip(), 1);
				_slope.setPosition(0, ground.groundLevel - 175);
				
				_launcher.x = _slope.getPositionX() + 426;
				_launcher.y = _slope.getPositionY() -4;
				_launcher.rotation = 45;
			}
			
			if (ProfileState.instance.currentGameState.gameCompleted.value == false) {
				GameMediator.updatePlayerPosition.add(onPosition);
			}
			
		}
		
		protected function onPosition(X:Number, Y:Number):void {
			//trace(Math.abs(X), (Math.abs(X) >= Global.classicModeGoal)); 
			if (Math.abs(X) >= Global.classicModeGoal) {
				Log.log("GameEngineClassic -> Winning conditions met")
				GameMediator.updatePlayerPosition.remove(onPosition);
				Main.gameEngineTickSignal.remove(tick);
				Audio.fadeAllAudio();
				Transition.transitionTo(ScreenManager.unloadGame, Audio.destroyAllAudio, Cutscene.playSuperman);
			}
		}
		
		override public function destroy():void 
		{
			_instance = null;
			
			if (_slope) _slope.destroy();
			_slope = null;
		
			super.destroy();
		}
		
		
	}

}