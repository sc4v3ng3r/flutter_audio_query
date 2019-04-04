import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/ui/screens/ContentScreen.dart';
import 'package:flutter_audio_query_example/src/ui/screens/GenreNavigationScreen.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/AlbumGridViewWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SongListViewWidget.dart';

void main() => runApp( MyApp() );

class MyApp extends StatefulWidget{

  @override
  State createState() => _MyAppState();

}


class _MyAppState extends State<MyApp>{
  /// audio query object
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Audio Plugin Example'),
        ),

        body: _createBody(),

        bottomNavigationBar: _createBottomBarNavigator()
      ),
    );
  }

  /// this method returns bottom bar navigator widget layout
  Widget _createBottomBarNavigator(){
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),

      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (indexSelected){
          setState(() {
            _selectedIndex = indexSelected;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box,  color: Colors.white),
            title: Text("Artists", style: TextStyle(
                color: Colors.white), ),
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.album, color: Colors.white,),
              title: Text("Albums", style: TextStyle(
                  color: Colors.white),
              )
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.library_music, color: Colors.white),
            title: Text("Songs", style: TextStyle(
                color: Colors.white),
            ),
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.music_note,color: Colors.white),
              title: Text("Genre", style: TextStyle(
                  color: Colors.white
              ))
          ),
        ],
      ),
    );

  }

  Widget _createBody(){
    switch( _selectedIndex){
      case 0:
        /// query for all artists available and build layout
        /// inside this call you can se some ArtistInfo properties
        return _buildArtistsWidgetLayout( audioQuery.getArtists() );

      case 1:
        /// getting all albums available on device
      /// inside this call you can se some AlbumInfo properties
        return _buildAlbumsWidgetLayout( audioQuery.getAlbums() );

      case 2:
        /// getting all songs available on device storage
        ///inside this call you can see the usage of some SongInfo properties
        return _buildSongsWidgetLayout( audioQuery.getSongs());

      case 3:
        /// getting all genres available on your device
        /// The only property available at this moment in GenreInfo class is 'name'.
        return _buildGenresWidgetLayout( audioQuery.getGenres() );

      default:
        break;
    }

    return Column(
      children: <Widget>[
        Center(child: Text("No Widget to show!"),),
      ],
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

  void _onAlbumTap(final AlbumInfo albumSelected, final BuildContext context){
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
  }


  // Method to build artist widget layout
  Widget _buildArtistsWidgetLayout(Future<List<ArtistInfo>> future){

    return FutureBuilder(
        future: future,
        builder: (context, snapshot){

          if (snapshot.hasError){
            print(snapshot.error);

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:Text("${snapshot.error}"),
                ),
              ],
            );
          }

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
    );
  }

  // Method to build albums widget layout
  Widget _buildAlbumsWidgetLayout(Future<List<AlbumInfo>> future){
    return FutureBuilder<List<AlbumInfo>>(
      future: future,
      builder: (context, snapshot){

        if (snapshot.hasError){
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child:Text("${snapshot.error}"),
              ),
            ],
          );
        }

        if (!snapshot.hasData){
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child:CircularProgressIndicator(),
              ),
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            AlbumInfo album = snapshot.data[index];

            return ItemHolderWidget<AlbumInfo>(
              onItemTap: (albumSelected){
                _onAlbumTap(albumSelected, context);
              },

              title: Text(album.title, maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16.0 ),
              ),

              subtitle: Text("Number of Songs: ${album.numberOfSongs}"),
              infoText: Text("Year: ${album.firstYear ?? album.lastYear ?? ""}"),
              imagePath: album.albumArt,
              item: album,
            );

          },
        );

      },
    );
  }

  // Method to build Songs widget layout
  Widget _buildSongsWidgetLayout(Future<List<SongInfo>> future){


    return FutureBuilder< List<SongInfo> >(

        future: future,
        builder: (context, snapshot){

          if (snapshot.hasError){
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(snapshot.error),
                ),
              ],
            );
          }

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
                            backgroundImage: (song.albumArtwork == null)
                                ? AssetImage("assets/no_cover.png")
                                : FileImage(File(song.albumArtwork)),
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

  // Method to build Genres widget layout
  Widget _buildGenresWidgetLayout( Future< List<GenreInfo>> future ){
    return FutureBuilder< List<GenreInfo> >(
        future: future,
        builder: (context, snapshot){

          if (snapshot.hasError){
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(snapshot.error),
                ),
              ],
            );
          }

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
                  GenreInfo currentGenre = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/no_cover.png"),
                        ),
                        title: Text("${ currentGenre.name }"),

                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return GenreNavigationScreen(
                                currentGenre: currentGenre,
                              );
                            })
                          );
                        },
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

