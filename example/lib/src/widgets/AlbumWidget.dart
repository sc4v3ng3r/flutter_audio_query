import 'dart:io';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/material.dart';
class AlbumWidget extends StatelessWidget {

  final AlbumInfo album;
  final _callback;
  AlbumWidget(this.album, {void onTap(final AlbumInfo info)}) :
    _callback = onTap;

  @override
  Widget build(BuildContext context) {


    final mainContainer = Container(
      width: 180,
      height: 250,
      decoration: (album?.albumArt == null)  ?
          BoxDecoration(

            color: Colors.blue
          ) :

          BoxDecoration(
            image: DecorationImage(
              image: FileImage( File( album?.albumArt )),
              fit: BoxFit.cover,
              alignment: AlignmentDirectional.center,
          ),
      ),

      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(0xff, 0xff, 0xff, 0.5),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(child: Text("Album: ${album?.title ?? "Unknow Album"}" ,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.title,)),

                Flexible(child: Text("Artist: ${album?.artist ?? "Unknow Artist"}",
                    style: Theme.of(context).textTheme.body1 )
                ),
                Flexible(child: Text("Songs: ${album?.numberOfSongs ?? ""}",
                  style: Theme.of(context).textTheme.body1,
                )
                ),
              ],
            ),
          ),

          Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    if (_callback != null)
                      _callback(album);
                  },
                ),
              ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 4.0,
      child: mainContainer,
    );
  }
}
