import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import './CardItemWidget.dart';

class ArtistListWidget extends StatelessWidget {
  final List<ArtistInfo> artistList;
  final _callback;

  ArtistListWidget(
      {@required this.artistList, onArtistSelected(final ArtistInfo info)})
      : _callback = onArtistSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 16.0),
        itemCount: artistList.length,
        itemBuilder: (context, index) {
          ArtistInfo artist = artistList[index];
          return Stack(
            children: <Widget>[
              CardItemWidget(
                height: 250.0,
                title: "Artist: ${artist.name}",
                subtitle: "Number of Albums: ${artist.numberOfAlbums}",
                infoText: "Number of Songs: ${artist.numberOfTracks}",
                backgroundImage: artist.artistArtPath,
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: () {
                    if (_callback != null) _callback(artist);
                    print("Artist clicked ${artist.name}");
                  }),
                ),
              ),
            ],
          );
        });
  }
}
