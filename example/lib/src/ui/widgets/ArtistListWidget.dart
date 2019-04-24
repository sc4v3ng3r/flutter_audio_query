import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/Utility.dart';
import 'package:flutter_audio_query_example/src/bloc/ApplicationBloc.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/CardItemWidget.dart';


class ArtistListWidget extends StatelessWidget {
  final List<ArtistInfo> artistList;
  final _callback;

  ArtistListWidget({@required this.artistList, onArtistSelected(final ArtistInfo info)})
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
                    if (_callback != null)
                      _callback(artist);
                    print("Artist clicked ${artist.name}");
                  }),
                ),
              ),
            ],
          );
        }
    );
  }
}
/*
class ArtistListWidget extends StatefulWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  _ArtistListWidgetState createState() => _ArtistListWidgetState();
}

class _ArtistListWidgetState extends State<ArtistListWidget> {
  HomeScreenBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = InheritedBloc.of(context).bloc;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArtistSortType>(
      stream: bloc.artistSortTypeStream,
      builder: (context, streamSnapshot){

        if (streamSnapshot.hasError) {
          return  Utility.createDefaultInfoWidget(Text("Error ${streamSnapshot.error}"));
        }

        if (!streamSnapshot.hasData){
          return Utility.createDefaultInfoWidget(CircularProgressIndicator());
        }

        return FutureBuilder<List<ArtistInfo>>(
          future: widget.audioQuery.getArtists(sortType: streamSnapshot.data),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return  Utility.createDefaultInfoWidget(Text("Error ${snapshot.error}"));
            }

            if (!snapshot.hasData) {
              return Utility.createDefaultInfoWidget(CircularProgressIndicator());
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                ArtistInfo artist = snapshot.data[index];
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
                          print("Artist clicked ${artist.name}");
                        }),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      }
    );
  }

  @override
  void dispose() {
    bloc = null;
    super.dispose();
  }
}*/
