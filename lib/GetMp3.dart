

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


/**
 * https://www.jianshu.com/p/a332a20c4ddf
 *
 * 音樂播放
 * https://pub.dev/packages/flutter_audio_query
 */

  class GetMp3Activity extends StatelessWidget {
    @override
      Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Path Provider',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GetMp3fragment(title: 'Path Provider'),
      );
    }
  }

  class GetMp3fragment extends StatefulWidget {
    GetMp3fragment({Key key, this.title}) : super(key: key);
    final String title;

    @override
    _GetMp3fragment createState() => _GetMp3fragment();
  }

  class _GetMp3fragment extends State<GetMp3fragment> {

    Directory sdPath;
    @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();

  }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
        title: Text(widget.title +" " +playStatus),
        ),
        body: Center(
        child:FutureBuilder(
          future: _initDownloadsDirectoryState(), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Awaiting result...');
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                return snapshot.data != null
                    ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Column(children: [
                            Text('Size: ' +
                                snapshot.data[index]
                                    .statSync()
                                    .size
                                    .toString()),
                            Text('Path: ' +
                                snapshot.data[index].path.toString()),
                            Text('Date: ' +
                                snapshot.data[index]
                                    .statSync()
                                    .modified
                                    .toUtc()
                                    .toString())
                          ]),

                          subtitle: Text(
                              "Extension: ${p.extension(snapshot.data[index].absolute.path).replaceFirst('.', '')}"), // getting extension
                            onTap :()=> clickEvent(snapshot.data[index].path.toString(),p.extension(snapshot.data[index].absolute.path).replaceFirst('.', ''))
                        )
                    )
                )
                    : Center(
                        child: Text("Nothing!"),
                );
            }
            return null; // unreachable
          },
        ),
        ),
      );
    }
    AudioPlayer audioPlayer = AudioPlayer();
    AudioPlayerState isplaying=AudioPlayerState.STOPPED;
    var position = 0;
    var duration = 0;
    String _counter = '0/0';
    String playStatus = "播放";
    Color playColor = Colors.blue;
    Color playColorBg = Colors.red;

    Future<void> clickEvent(String localPath,String fileName) async {
      if(!fileName.contains("mp3")){
        audioPlayer.pause();
        position = await audioPlayer.getCurrentPosition();
        duration = await audioPlayer.getDuration();
        setState(() {
          playStatus = "播放";
          playColor = Colors.blue;
          playColorBg = Colors.red;
          _counter = '$position/$duration';
        });
        return;
      }else{
      isplaying = audioPlayer.state;
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
          audioPlayer.play(localPath, isLocal: true);
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

          });
          if (isplaying == AudioPlayerState.PLAYING) {
            duration = await audioPlayer.getDuration();
            // success
            setState(() {
              playStatus = "暫停";
              playColor = Colors.white;
              playColorBg = Colors.indigo;
            });
          } else {
            setState(() {
              playStatus = "播放";
              playColor = Colors.blue;
              playColorBg = Colors.red;
            });
          }
        }
      }
    }
    // _files() async {
    //   sdPath = await getExternalStorageDirectory();
    //   String documentsPath = sdPath.parent.parent.parent.parent.path+"/Download";
    //   print("20201030 documentsPath: ${documentsPath}");
    //   var directory = Directory(documentsPath);
    //   var filess = directory.listSync();
    //   print("20201030 filess num: ${filess.length}");
    //   for (var i = 0; i < filess.length; i++) {
    //     print("20201030 filess: ${filess[i].path}");
    //   }
    //   // var root = await getExternalStorageDirectory();
    //   // print("20201030 root path: ${root.path} ,root: ${root.toString()}");
    //   var files = await FileManager(root: sdPath).walk().toList();
    //   print("20201030 files num: ${files.length}");
    //   for (var i = 0; i < files.length; i++) {
    //     print("20201030 files: ${files[i].path} , ${files[i].parent}");
    //   }
    //   return filess;
    // }
    // Platform messages are asynchronous, so we initialize in an async method.
    _initDownloadsDirectoryState() async {
      Directory downloadsDirectory;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      } on PlatformException {
        print('Could not get the downloads directory');
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return null;
      var filess = downloadsDirectory.listSync();
      print("20201030 filess num: ${filess.length}");
      for (var i = 0; i < filess.length; i++) {
        print("20201030 filess: ${filess[i].path}");
      }
     return filess;
    }

    _getAllMp3() async {
      Directory dir = Directory('/storage/emulated/0/');
      String mp3Path = dir.toString();
      print("20201030 filess Directory:"+mp3Path);
      List<FileSystemEntity> _files;
      List<FileSystemEntity> _songs = [];
      _files = dir.listSync(recursive: true, followLinks: false);
      for(FileSystemEntity entity in _files) {
        String path = entity.path;
        if(path.endsWith('.mp3'))
          _songs.add(entity);
      }
      print("20201030 filess Directory:");
      print(_songs);
      print(_songs.length);

      return _songs;
    }
  }