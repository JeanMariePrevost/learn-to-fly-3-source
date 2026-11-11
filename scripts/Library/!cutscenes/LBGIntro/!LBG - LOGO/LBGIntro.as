// Library symbol "!cutscenes/LBGIntro/!LBG - LOGO/LBGIntro"

// ---- layer "Action", frame 59
for(var i:int=0;i<=14;i++){
	var p:MovieClip = new Particle();
	p.x = -87 + (Math.random() - 0.5) * 80;
	p.y = 175 + (Math.random() - 0.5) * 35;
	particleHolder.addChild(p);
}

// ---- layer "Action", frame 87
for(i=0;i<=22;i++){
	p = new Particle();
	p.x = 12 + (Math.random() - 0.5) * 110;
	p.y = 175 + (Math.random() - 0.5) * 30;
	particleHolder.addChild(p);
}

// ---- layer "Action", frame 114
for(i=0;i<=13;i++){
	p = new Particle();
	p.x = 119 + (Math.random() - 0.5) * 80;
	p.y = 175 + (Math.random() - 0.5) * 30;
	particleHolder.addChild(p);
}
