import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import './CardItemWidget.dart';

/// widget that show a gridView with all albums of a specific artist
class AlbumGridWidget extends StatelessWidget {
  final _onItemTap;
  final List<AlbumInfo> dataList;

  AlbumGridWidget(
      {@required List<AlbumInfo> albumList,
      onAlbumClicked(final AlbumInfo info)})
      : _onItemTap = onAlbumClicked,
        dataList = albumList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 16.0),
        itemCount: dataList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          AlbumInfo album = dataList[index];

          return Stack(
            children: <Widget>[
              CardItemWidget(
                height: 250.0,
                title: album.title,
                subtitle: "Number of Songs: ${album.numberOfSongs}",
                infoText: ("Year: ${album.firstYear ?? album.lastYear ?? ""}"),
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
