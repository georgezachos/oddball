// server options
(
Server.local.options.numOutputBusChannels = 34;
Server.local.options.numInputBusChannels = 0;
Server.internal.options.numOutputBusChannels = 34;
Server.internal.options.numInputBusChannels = 0;

// Server.local.options.device ="builtIn_Orion"; //"Orion 32";// "UltraLite-mk4";

Server.local.options.device = "Orion 32";// "UltraLite-mk4";
// Server.local.options.blockSize = 128;
// Server.internal.options.blockSize = 128;


// Archive.archiveDir = "~/scwork".standardizePath;
Server.local.options.memSize = 2.pow(17);
Server.internal.options.memSize = 2.pow(17);
s.boot;
s.meter;
);

(
SynthDef(\passby, {
	arg t_trig, ampa=1, ampb=1, amp=1, ampSub=1, gain=1, speed=0, tsim=10, y=1, x=0, fstCh=0, buffer1, buffer2;
	var in, in1, in2, pby, t, xt, cosphi, directivity;
	in1 = MulAdd(PlayBuf.ar(1, buffer1, BufRateScale.kr(buffer1), t_trig, loop:1.0), ampa);
	in2 = MulAdd(PlayBuf.ar(1, buffer2, BufRateScale.kr(buffer2), t_trig, loop:1.0), ampb);
	t = Line.ar(0,tsim,dur: tsim, doneAction: 2);
	xt = speed*tsim/2 - speed*t + x;
	cosphi = abs(xt)/(y.pow(2) + xt.pow(2)).pow(0.5);
	directivity  = 10.pow((4*cosphi-2.5)/20);
	in = in1 + MulAdd(in2,directivity);
	// in =in1+in2;
	pby = FaustWfsParallel.ar(in, speed, t_trig, tsim, x, y);
	// pby = FaustWfsXY.ar(in1+in2, 0, y);
	Out.ar(fstCh, MulAdd(pby[0..23],10*amp*gain));
	Out.ar(fstCh+24, MulAdd(pby[24],10*amp*gain*ampSub));
	// Out.ar(fstCh, x)

	// Out.ar(fstCh, amp*gain*pby[0,1])
	// Out.ar(fstCh, amp*gain*(in1+in2))h
}).add;
)
("/Users/gz/PhD/thesis/code/tmp/v50.wav"
a = Buffer.readChannel(s, "/Users/gz/PhD/LabPrep/stationarySignals/lightProp_SSD154_G12_T30_RPM3000_V50.wav", channels:[0]);
b = Buffer.readChannel(s, "/Users/gz/PhD/LabPrep/stationarySignals/lightRoll_SSD154_G12_T30_RPM3000_V50.wav", channels:[0]);

x = Synth(\passby,  [
	\t_trig, 1,
	\ampa, 1,
	\ampb, 1,
	\ampSub, 0.0,
	\amp,   1,
	\gain, 0.5,
	\speed, 50,
	\tsim,  30.0,
	\y, 5,
	\x, 0,
	\buffer1, a,
	\buffer2, b,

	// \direction, passbyVars[\direction][idx].value,

]);
)
(

x.set(\amp, 1.0, \ampSub, 0.0);

OSCdef(\trigPassby, {|msg ... args| switch(msg[1].asInt, 0,{x.set(\amp, 0)}, 1, {x.set(\amp, 2.5)}, 2, {x.set(\amp, 6.0)});postln(msg)}, \sound);
)

x.run;

0.1: 40dB
0.2: 45dB
0.4: 50dB
1.0: 60dB
2.5: 67dB - 55dbA
6.0: 60dbA

0.1: open window 45dBA
2.5: open window 70dBAl

(
a = Buffer.readChannel(s, "/Users/gz/Music/SuperCollider Recordings/traffic_20_30.aiff");

b = Buffer.readChannel(s, "/Users/gz/Music/SuperCollider Recordings/traffic_20_30_x2dist.aiff");
// b = Buffer.readChannel(s, "/Users/gz/Music/SuperCollider Recordings/traffic_40_80_far.aiff");
// a = Buffer.readChannel(s, "/Users/gz/Music/SuperCollider Recordings/traffic_40_80.aiff");
// b = Buffer.readChannel(s, "/Users/gz/Music/SuperCollider Recordings/traffic_high.aiff");
)
(
SynthDef(\traffic, {
	arg t_trig, amp=1, ampSub=1, fstCh=2, buffer, start=100000;
	var in, trigenv;
	in = MulAdd(PlayBuf.ar(25, buffer, BufRateScale.kr(buffer), t_trig, startPos: start), amp);
	// in[26] = MulAdd(in[26], 0.5);
	trigenv = Env([0, 1, 1, 0], [0.001, 1, 0.001]);
	Out.ar(fstCh, in[0..23]);
	Out.ar(fstCh+24, MulAdd(in[24], ampSub));
	Out.ar(0, EnvGen.ar(trigenv,t_trig)!2);
}).add;
)

(
x = Synth(\traffic,  [
	\t_trig, 1,
	\amp,   1,
	\buffer, a]
);

)
x.set(\amp,1.0, \ampSub,0.3, \buffer, a, \t_trig, 1);
(
OSCdef(\trigPassby, {|msg ... args| switch(
	msg[1].asInt,

	0, {x.set(\amp,0.0, \ampSub,0.3, \buffer, a, \t_trig, 1)},
	1, {x.set(\amp,1.0, \ampSub,0.3, \buffer, a, \t_trig, 1)},
	2, {x.set(\amp,1.0, \ampSub,0.3, \buffer, b, \t_trig, 1)});
postln(msg)},
\sound);
)
