/*
 * Clouds is a facade and a manager of CloudsNode
 * It hold the maaximum cloud zone, gets event from the wind and ticks CloudsNode
 * It also adjusts the behavior of clouds according to altitude
 */

package src.game.gameobjects.environment 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.compositetick.ICompositeLeaf;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.GameCamera;
	import src.game.GameMediator;
	import src.system.Global;
	/**
	 * ...
	 * @author 
	 */
	public class Clouds extends Sprite implements ICompositeLeaf
	{
		protected const CLOUDS_STOP_START_ALT:Number = 0.6;//Altitude where clouds starts disappearing
		protected const CLOUDS_STOP_END_ALT:Number = 0.9;
		protected var _minCloudsNodeScale:Number = 0.6;
		protected var _maxCloudsNodeScale:Number = 3.2;
		protected var _cloudCount:int = 20;
		protected var _spawnZoneBuffer:Number = 500;//How much bigger is the spawnZone compared to the viewZone
		protected var _viewDiagonal:Number;//Length from center of stage to corner
		protected var _spawnDiagonal:Number;
		protected var _centerPoint:Point = new Point();
		protected var _clouds:Vector.<CloudsNode> = new Vector.<CloudsNode>();
		protected var _unsortedClouds:Vector.<CloudsNode> = new Vector.<CloudsNode>();//Workaround for making clouds in space invisible
		protected var _previousAltitude:Number = 0;
		
		public function Clouds() 
		{
			//addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function init():void {
			updateZones();
			for (var i:int = 1; i <= _cloudCount; i++) {
				addCloud();
			}
			nodeReseted(null);
			
			GameMediator.updatePlayerAltitude.add(altitudeChange);
		}
		
		protected function addCloud():void {
			var cloud:CloudsNode = new CloudsNode(_viewDiagonal, _spawnDiagonal, _centerPoint, _minCloudsNodeScale, _maxCloudsNodeScale);
			addChild(cloud);
			_clouds.push(cloud);
			_unsortedClouds.push(cloud);
			cloud.signalReset.add(nodeReseted);
		}
		
		protected function altitudeChange(alt:Number):void {
			//Remove clouds past certain altitudes
			if (_unsortedClouds.length >= 1) {
				var hiddenCouds:int = int(NumberUtils.interpolate2(0, 20, Global.spaceAltitude * CLOUDS_STOP_START_ALT, Global.spaceAltitude * CLOUDS_STOP_END_ALT, alt, 1, true));
				var previousHiddenCouds:int = int(NumberUtils.interpolate2(0, 20, Global.spaceAltitude * CLOUDS_STOP_START_ALT, Global.spaceAltitude * CLOUDS_STOP_END_ALT, _previousAltitude, 1, true));
				
				if (hiddenCouds != previousHiddenCouds) {
					for (var i:int = 0 ; i < _cloudCount; i++) {
						_unsortedClouds[i].hideAfterReset = (i < hiddenCouds);
					}
					//trace("Hidden clouds:", hiddenCouds);
				}
				
				_previousAltitude = alt;
			}
		}
		
		public function tick(delta:Number):void 
		{
			if (stage == null) return;
			updateZones();
			for each(var cloud:CloudsNode in _clouds) {
				cloud.tick(delta, _viewDiagonal, _spawnDiagonal, _centerPoint);
			}
		}
		
		protected function nodeReseted(node:CloudsNode):void {
			//Sort clouds by scaleY so that smaller ones are in the back
			_clouds.sort(compareCloudsDepth);
			
			for (var i:int = 0; i < _clouds.length; i++) {
				setChildIndex(_clouds[i], i);
			}
		}
		
		protected function compareCloudsDepth(itemA:CloudsNode, itemB:CloudsNode):Number {
			//if (itemA.scaleY < itemB.scaleY) return -1; //ITEM A is before ITEM B
			//else if (itemA.scaleY > itemB.scaleY) return 1; //ITEM A is after ITEM B
			
			if (itemA.tintAmount > itemB.tintAmount) return -1; //ITEM A is before ITEM B
			else if (itemA.tintAmount < itemB.tintAmount) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same date
		}	
		
		protected function updateZones():void {
			_viewDiagonal = 450 / GameCamera.instance.getMovingLayer(0).scaleX;
			_spawnDiagonal = _viewDiagonal + _spawnZoneBuffer;
			_centerPoint.x = stage.stageWidth / 2;
			_centerPoint.y = stage.stageHeight / 2;
			_centerPoint = globalToLocal(_centerPoint);
		}
		
		public function destroy():void {
			_centerPoint = null;
			
			for each(var c:CloudsNode in _clouds) {
				c.destroy();
			}
			_clouds = null;
			
			if (stage) parent.removeChild(this);
		}
		
		
		
	}

}