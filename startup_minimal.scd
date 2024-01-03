(
q = q ? ();

"startup minimal".postln;
/*
Task {
Server.killAll;
0.2.wait
}.play(AppClock);
*/
"\n**********  loading serverConfig:  **********".postln;

s.latency = 0.04;
s.options
.numAudioBusChannels_(128 * 16)	 // for proxy usage: lots of ar bus space 1024
.memSize_(8192 * 32)		 // This memory is used to allocate synths! Increase this if you get "alloc failed" messages
.maxNodes_(1024 * 32)		 // lots of synth nodes 16 increase this if you are getting drop outs and the message "too many nodes"
.maxSynthDefs_(1024 *2)
.numWireBufs_(64 * 4)			 // fat synthdefs need lots of interconnects. increase if you get "exception in GraphDef_Recv: exceeded number of interconnect buffers." message
.maxLogins_(8)
.bindAddress_("0.0.0.0")
.numOutputBusChannels_(16)
.numInputBusChannels_(2)
.numBuffers_(1024 * 64) // increase this if you need to load more samples
);
(
s.waitForBoot ( {
    q.ndef_mixer = NdefMixer(s);
    0.1.wait;
    ProxyMeter.addMixer(q.ndef_mixer);
    0.1.wait;
    wait(0.2);
    "~/SuperCollider/FX/_fxLib.scd".standardizePath.load;
    wait(0.2);
    "~/SuperCollider/libs/_SynthLib.scd".standardizePath.load;
} );
);