q = q ? ();

"startup SuperClean".postln;
/*
Task {
Server.killAll;
0.2.wait
}.play(AppClock);
*/

"\n**********  loading serverConfig:  **********".postln;

s.latency = 0.24;
s.options
.numAudioBusChannels_(128 * 16)	 // for proxy usage: lots of ar bus space 1024
.memSize_(8192 * 32)		 // This memory is used to allocate synths! Increase this if you get "alloc failed" messages
.maxNodes_(1024 * 32)		 // lots of synth nodes 16 increase this if you are getting drop outs and the message "too many nodes"
.maxSynthDefs_(1024 *2)
.numWireBufs_(64 * 4)			 // fat synthdefs need lots of interconnects. increase if you get "exception in GraphDef_Recv: exceeded number of interconnect buffers." message
.numOutputBusChannels_(2)
.numBuffers_(1024 * 64) // increase this if you need to load more samples
.numInputBusChannels_(0)
.numOutputBusChannels_(10);
// thisProcess.platform.recordingsDir = "/your/path/here/"; // choose where supercollider recordings end up
// .sampleRate_(4800)

// A simple triangle wave synth in stereo with panning and a simple low pass filter.
// This synthDef was written by Mads Kjeldgaard and requires the sc3 plugins.
s.doWhenBooted{
	SynthDef(\default, {
		arg dur, attack=0.01, release=1.0,
		t_gate=1, out, freq=442, cutoff=5500,
		rq=1, pan=0.0, amp=0.5;

		var env = EnvGen.kr(Env.perc(attack, release), t_gate, timeScale: dur, doneAction: 2);
		var sig = DPW3Tri.ar(freq: freq, mul: env);
		sig = RLPF.ar(sig, cutoff.clip(20.0, 20000.0), rq.clip(0.0,1.0));
		sig = Pan2.ar(sig, pan);
		Out.ar(out, sig * amp);
	}).add;
};

s.waitForBoot({

    ~clean = SuperClean(10, s); // Two output channels, increase if you want to pan across more channels.
	~clean.loadSoundFiles;//("~/SuperCollider/libs/Samples/*");
	s.sync; // Wait for samples to be read.
	~clean.start([0,2,4,6,8]); // First 8 out looks like [0,2,4,6]
	SuperClean.default = ~clean; // Make the clean key sequenceable inside of SuperCollider.
	"[ SuperClean up + running ]".postln;

    s.sync;
    // MIDIClient.init;
    s
    .recChannels_(10); // record stereo out only
    s.sync;

    "********** make TempoClock t ***********".postln;
    t = TempoClock.new.permanent_(true);
    t.tempo = 110/60/2;
    "********** make ProxySpace p ***********".postln;
    0.1.wait;
    // t = t ? TempoClock.default;
    p = p ? ProxySpace.push;
    // p.push;
    0.1.wait;
    p.clock = t;
    0.1.wait;
    ProxySynthDef.sampleAccurate = true;
    0.1.wait;
    p.quant = 4;
    0.1.wait;
    p.fadeTime = 0;
    0.1.wait;
    p.reshaping = \elastic;
    p.play;
    s.sync;
    0.2.wait;
    p.know = true;
    ( Platform.userHomeDir ++ "/SuperCollider/libs/_colecoes.scd" ).load;

    /*
    Document.open( Platform.userHomeDir ++ "/SuperCollider/libs/_colecoes.scd" );
    */

    s.sync;

    "********** load SynthDefs ***********".postln;

    ( Platform.userHomeDir ++ "/SuperCollider/libs/_SynthLib.scd" ).load;
    /*
    Document.open( Platform.userHomeDir ++ "/SuperCollider/libs/_SynthLib.scd" );
    */

    "********** load fx Functions  ***********".postln;

    ( Platform.userHomeDir ++ "/SuperCollider/FX/_fxFunc.scd" ).load;
    /*
    Document.open( Platform.userHomeDir ++ "/SuperCollider/libs/_fxFunc.scd" );
    */

    "********** load fx Lib ProxyChain ***********".postln;

    ( Platform.userHomeDir ++ "/SuperCollider/FX/_fxLib.scd" ).load;
    /*
    Document.open( Platform.userHomeDir ++ "/SuperCollider/libs/_fxLib.scd" );
    */

    s.sync;
    0.2.wait;
    PdefnAllGui.new(36);
    0.2.wait;
    q.pxMixer = ProxyMixer(p, 16); // espaço para 8 proxies
    0.2.wait;
    q.pxMixer.parent.alwaysOnTop_(true);
    0.2.wait;
    q.ndefMixer = NdefMixer(s);
    0.2.wait;
    ProxyMeter.addMixer(q.pxMixer);
    0.2.wait;
    ProxyMeter.addMixer(q.ndefMixer);
    1.wait;
    //( Platform.userHomeDir ++ "/SuperCollider/algoRaveBR2022/FX/mainCompressor_vst.scd" ).load;
    // wait(5.2);
//    ( Platform.userHomeDir ++ "/SuperCollider/algoRaveBR2022/interface/gui_Stuff.scd" ).load;
    // wait(0.2);

    wait(0.2);
    History.clear.end;      // clear to start over
    History.start;          // starts recording, opens log file
    p.push;
    Pdefn(\scale, Scale.choose(7, 12)).source.name;

    0.5.wait;
    "~/SuperCollider/interface/swingfy.scd".standardizePath.load; // a

    // "~/SuperCollider/libs/_vstPlugins.scd".standardizePath.load;
    // "~/SuperCollider/processes/vst_q-acid.scd".standardizePath.load; wait(12);
    // "~/SuperCollider/processes/vsti_q-drum.scd".standardizePath.load;
    wait(2);
    // "processes/tunel.scd".loadRelative;
    // "~/SuperCollider/processes/dubba.scd".standardizePath.load;
    // "FX/subMix.scd".loadRelative;
    // 1.wait;
    q.mod = MFunc(); "q.mod = MFunc".postln;
            // "VST/fxs/verbs.scd".loadRelative;
    2.wait;
    //});

    "********** load Sample Stuff ***********".postln;

    "~/SuperCollider/libs/_SampleLib_player-SynthDefs.scd".standardizePath.load;
    "~/SuperCollider/libs/_SampleLib_loadSamples.scd".standardizePath.load;
    wait(15);
    "~/SuperCollider/interface/superDirt_startup.scd".standardizePath.load;
    wait(0.2);
    "~/SuperCollider/instruments/tidalInstruments.scd".standardizePath.load;
    wait(0.2);
    "~/SuperCollider/FX/myTidalFx.scd".standardizePath.load;
    0.2.wait;
    "~/SuperCollider/FX/FXXX_orbs.scd".standardizePath.load;
    //q.printSamps;
    /*
    Document.open( Platform.userHomeDir ++ "/SuperCollider/libs/_SampleLib.scd" );
    [ "/Samples/dirtedit", "/Samples/airstrip", "/Samples/invocation",  "/Samples/skmecs", "/Samples/tr808", "/Samples/brazilperc"].do{|pat| var samples = Platform.userHomeDir ++ pat; q.getSamples(samples); "".postln; };
    */
    q.postServerOptions = {
        "********** Server info : **********".postln;
        "s.name: % \n"
        "s.address: % \n"
        "s.latency: % \n"
        .postf(s.name, s.addr, s.latency);
        "server options:".postln;
        s.options.dump;
        "\n***** Colecoes: *****\n".postln;
        "print :".postln;
        "q.printScl".postln;
        "q.printDeg".postln;
        "q.printPdeg".postln;
        "q.printPndeg".postln;
        "q.printChor".postln;
        "q.printDur".postln;
        "q.printPndur".postln;
        "q.printLeg".postln;
        "q.printPnleg".postln;
        "q.printAtt".postln;
        "q.printPnatt".postln;
        "\n***** SynthDefs: *****\n".postln;
        "q.printSdefs".postln;
        "q.synthDefs".postln;
        "q.tonalDefs".postln;
        "\n***** FX Functions & Lib: *****\n".postln;
        "q.printFx".postln;
        "\n***** Sample Stuff: *****\n".postln;
        "q.printPlayers".postln;
        "q.printSamps".postln;

        // "serverConfig loaded.".postln;
        // "********************".postln;
        // "MIDI client initiated.".postln;
        "********************".postln;
    };
});

// scnvim
/*if (\SCNvim.asClass.notNil) {
Server.default.doWhenBooted {
\SCNvim.asClass.updateStatusLine(1, 9670);
}
}*/
