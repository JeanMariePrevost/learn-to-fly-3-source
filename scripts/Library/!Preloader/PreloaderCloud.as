// Library symbol "!Preloader/PreloaderCloud"

// ---- layer "action", frame 1
import flash.events.Event;

addEventListener(Event.ENTER_FRAME, onFrame);


var speed:Number = 0;
respawn(false);

function onFrame(e:Event):void{
	//if(Math.random()<=0.05) trace("CLOUD TICKING!" + Math.random().toFixed(3));
	if(stage == null || cloud == null){
		removeEventListener(Event.ENTER_FRAME, onFrame);
		cloud = null;
		if(parent) parent.removeChild(this);
		
		return;
		
	}
	cloud.x += speed;
	if(cloud.x<=-200) respawn();
}

function respawn(outsideScreen:Boolean = true):void{
	speed = -2.5 - Math.random() * 10;
	cloud.gotoAndStop(int(1+Math.random()*2.99));
	cloud.scaleX = cloud.scaleY = 1 + Math.random() * 0.6;
	
	cloud.y = -30 + Math.random() * 570;
	if(outsideScreen){
		cloud.x = 950;
	}else{
		cloud.x = -100 + Math.random() * 900;
	}
}
