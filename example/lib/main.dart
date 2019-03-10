import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:math';

import 'package:flutter_audio_query_example/src/widgets/AlbumWidget.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  List<SongInfo> _dataList;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    

    try {
      platformVersion = await FlutterAudioQuery.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /*setState(() {
      _platformVersion = platformVersion;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final Random random = new Random();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),

        body: FutureBuilder< List<AlbumInfo> >(
          future: _audioQuery.getAlbums(),
          builder: (context, snapshot){

            if (!snapshot.hasData){
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }

            else {
              return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 16.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return AlbumWidget( snapshot.data[index], onTap: (info){
                      print("SELECTED: $info");
                    }, );
                  }
              );

            }
          }
        ),
        /*body: (_dataList == null) ? Center(
          child: Text('Running on: $_platformVersion\n'),
        ) : ListView.builder(
              itemCount: _dataList.length,
              shrinkWrap: true,
             // itemExtent: 70.0,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_dataList[index].title),
                  ),
                );
              }),*/

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info),
          onPressed: () async {
            _audioQuery.getSongs().then((allSongsList){
              /*setState(() {
                _dataList = allSongsList;
              });*/
              allSongsList.forEach( (song) {
                print(song);
              });
            });
            /*
            List<ArtistInfo> artists = await _audioQuery.getArtists();

            var number= random.nextInt( artists.length );
            var artist = artists[number];

            //print("---- getting albums from: ${artist.name} ----");
            //List<AlbumInfo> albums = await _audioQuery.getAlbumsFromArtist(artist: artist);

            //var album =albums[0];
            print("--- getting songs from: ${artist.name}");

            List<SongInfo> songs = await _audioQuery.getSongsFromArtist(artist: artist);
            songs.forEach((song){
              print("Track: ${song.track}  - ${song.displayName} - Album: ${song.album}| path: ${song.filePath}");
            });

            */
          },
        ),
      ),
    );
  }


}
