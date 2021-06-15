import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import './CardItemWidget.dart';

/// widget that show a gridView with all albums of a specific artist
class AlbumGridWidget extends StatelessWidget {
  final _onItemTap;
  final List<AlbumInfo>? dataList;

  AlbumGridWidget(
      {required List<AlbumInfo>? albumList,
      onAlbumClicked(final AlbumInfo info)?})
      : _onItemTap = onAlbumClicked,
        dataList = albumList;

  @override
  Widget build(BuildContext context) {
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 16.0),
        itemCount: dataList!.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          AlbumInfo album = dataList![index];

          return Stack(
            children: <Widget>[
              (album.albumArt == null)
                  ? FutureBuilder<Uint8List>(
                      future: audioQuery.getArtwork(
                          type: ResourceType.ALBUM, id: album.id),
                      builder: (_, snapshot) {
                        if (snapshot.data == null)
                          return Container(
                            height: 250.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                        return CardItemWidget(
                          height: 250.0,
                          title: album.title,
                          subtitle: "Number of Songs: ${album.numberOfSongs}",
                          infoText:
                              ("Year: ${album.firstYear ?? album.lastYear ?? ""}"),
                          rawImage: snapshot.data,
                          //backgroundImage: album.albumArt,
                        );
                      })
                  : CardItemWidget(
                      height: 250.0,
                      title: album.title,
                      subtitle: "Number of Songs: ${album.numberOfSongs}",
                      infoText:
                          ("Year: ${album.firstYear ?? album.lastYear ?? ""}"),
                      backgroundImage: album.albumArt,
                    ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: () {
                    if (_onItemTap != null) _onItemTap(album);

                    print("Album clicked ${album.title}");
                  }),
                ),
              ),
            ],
          );
        });
  }
}
