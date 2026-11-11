// Library symbol "!cutscenes/LBGIntro/!LBG - LOGO/Particle"

// ---- layer "Action", frame 1
import flash.events.Event;

addEventListener(Event.ENTER_FRAME, onFrame);
addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);

var vx:Number = (Math.random() - 0.5) * 8.5;
var vy:Number = (Math.random() - 0.25) * 4;
var vr:Number = (Math.random() - 0.5) * 6;

gotoAndStop(Math.ceil(Math.random() * totalFrames));


function onFrame(e:Event):void{
	vx *= 0.995;
	vy *= 0.998;
	vr *= 0.995;
	vy+= 0.07;
	
	x += vx;
	y += vy;
	rotation+=vr;
	
	if(y>=600){
		onRemoved(null);
	}
}

function onRemoved(e:Event):void{
	removeEventListener(Event.ENTER_FRAME, onFrame);
	removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
	if(parent)parent.removeChild(this);
}
