import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';




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

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(
            0, 79, 33, 1.0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Audio Playback'),
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

  final audioControl = StreamController();
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

  Future<void> startPlayback() async{
    try{
      if(await rec.hasPermission() && !playing){
        await audioControl.addStream(await rec.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits)));
        print(audio.isBroadcast);


        setState(() {
          playing = true;
        });
      }
    }
    catch(e){
      print('error: $e');
    }
  }

  Future<void> stopPlayback() async{
    try{
      await rec.stop();
      await player.stop();
      setState(() {
        playing = false;
      });
    }
    catch(e){
      print('error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.tertiary,

        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body:  Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: startPlayback, child: const Text('Play audio')),
            ElevatedButton(onPressed: stopPlayback, child: const Text('Stop audio')),
          ],
        ),
      ),
    );
  }
}
