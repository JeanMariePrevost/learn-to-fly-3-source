package src.game.gameobjects 
{
	import flash.utils.Dictionary;
	import lbg.debug.Log;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import nape.shape.ShapeList;
	/**
	 * ShapesData stores the shape coordinates of every physic objects that does not use the default box as its NAPE shape
	 * @author 
	 */
	public class ShapesData 
	{
		protected static var _shapesVecList:Dictionary;
		
		public static function getShapeListOf(shapeName:String, scaleShape:Number = 1):ShapeList {
			buildShapeList();
			
			var scaledArray:Array = getCoordsListOf(shapeName, scaleShape);
			
			if (scaledArray == null || scaledArray.length <=0) {
				Log.log("ERROR - getShapeListOf cannot find shape of", shapeName);
				return createShapeListFrom2DArray([[0, -20], [20, -20], [20, 20]]);
			}
			
			return createShapeListFrom2DArray(scaledArray);
		}
		
		public static function getCoordsListOf(shapeName:String, scaleShape:Number = 1):Array {
			buildShapeList();
			
			var baseArray:Array = (_shapesVecList[shapeName] as Array).concat();
			var scaledArray:Array = new Array();
			
			var s:Number = scaleShape;
			//var s:Number = 1 + ((scaleShape - 1) * 0.5);
			for each(var i:Array in baseArray) {
				scaledArray.push([i[0] * s, i[1] * s]);
			}
			
			return scaledArray;
		}
		
		protected static function buildShapeList():void {
			if (_shapesVecList != null) {
				return;
			}
			
			_shapesVecList = new Dictionary();
			
			//Bodies
			_shapesVecList["simpleBody"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["emptyBody"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["omegaPenguin"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["bullet"] = mirrorShape([[0, -88], [27, -76], [43, -36], [43, 58]]);
			_shapesVecList["crate"] = mirrorShape([[0, -56], [26, -38], [32, -20], [41, -20], [41, 36]]);
			_shapesVecList["ejector"] = mirrorShape([[0, -70], [50, -70], [52, -5], [62, 0], [62, 54]]);
			_shapesVecList["ejector2"] = mirrorShape([[0, -87], [35, -87], [35, 38], [41, 41], [41, 62], [35, 65], [35, 75]]);
			_shapesVecList["ejector3"] = mirrorShape([[0, -94], [22, -86], [33, -46], [45, 5], [45, 42], [22, 63], [22, 76]]);
			_shapesVecList["elFuego"] = mirrorShape([[0, -132], [22, -116], [39, -74], [43, -13], [74, -7], [78, 86], [38, 104], [38, 122], [22, 131]]);
			_shapesVecList["escapePod"] = mirrorShape([[0, -105], [24, -92], [34, -56], [45, -40], [45, 45], [25, 48], [40, 77], [18, 82], [1, 83]]);
			_shapesVecList["hedgehog"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["jet"] = mirrorShape([[0, -144], [34, -70], [157, 27], [157, 92], [47, 47], [31, 77]]);
			_shapesVecList["jet2"] = mirrorShape([[0, -125], [168, 96], [107, 96], [75, 54], [42, 96], [24, 74], [2, 105]]);
			_shapesVecList["rocketKit"] = mirrorShape([[0, -42], [24, -25], [34, 13], [60, 36]]);
			_shapesVecList["rocketKit2"] = mirrorShape([[0, -80], [22, -54], [24, -28], [33, 14], [62, 39]]);
			_shapesVecList["rocketKit3"] = mirrorShape([[0, -80], [22, -54], [24, -28], [33, 14], [62, 39]]);
			_shapesVecList["rocketeer"] = mirrorShape([[0, -42], [24, -36], [38, -15], [31, 31], [14, 41], [6, 37]]);
			//_shapesVecList["shuttle"] = mirrorShape([[0, -221], [17, -200], [29, -62], [29, -126], [42, -35], [53, -5], [118, 59], [123, 98], [45, 118], [33, 118], [33, 139]]);
			_shapesVecList["shuttle"] = mirrorShape([[0, -140], [50, -117], [68, -94], [80, 12], [116, 60], [120, 87], [77, 103], [76, 116]]);
			_shapesVecList["shuttle2"] = mirrorShape([[0, -140], [50, -117], [68, -94], [80, 12], [116, 60], [120, 87], [77, 103], [76, 116]]);
			_shapesVecList["shuttle3"] = mirrorShape([[0, -140], [50, -117], [68, -94], [68, -73], [89, 2], [179, 57], [184, 88], [77, 103], [76, 116]]);
			_shapesVecList["omegaShuttle"] = mirrorShape([[0, -140], [50, -117], [68, -94], [68, -73], [89, 2], [179, 57], [184, 88], [77, 103], [76, 116]]);
			_shapesVecList["superman"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["thunderbird"] = mirrorShape([[0, -200], [23, -120], [26, -58], [128, 100], [92, 100], [45, 110], [45, 147], [68, 148], [80, 200]]);
			_shapesVecList["trashCan"] = mirrorShape([[0, -66], [27, -54], [42, -36], [42, 55]]);
			_shapesVecList["trashCan2"] = mirrorShape([[0, -66], [44, -66], [44, 56]]);
			_shapesVecList["trashCan3"] = mirrorShape([[0, -74], [46, -58], [46, 72]]);
			_shapesVecList["volcano"] = mirrorShape([[0, -120], [7, -104], [7, -56], [41, -36], [52, -7], [45, 19], [38, 32], [60, 54]]);
			_shapesVecList["volcano2"] = mirrorShape([[0, -60], [31, -50], [50, -29], [55, -9], [50, 17], [86, 12], [83, 24], [66, 27], [53, 45], [63, 57]]);
			_shapesVecList["volcano3"] = mirrorShape([[0, -69], [31, -60], [55, -37], [62, -12], [57, 12], [52, 25], [100, 62], [97, 76], [90, 74], [88, 63]]);
			
			_shapesVecList["beerKeg"] = mirrorShape([[0, -59], [45, -54], [49, 13], [45, 73], [34, 80]]);
			_shapesVecList["captainSupporter"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["glider"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["glider2"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			_shapesVecList["glider3"] = mirrorShape([[0, -44], [14, -40], [18, -35], [29, -18], [32, -1], [29, 25], [22, 31], [12, 35]]);
			
			_shapesVecList["dodo"] = mirrorShape([[0, -68], [17, -60], [36, 7], [57, 20], [50, 31]]);
			_shapesVecList["spearhead"] = mirrorShape([[29, -180], [49, -155], [49, 56], [74, 79], [74, 97], [37, 109]]);
			_shapesVecList["bigBird"] = mirrorShape([[0, -192], [75, -160], [122, -86], [113, 44], [81, 125], [45, 166], [0, 170]]);
			_shapesVecList["bigBird2"] = mirrorShape([[0, -192], [55, -175], [102, -130], [122, -59], [148, -34], [189, 57], [186, 171], [152, 107], [102, 74], [45, 162]]);

			_shapesVecList["inlineBody"] = mirrorShape([[0, -80], [44, -80], [82, -142], [108, -142], [108, -114], [75, -78], [172, -15], [172, 77], [80, 77], [80, 108], [0, 108]]);
			_shapesVecList["inlineBody2"] = mirrorShape([[0, -128], [125, -16], [125, 31], [62, 44], [125, 125], [30, 125], [0, 94]]);
			_shapesVecList["inlineBody3"] = mirrorShape([[0, -114],[94, -114],[94, -80],[155, -80],[255, 32],[142, 110],[80, 45],[30, 45],[30, 80],[0, 80]]);
			
			
			//Obstacles
			_shapesVecList["flappyBird"] = mirrorShape([[34, -50], [62, -22], [70, 49], [0, 57]]);
			//_shapesVecList["flappyBird2"] = mirrorShape([[68, -100], [124, -44], [140, 98], [0, 114]]);
			_shapesVecList["paperPlane"] = normalShape([[55, 0], [ -16, 23], [ -30, -30]]);
			_shapesVecList["kite"] = normalShape([[0, -29], [ 31, -3], [ 4, 22], [ -46, 4]]);
			_shapesVecList["seagull"] = mirrorShape([[0, -12], [11, -9], [16, 0], [10, 8], [0, 10]]);
			_shapesVecList["rcPlane"] = normalShape([[52, -154], [105, -157], [48, -44], [136, -14], [129, 23], [-3,40], [-160, 246], [-238, 227], [-103, 22], [-235, 5], [-197, -30], [-46, -40]]);
			_shapesVecList["parachute"] = mirrorShape([[0, -43], [44, -30], [73, -1], [89, 43], [15, 134], [14, 160], [0, 165]]);
			_shapesVecList["albatross"] = normalShape([[0, -16], [80, 0], [-19, 13], [-96, 9], [-97, 2], [-26, -12]]);
			_shapesVecList["hotAirBalloon"] = mirrorShape([[0, -169], [66, -140], [86, -86], [57, -22], [32, 71], [31, 129]]);
			_shapesVecList["studentDriver"] = normalShape([[-19, -67], [42, -14], [21, -2], [14, 22], [0, 35], [-21, 21], [-50, 40], [-69, 25], [-31, -13], [-34, -61]]);
			_shapesVecList["studentDriver2"] = normalShape([[-21, -104], [48, 22], [-34, 65], [-24, 0], [-60, -100], [-38, -113]]);
			_shapesVecList["studentDriver3"] = normalShape([[53, -48], [9, -31], [10, 17], [-25, -18], [-45, -20], [-78, -23], [-24, -45]]);
			_shapesVecList["drone"] = mirrorShape([[33, -67], [113, -17], [130, 33]]);
			_shapesVecList["copter"] = normalShape([[28, -140], [182, -90], [54, -24], [121, 47], [76, 116], [98, 137], [60, 157], [-69, 109], [-45, 84], [-91, -9], [-220, -8], [-220, -80], [-135, -87]]);
			_shapesVecList["rescueCopter"] = normalShape([[3, -125], [137, -96], [150, -60], [100, -24], [130, 11], [87, 59], [140, 86], [2, 94], [-8, 60], [-85, 8], [-221, 4], [-242, -72], [-213, -38], [-146, -45], [-136, -102]]);
			_shapesVecList["newsCopter"] = normalShape([[21, -141], [176, -106], [115, -40], [111, 11], [160, 54], [107, 107], [-17, 100], [-73, 19], [-232, 30], [-258, -78], [-135, -84], [-74, -130]]);
			_shapesVecList["militaryCopter"] = normalShape([[189, -169], [341, -120], [272, -48], [312, 19], [254, 59], [-225, 126], [-360, 54], [-368, -45], [-424, -108], [-270, -152], [-111, -95], [-95, -16], [31, -33], [30, -128]]);
			_shapesVecList["jetpackBaby"] = normalShape([[-6, -30], [43, -14], [38, -5], [38, 5], [43, 14], [-6, 30], [-40, 20], [-40, -20]]);
			_shapesVecList["bigHotAirBalloon"] = mirrorShape([[0, -525], [186, -490], [296, -394], [314, -260], [221, -52], [88, 114], [79, 370], [101, 400], [81, 511]]);
			_shapesVecList["bananaPlane"] = normalShape([[0, -68], [110, -79], [112, -33], [189, -20], [139, 49], [103, 96], [60, 68], [-71, 48], [-165, -36], [-181, -149], [-154, -162], [-135, -100], [-41, -43]]);
			_shapesVecList["zeppelin"] = normalShape([[57, -66], [154, -49], [222, -5], [183, 28], [106, 53], [102, 72], [82, 87], [30, 87], [-9, 73], [-34, 54], [-121, 43], [-161, 69], [-186, 75], [-200, 70], [-200, 15], [-223, -4], [-200, -20], [-200, -75], [-180, -80], [-151, -71], [-120, -48], [-18, -65]]);
			_shapesVecList["jetObstacle"] = normalShape([[7, -22], [133, 0], [25, 11], [-3, 16], [-54, 51], [-77, 52], [-68, 17], [-80, 16], [-125, 40], [-135, 35], [-117, 13], [-112, -21], [-122, -34], [-109, -44], [-98, -46], [-73, -34], [-71, -54], [-56, -54]]);
			_shapesVecList["bigPlane"] = normalShape([[40, -55], [137, -146], [142, -135], [114, -72], [165, -59], [165, -43], [189, -25], [203, 5], [191, 17], [71, 17], [14, 46], [16, 63], [37, 70], [45, 87], [36, 105], [-17, 111], [-43, 99], [-47, 85], [-60, 76], [-215, 147], [-241, 145], [-44, 14], [-165, 4], [-273, 52], [-184, -11], [-180, -24], [-224, -106], [-202, -99], [-140, -38], [-87, -72], [-104, -40]]);
			_shapesVecList["titanFall"] = mirrorShape([[43, -176], [73, -38], [81, 85], [81, 96], [44, 130], [0, 144]]);
			_shapesVecList["comet"] = normalShape([[17, -43], [18, -35], [37, -10], [33, 21], [-19, 38], [-31, 27], [-37, -5], [-44, -17], [-31, -32], [-14, -36], [-2, -45]]);
			_shapesVecList["comet2"] = normalShape([[4, -66], [20, -63], [54, -19], [57, 6], [18, 38], [-28, 42], [-54, 24], [-54, -30], [-13, -62]]);
			_shapesVecList["fastComet"] = normalShape([[59, -53], [85, 10], [67, 34], [45, 49], [4, 52], [-32, 33], [-54, 40], [-110, 2], [-80, -33], [-32, -49], [-8, -43]]);
			_shapesVecList["satelite"] = normalShape([[10, -78], [47, -68], [58, -46], [137, -44], [123, -15], [76, -13], [2, 53], [-5, 78], [-27, 94], [-42, 105], [-62, 92], [-62, 47], [-50, 29], [-66, -13], [-98, -15], [-84, -44], [-19, -44], [-10, -73]]);
			_shapesVecList["satelite2"] = normalShape([[73, -136], [85, -74], [76, -28], [147, -35], [148, 1], [-52, 73], [-83, 56], [-89, 17], [-66, -9]]);
			_shapesVecList["spaceCore"] = normalShape([[116, -113], [93, -70], [113, -7], [100, 61], [131, 89], [52, 104], [3, 125], [-70, 120], [-128, 51], [-130, -47], [-102, -85], [-92, -118]]);
			_shapesVecList["spaceWaste"] = normalShape([[3, -108], [7, -89], [35, -76], [37, -59], [56, -15], [50, 25], [27, 51], [-6, 60], [-48, 37], [-61, -5], [-44, -48], [-32, -59], [-33, -74], [-14, -89], [0, -89]]);
			_shapesVecList["spaceWaste2"] = mirrorShape([[0, -201], [16, -153], [17, 161], [23, 178], [16, 178], [20, 197]]);
			_shapesVecList["tardis"] = normalShape([[5, -109], [15, -103], [15, -92], [31, -92], [51, -82], [60, -67], [61, 73], [42, 97], [-56, 87], [-50, -73], [-42, -90], [-3, -91], [-3, -102]]);
			_shapesVecList["potatoGlados"] = normalShape([[42, -22], [45, 69], [-26, 72], [-68, -50], [-44, -93]]);
			_shapesVecList["frozenDodo"] = normalShape([[0, -121], [96, -101], [157, 10], [135, 81], [-119, 96], [-163, -9], [-101, -107]]);
			_shapesVecList["dodolith"] = normalShape([[53, -142], [54, 149], [-3, 149], [-88, 72], [-88, -194], [-26, -194]]);
			_shapesVecList["ufo"] = mirrorShape([[0, -44], [18, -39], [32, -24], [81, -10], [89, 1], [49, 20], [25, 25], [25, 36], [19, 39], [14, 35]]);
			_shapesVecList["mothership"] = mirrorShape([[0, -118], [62, -114], [96, -101], [107, -86], [274, -75], [403, -54], [450, -38], [473, -24], [473, -5], [454, 8], [341, 34], [264, 60], [103, 86], [36, 87], [26, 95], [0, 99]]);
			_shapesVecList["dodoObstacle"] = normalShape([[29, -147], [56, -105], [22, -69], [22, -37], [47, -26], [31, 7], [43, 26], [0, 49], [2, 37], [20, 19], [ -8, 27], [ -45, 18], [ -54, -13], [ -71, -12], [ -68, -26], [ -33, -31], [ -26, -12], [ -8, -23], [15, -23], [11, -67], [ -16, -92], [ -23, -131], [ -8, -148]]);
			//_shapesVecList["template"] = normalShape([[, ], [, ], [, ], [, ], [, ]]);
			
			
			//Special
			_shapesVecList["payload"] = mirrorShape([[0, 14], [58, 14], [99, 128]]);
			_shapesVecList["payloadChain"] = mirrorShape([[0, -15], [5, -15], [5, 15]]);
			_shapesVecList["classicSlope"] = normalShape([[ -1035, 0], [ -950, -87], [ -913, -165], [ -825, -227], [ -805, -270], [ -555, -377], [ -511, -355], [ -381, -377], [ -173, -346], [ -44, -214], [ -21, -168], [82, -94], [90, -65], [130, -38], [150, 0]]);
		}
		
		public static function flipHorizontal(coords:Array):void {
			for each(var i:Array in coords) {
				i[0] *= -1;
			}
		}
		
		protected static function normalShape(coords:Array):Array {
			//Nothing to do?
			return coords;
		}
		
		protected static function mirrorShape(coords:Array):Array {
			var mirroredList:Array = coords.concat();
			
			for (var i:int = coords.length - 1; i >= 0; i--) {
				if (coords[i].x < 0) {
					throw new Error("Cannot mirror a shape with points where x<=0")
				}
				if (coords[i].x == 0 && (i == 0 || i == coords.length - 1)) {
					//First or last points at 0, no need to mirror
					//Do nothing
				}else {
					mirroredList.push([-coords[i][0], coords[i][1]]);
				}
			}
			
			return mirroredList;
		}
		
		public static function createShapeListFrom2DArray(entry:Array):ShapeList {
			var vec:Vector.<Vec2> = new Vector.<Vec2>();
			
			for (var i:int = 0; i < entry.length; i++) {
				vec.push(new Vec2(entry[i][0], entry[i][1]));
			}
			
			return createShapeListFromVec2(vec);
			//return createMirroredShapeList(vec);
		}
		
		protected static function createShapeListFromVec2(list:Vector.<Vec2>):ShapeList {
			var polys:GeomPolyList = new GeomPoly(list).convexDecomposition();
			var shapeList:ShapeList = new ShapeList();
			
			for (var i:int = 0; i < polys.length; i++) {
				shapeList.push(new Polygon(polys.at(i)));
			}
			
			return shapeList;
		}
		
		//////////////////////////
		//DEPRECATED, entries are now mirrored as they are created, not as they are converted into ShapeLists
		//////////////////////
		
		//protected static function createMirroredShapeList(list:Vector.<Vec2>):ShapeList {
			//var mirroredList:Vector.<Vec2> = mirrorVec2List(list);
			//var polys:GeomPolyList = new GeomPoly(mirroredList).convexDecomposition();
			//var shapeList:ShapeList = new ShapeList();
			//
			//for (var i:int = 0; i < polys.length; i++) {
				//shapeList.push(new Polygon(polys.at(i)));
			//}
			//
			//return shapeList;
		//}
		//
		//protected static function mirrorVec2List(list:Vector.<Vec2>):Vector.<Vec2> {
			//var mirroredList:Vector.<Vec2> = list.concat();
			//
			//for (var i:int = list.length - 1; i >= 0; i--) {
				//if (list[i].x < 0) {
					//throw new Error("Cannot mirror a shape with points where x<=0")
				//}
				//if (list[i].x == 0 && (i == 0 || i == list.length - 1)) {
					////First or last points at 0, no need to mirror
					////Do nothing
				//}else {
					//mirroredList.push(new Vec2( -list[i].x, list[i].y));
				//}
			//}
			//
			//return mirroredList;
		//}
		
	}

}