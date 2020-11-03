

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mp3_app/GetMp3.dart';
import 'package:flutter_mp3_app/GetMp3Permission.dart';

import 'GetPath.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = '0/0';
  AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache localPlayer = AudioCache(); //本地端音樂播放使用
  var localPath = 'macross.mp3';
  AudioPlayerState isplaying=AudioPlayerState.STOPPED;
  String playStatus = "播放";
  Color playColor = Colors.blue;
  Color playColorBg = Colors.red;
  var position = 0;
  var duration = 0;
  //AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);//使用低延时(low latency)API，当然它更适合游戏声音

  /**
   * Flutter 中的音频播放
   * http://macro-magic.com/flutter/audioplayers.html#_2-install-it
   * 音频播放 audioplayers
   * https://www.jianshu.com/p/288f869690f0
   *使用AudioCache播放資源音頻文件
   * https://dengxiaolong.com/article/2019/07/using-audiocache-to-play-source-audio-files-in-flutter.html
   */
  void btnCenterClickEvent()async{
    isplaying = audioPlayer.state;
    localPath = '/storage/emulated/0/Download/《明天會更好》cover 蕭小M feat.網紅朋友們.mp3';
    if(isplaying==AudioPlayerState.PLAYING){
      audioPlayer.pause();
      position = await audioPlayer.getCurrentPosition();
      duration = await audioPlayer.getDuration();
      setState(() {
        playStatus = "播放";
        playColor = Colors.blue;
        playColorBg = Colors.red;
        _counter = '$position/$duration';
      });
    }else {
      print('lyon play mp3 localPath:$localPath');
      // audioPlayer= await localPlayer.play(localPath);
      audioPlayer.play(localPath,isLocal: true);
      isplaying = audioPlayer.state;
      // isplaying = await audioPlayer.resume();

      print('lyon play mp3 result:$isplaying');

      int position = 0;
      audioPlayer.onAudioPositionChanged.listen((Duration p) {
        print('lyon play mp3   Currrent postion: $p');
        setState(() {
          position = p.inMilliseconds;
          _counter = '$p/$duration';
        });
      });
      audioPlayer.onPlayerError.listen((msg) {
        print('lyon play mp3   audioPlayer error : $msg');
        setState(() {

        });
      });
      audioPlayer.onPlayerCompletion.listen((event) {
        onComplete();
        setState(() {
        });
      });
      if (isplaying == AudioPlayerState.PLAYING) {
        duration = await audioPlayer.getDuration();
        // success
        setState(() {
          playStatus = "暫停";
          playColor = Colors.white;
          playColorBg = Colors.indigo;
        });
      }else {
        setState(() {
          playStatus = "播放";
          playColor = Colors.blue;
          playColorBg = Colors.red;
        });
      }
    }
  }

  void onComplete(){

  }

  void deactivate() async{
    print('结束');
    int result = await audioPlayer.release();
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              localPath,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              child: Text(playStatus),
              onPressed: btnCenterClickEvent,
              color: playColorBg,
              textColor: playColor,
              elevation: 20,
            ),
            RaisedButton(
              child: Text('Get Mp3 path'),
              onPressed: gotoMp3,
              color: playColorBg,
              textColor: playColor,
              elevation: 20,
            ),
            RaisedButton(
              child: Text('Get Path'),
              onPressed: gotoPath,
              color: playColorBg,
              textColor: playColor,
              elevation: 20,
            ),
          ],
        ),
      ),
    );
  }

  void gotoPath(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => GetPathfragment(title: 'get path')));
  }
  void gotoMp3(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => GetMp3Permission(title: 'get path')));
  }
}
