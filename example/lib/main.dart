import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/Utility.dart';
import 'package:flutter_audio_query_example/src/ui/screens/ContentScreen.dart';
import 'package:flutter_audio_query_example/src/ui/screens/GenreNavigationScreen.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/AlbumGridViewWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SongListViewWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SortOptionsDialog.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppWidget(),
    );
  }
}

enum NavigationOptions { ARTISTS, ALBUMS, SONGS, GENRES, PLAYLISTS }

class MyAppWidget extends StatefulWidget {
  @override
  _MyAppWidgetState createState() => _MyAppWidgetState();
}


class _MyAppWidgetState extends State<MyAppWidget> {
  /// audio query object
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  NavigationOptions _currentOption = NavigationOptions.ARTISTS;

  final _artistSortNames = ["DEFAULT", "MORE ALBUMS NUMBER FIRST",
  "LESS ALBUMS NUMBER FIRST", "MORE TRACKS NUMBER FIRST", "LESS TRACKS NUMBER FIRST"];

  final _albumsSortNames = ["DEFAULT", "ALPHABETIC ARTIST NAME", "MORE SONGS NUMBER FIRST",
  "LESS SONGS NUMBER FIRST", "MOST RECENT YEAR", "OLDEST YEAR"];

  final _songsSortNames = ["DEFAULT", "ALPHABETIC COMPOSER", "GREATER DURATION",
  "SMALLER DURATION", "RECENT YEAR", "OLDEST YEAR", "ALPHABETIC ARTIST",
  "ALPHABETIC ALBUM", "GREATER TRACK NUMBER", "SMALLER TRACK NUMBER", "DISPLAY NAME"];

  final _genreSortNames = ["DEFAULT"];

  ArtistSortType _artistSortTypeSelected = ArtistSortType.DEFAULT;
  AlbumSortType _albumsSortTypeSelected = AlbumSortType.DEFAULT;
  SongSortType _songsSortTypeSelected = SongSortType.DEFAULT;
  GenreSortType _genreSortTypeSelected = GenreSortType.DEFAULT;

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
          actions: <Widget>[
            IconButton(icon: Icon(Icons.sort,),
                tooltip: "Sorting types",
                onPressed: (){
                  showSortTypeChooseDialog();
                }),
          ],
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
        currentIndex: _currentOption.index,
        onTap: (indexSelected){
          setState(() {
            _currentOption = NavigationOptions.values[indexSelected];
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

          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.white),
            title: Text("Playlists", style: TextStyle(
                color: Colors.white
            ))
          ),
        ],
      ),
    );

  }

  Widget _createBody(){
    switch( _currentOption){
      case NavigationOptions.ARTISTS:
        /// query for all artists available and build layout
        /// inside this call you can se some ArtistInfo properties
        return _buildArtistsWidgetLayout( audioQuery.getArtists(
            sortType: _artistSortTypeSelected) );

      case NavigationOptions.ALBUMS:
        /// getting all albums available on device
      /// inside this call you can se some AlbumInfo properties
        return _buildAlbumsWidgetLayout( audioQuery.getAlbums(sortType: _albumsSortTypeSelected) );

      case NavigationOptions.SONGS:
        /// getting all songs available on device storage
        ///inside this call you can see the usage of some SongInfo properties
        return _buildSongsWidgetLayout( audioQuery.getSongs( sortType: _songsSortTypeSelected ) );

      case NavigationOptions.GENRES:
        /// getting all genres available on your device
        /// The only property available at this moment in GenreInfo class is 'name'.
        return _buildGenresWidgetLayout( audioQuery.getGenres(sortType: _genreSortTypeSelected) );

      case NavigationOptions.PLAYLISTS:
        return Container();
      default:
        break;
    }

    return Column(
      children: <Widget>[
        Center(child: Text("No Widget to show!"),),
      ],
    );
  }

  void showSortTypeChooseDialog(){

    switch(_currentOption){
      case NavigationOptions.ARTISTS:
        showDialog<void>(context: context,
            builder: (BuildContext context){
              return SortOptionsDialog(
                title: "Artist Sort Options",
                initialSelectedIndex: _artistSortTypeSelected.index,
                options: _artistSortNames,
                onChange: (index){
                  setState(() => _artistSortTypeSelected = ArtistSortType.values[index] );
                  Navigator.pop(context);
                },
              );
            }
        );
        break;

      case NavigationOptions.ALBUMS:
        showDialog<void>(context: context,
            builder: (BuildContext context){
              return SortOptionsDialog(
                title: "Albums Sort Options",
                initialSelectedIndex: _albumsSortTypeSelected.index,
                options: _albumsSortNames,
                onChange: (index){
                  setState(() => _albumsSortTypeSelected = AlbumSortType.values[index] );
                  Navigator.pop(context);
                },
              );
            }
        );
        break;

      case NavigationOptions.GENRES:
        showDialog<void>(context: context,
            builder: (BuildContext context){
              return SortOptionsDialog(
                title: "Genre Sort Options",
                initialSelectedIndex: _genreSortTypeSelected.index,
                options: _genreSortNames,
                onChange: (index){
                  setState(() => _genreSortTypeSelected = GenreSortType.values[index] );
                  Navigator.pop(context);
                },
              );
            }
        );
        break;

      case NavigationOptions.SONGS:
        showDialog<void>(context: context,
            builder: (BuildContext context){
              return SortOptionsDialog(
                title: "Songs Sort Options",
                initialSelectedIndex: _songsSortTypeSelected.index,
                options: _songsSortNames,
                onChange: (index){
                  setState(() => _songsSortTypeSelected = SongSortType.values[index] );
                  Navigator.pop(context);
                },
              );
            }
        );
        break;

      case NavigationOptions.PLAYLISTS:
        break;
    }
  }

  void _onArtistTap(final ArtistInfo artistSelected, final BuildContext context){

    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ContentScreen(
          appBarBackgroundImage: artistSelected.artistArtPath,
          appBarTitle: artistSelected.name,

          bodyContent: AlbumGridViewWidget(
            ///getting all albums from specific artist
            future: audioQuery.getAlbumsFromArtist(artist: artistSelected, ),

            onItemTapCallback: (albumSelected){
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => ContentScreen(
                    appBarBackgroundImage: albumSelected.albumArt,
                    appBarTitle: albumSelected.title,
                    bodyContent: SongsListViewWidget(
                      ///getting all songs from a specific album
                      future: audioQuery.getSongsFromAlbum(
                        album: albumSelected,
                        sortType: SongSortType.DISPLAY_NAME
                      ),
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
            future: audioQuery.getSongsFromAlbum( album: albumSelected,
                sortType: SongSortType.DISPLAY_NAME),
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
                        trailing: Text("${Utility.parseToMinutesSeconds(int.parse(song.duration))}",
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                        ),
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

