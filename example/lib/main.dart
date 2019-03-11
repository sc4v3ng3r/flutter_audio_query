import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/ui/screens/ContentScreen.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/AlbumGridViewWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SongListViewWidget.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Audio Pulgin'),
        ),

        body: FutureBuilder(
          future: audioQuery.getArtists(), /// getting all artists available
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

                    ArtistInfo artist = snapshot.data[index];

                    return ItemHolderWidget<ArtistInfo>(
                        title: Text("Artist: ${artist.name}", maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0 ), ) ,
                        subtitle: Text("Number of Albums: ${artist.numberOfAlbums}"),
                        infoText: Text("Number of Songs: ${artist.numberOfTracks}"),
                        imagePath: artist.artistArtPath,
                        item: artist,
                        onItemTap: (artistSelected){
                          _onArtistTap(artistSelected, context);
                        } ,
                    );
                  }
              );
            }
          }
        ),
      ),
    );
  }

  void _onArtistTap(final ArtistInfo artistSelected, final BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ContentScreen(
            appBarBackgroundImage: artistSelected.artistArtPath,
            appBarTitle: artistSelected.name,

            bodyContent: AlbumGridViewWidget(
              ///getting all albums from specific artist
              future: audioQuery.getAlbumsFromArtist(artist: artistSelected),
              onItemTapCallback: (albumSelected){
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ContentScreen(
                        appBarBackgroundImage: albumSelected.albumArt,
                        appBarTitle: albumSelected.title,
                        bodyContent: SongsListViewWidget(
                          ///getting all songs from a specific album
                          future: audioQuery.getSongsFromAlbum( album: albumSelected),
                          currentAlbum: albumSelected,
                        ),
                      ),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }

}

