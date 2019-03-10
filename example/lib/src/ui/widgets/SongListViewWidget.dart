import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

/// Widget that shows all songs of a specific album
class SongsListViewWidget extends StatelessWidget {
  final Future<List<SongInfo>> future;
  final AlbumInfo currentAlbum;
  final _onTapCallback;

  SongsListViewWidget({@required this.future, this.currentAlbum, void onTapCallback(final SongInfo info)})
      : _onTapCallback = onTapCallback;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder< List<SongInfo> >(
        future: future,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }

          else {

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  SongInfo song = snapshot.data[index];

                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: ( currentAlbum?.albumArt == null)
                              ? AssetImage("assets/no_cover.png")
                              : FileImage( File( currentAlbum?.albumArt )),
                        ),
                        title: Text("${ song.displayName }"),
                        subtitle: Text("${song.artist}"),
                        onTap: () => print("Song Selected: $song"),
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  );
                }
            );
          }
        }
    );
  }
}