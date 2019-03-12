import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/ui/screens/ContentScreen.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/AlbumGridViewWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SongListViewWidget.dart';

void main() => runApp( MyApp() );

class MyApp extends StatefulWidget{


  @override
  State createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final options = ["Artists", "Albums", "Songs", "Genres"];

  String currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = options[0];
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Audio Plugin'),
          actions: <Widget>[
            Theme(
                data: ThemeData.dark(),
                child:  DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentOption,
                    onChanged: (item){
                      setState(() {
                        currentOption = item;
                      });
                    },

                    items: List.generate(options.length, (index) =>
                        DropdownMenuItem<String>(
                          child: Text(options[index]),
                          value: options[index],
                        ),
                    ),
                  ),
                ),
            ),
          ],
        ),

        body: _createBody(),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.expand_more),
            onPressed: (){
            },
        ),
      ),
    );
  }

  Widget _createBody(){
    var bodyWidget;

    switch(currentOption){
      case "Artists":
        bodyWidget = FutureBuilder(
            future: audioQuery.getArtists(),
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

        /// getting all artists available on device
        //bodyWidget = _getAndBuildArtistsWidget( audioQuery.getArtists() );
        break;

      case "Albums":
        bodyWidget = FutureBuilder<List<AlbumInfo>>(
          future: audioQuery.getAlbums(),
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

        /// getting all albums available on device
        //bodyWidget = _getAndBuildAlbumsWidget( audioQuery.getAlbums() );
        break;

      case "Songs":
        bodyWidget = FutureBuilder< List<SongInfo> >(

            future: audioQuery.getSongs(),
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
                      print("Song: ${song.displayName} - album art: ${song.albumArtwork}");
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                backgroundImage: (song.albumArtwork == null)
                                    ?  AssetImage("assets/no_cover.png")
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
        /// getting all songs available on device
        //return _getAndBuildSongsWidget( audioQuery.getSongs());
        break;


      case "Genres":
        bodyWidget = FutureBuilder< List<GenreInfo> >(
            /// getting ll genres available
            future: audioQuery.getGenres(),
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
                      GenreInfo genre = snapshot.data[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage("assets/no_cover.png"),
                            ),
                            title: Text("${ genre.name }"),
                            //onTap: () => print("Song Selected: $genre"),
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
        break;

    }

    return bodyWidget;
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


/*

  methods to build layouts in pieces.
  Widget _getAndBuildArtistsWidget(Future<List<ArtistInfo>> future){


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

  Widget _getAndBuildAlbumsWidget(Future<List<AlbumInfo>> future){
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

  Widget _getAndBuildSongsWidget(Future<List<SongInfo>> future){
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
                            backgroundImage: AssetImage("assets/no_cover.png")
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
  }*/
}

