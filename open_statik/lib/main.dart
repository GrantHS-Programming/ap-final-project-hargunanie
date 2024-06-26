import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(153, 248, 51, 1.0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Audio Playback'),
    );
  }
}

class MyCustomSource extends StreamAudioSource {
  final Stream<Uint8List> _byteStream;
  MyCustomSource(this._byteStream);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {

    start ??= 0;

    final chunk = await _byteStream.skip(start).take (end ?? -1).first;

    return StreamAudioResponse(
      sourceLength: -1,
      contentLength: chunk.length,
      offset: start,
      stream: Stream.value(chunk),
      contentType: 'audio/mpeg',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final audioControl = StreamController();
  late AudioRecorder rec;
  late AudioPlayer player;
  late Stream<Uint8List> audio;
  bool playing = false;

  @override
  void initState() {
    player = AudioPlayer();
    rec = AudioRecorder();

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    rec.dispose();
    super.dispose();
  }

  Future<void> startPlayback() async {
    //await player.play(UrlSource('https://hargunanie.github.io/assets/jazz.mp3'));
    try {
      if (await rec.hasPermission() && !playing) {
        //await audioControl.addStream(await rec.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits)));
        audio = await rec
            .startStream(const RecordConfig(encoder: AudioEncoder.aacLc));
        print(audio.isBroadcast);
        //final audioSubscription = audio.listen((data) => playBytes(data));
        await player.setAudioSource(MyCustomSource(audio));
        player.play();


        setState(() {
          playing = true;
        });
      }
    } catch (e) {
      print('error: $e');
    }
  }

  /*void playBytes(Uint8List st) async {
    try {

    }
    catch (e) {
      print("could not start audio: $e");
    }
    //print(st);
  }*/

  Future<void> stopPlayback() async {
    try {
      await rec.stop();
      await player.stop();
      setState(() {
        playing = false;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void printHello() {
    print("Hello");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(153, 0, 51, 1.0),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: startPlayback,
              child: const Text('Play audio'),


            ),
            ElevatedButton(
                onPressed: stopPlayback, child: const Text('Stoap audio')),
            ElevatedButton(onPressed: printHello, child: const Text("See what happens!!!!!"))
          ],
        ),
      ),
    );
  }
}
