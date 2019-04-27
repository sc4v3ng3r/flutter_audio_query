import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/Utility.dart';
import 'package:flutter_audio_query_example/src/bloc/ApplicationBloc.dart';
import 'package:flutter_audio_query_example/src/bloc/BlocProvider.dart';
import 'package:flutter_audio_query_example/src/ui/screens/DetailsContentScreen.dart';
import 'package:flutter_audio_query_example/src/ui/screens/GenreNavigationScreen.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/AlbumGridWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ArtistListWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/GenreListWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/NewPlaylistDialog.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/NoDataWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/PlaylistListWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/SongListWidget.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ChooseDialog.dart';


class MainScreen extends StatefulWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {

  NavigationOptions _currentNavigationOption;
  ApplicationBloc bloc;


  static final Map<NavigationOptions, String> _titles = {
    NavigationOptions.ARTISTS : "Artists",
    NavigationOptions.ALBUMS : "Albums",
    NavigationOptions.SONGS : "Songs",
    NavigationOptions.GENRES : "Genres",
    NavigationOptions.PLAYLISTS : "Playlist",
  };

  @override
  void initState() {
    super.initState();
    _currentNavigationOption = NavigationOptions.ARTISTS;
  }

  @override
  Widget build(BuildContext context) {
    bloc ??= BlocProvider.of<ApplicationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Audio Plugin Example'),
          actions: <Widget>[

            StreamBuilder<NavigationOptions>(
                initialData: _currentNavigationOption,
                stream: bloc.currentNavigationOption,
                builder: (context, snapshot) {
                  return IconButton(icon: Icon(Icons.sort,),
                    tooltip: "${_titles[snapshot.data]} Sort Type",
                    onPressed: () => _displaySortChooseDialog(snapshot.data),
                  );
                }),
          ],
        ),

        body: StreamBuilder<NavigationOptions>(
          initialData: _currentNavigationOption,
          stream: bloc.currentNavigationOption,
          builder: (context, snapshot){

            if (snapshot.hasData){
              _currentNavigationOption = snapshot.data;

              switch(_currentNavigationOption){
                case NavigationOptions.ARTISTS:

                  return StreamBuilder<ArtistSortType>(
                    stream: bloc.artistSortTypeStream,
                    builder: (context, streamSnapshot) {

                      if (!streamSnapshot.hasData)
                        return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                      return FutureBuilder<List<ArtistInfo>>(
                        future: widget.audioQuery.getArtists(sortType: streamSnapshot.data),
                        builder: (context, futureSnapshot){
                          if (futureSnapshot.hasError)
                            return Utility.createDefaultInfoWidget(
                                Text("${futureSnapshot.error}")
                            );

                          if (!futureSnapshot.hasData)
                            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                          return (futureSnapshot.data.isEmpty) ?
                            NoDataWidget(title: "There is no Artists",) :

                            ArtistListWidget(
                              artistList: futureSnapshot.data,
                              onArtistSelected: _openArtistPage,
                          );
                        },
                      );
                    },
                  );

                case NavigationOptions.ALBUMS:
                  return StreamBuilder<AlbumSortType>(
                    stream: bloc.albumSortTypeStream,
                    builder: (context, streamSnapshot) {
                      print("album sort status: ${streamSnapshot.connectionState}");

                      if (!streamSnapshot.hasData)
                        return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                      return FutureBuilder<List<AlbumInfo>>(
                        future: widget.audioQuery.getAlbums(sortType: streamSnapshot.data),
                        builder: (context, snapshot){

                          if (snapshot.hasError)
                            return Utility.createDefaultInfoWidget(
                                Text("${snapshot.error}")
                            );

                          if (!snapshot.hasData)
                            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                          return (snapshot.data.isEmpty) ?
                            NoDataWidget(title: "There is no Albums",) :
                            AlbumGridWidget(
                              onAlbumClicked: _openAlbumPage,
                              albumList: snapshot.data
                            );
                        },
                      );
                    },
                  );

                case NavigationOptions.GENRES:
                  return StreamBuilder<GenreSortType>(
                    stream: bloc.genreSortTypeStream,
                    builder: (context, streamSnapshot) {

                      print("genre sort status: ${streamSnapshot.connectionState}");
                      if (!streamSnapshot.hasData)
                        return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                      return FutureBuilder<List<GenreInfo>>(
                        future: widget.audioQuery.getGenres(sortType: streamSnapshot.data),
                        builder: (context, snapshot){

                          if (snapshot.hasError)
                            return Utility.createDefaultInfoWidget(
                                Text("${snapshot.error}")
                            );

                          if (!snapshot.hasData)
                            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                          return (snapshot.data.isEmpty) ?
                            NoDataWidget(title: "There is no Genres",) :
                            GenreListWidget(
                              onTap: _openGenrePage,
                              genreList: snapshot.data
                            );
                        },
                      );
                    },
                  );

                case NavigationOptions.SONGS:
                  return StreamBuilder<SongSortType>(
                    stream: bloc.songSortTypeStream,
                    builder: (context, streamSnapshot) {
                      print("songs sort status: ${streamSnapshot.connectionState}");
                      if (!streamSnapshot.hasData)
                        return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                      return FutureBuilder<List<SongInfo>>(
                        future: widget.audioQuery.getSongs(sortType: streamSnapshot.data),
                        builder: (context, snapshot){

                          if (snapshot.hasError)
                            return Utility.createDefaultInfoWidget(Text("${snapshot.error}"));

                          if (!snapshot.hasData)
                            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                          return ( snapshot.data.isEmpty) ?
                            NoDataWidget(title: "There is no Songs",) :
                            SongListWidget(songList: snapshot.data);
                        },
                      );
                    },
                  );

                case NavigationOptions.PLAYLISTS:
                  bloc.loadPlaylistData();

                  return StreamBuilder<List<PlaylistInfo>>(
                    stream: bloc.fetchPlaylist,
                    builder: (context, snapshot){
                      if (snapshot.hasError)
                        return Utility.createDefaultInfoWidget(Text("${snapshot.error}"));

                      if (!snapshot.hasData)
                        return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                      return (snapshot.data.isEmpty) ?
                        NoDataWidget(title: "There is no Playlist",) :
                        PlaylistListWidget(
                            appBloc: bloc,
                            dataList: snapshot.data
                        );
                    },
                  );
              }
            }
          },
        ),
      bottomNavigationBar: _createBottomBarNavigator(),

      floatingActionButton: StreamBuilder<NavigationOptions>(
        initialData: _currentNavigationOption,
        stream: bloc.currentNavigationOption,
        builder: (context, snapshot){

          switch(snapshot.data){
            case NavigationOptions.PLAYLISTS:
              return FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  _showNewPlaylistDialog();
                },
              );
            default:
              return Container();
          }
        },

      ),
    );
  }

  /// this method returns bottom bar navigator widget layout
  Widget _createBottomBarNavigator(){
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),

      child: StreamBuilder<NavigationOptions>(
          initialData: _currentNavigationOption,
          stream: bloc.currentNavigationOption,
          builder: (context, snapshot) {

            if (snapshot.hasData)
              _currentNavigationOption = snapshot.data;

            return BottomNavigationBar(
              currentIndex: _currentNavigationOption.index,
              onTap: (indexSelected){
                bloc.changeNavigation( NavigationOptions.values[indexSelected] );
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
            );
          }
      ),
    );
  }

  void _displaySortChooseDialog(final NavigationOptions option){
    showDialog<void>(context: context,
        builder: (BuildContext context){
          return ChooseDialog(
            title: "${_titles[option]} Sort Options",
            initialSelectedIndex: bloc.getLastSortSelectionChooseBasedInNavigation(option),
            options: ApplicationBloc.sortOptionsMap[option],

            onChange: (index){
              switch(option){
                case NavigationOptions.ARTISTS:
                  bloc.changeArtistSortType(ArtistSortType.values[index]);
                  break;

                case NavigationOptions.ALBUMS:
                  bloc.changeAlbumSortType(AlbumSortType.values[index]);
                  break;

                case NavigationOptions.SONGS:
                  bloc.changeSongSortType(SongSortType.values[index]);
                  break;

                case NavigationOptions.GENRES:
                  bloc.changeGenreSortType(GenreSortType.values[index]);
                  break;

                case NavigationOptions.PLAYLISTS:
                  break;
              }
              Navigator.pop(context);
            },
          );
        }
    );
  }

  void _showNewPlaylistDialog() async {
    showDialog(
        context: context,
        builder: (context) => NewPlaylistDialog()
    ).then((data) {
      if (data != null)
        bloc.loadPlaylistData();
    });

  }

  @override
  void dispose() {
    print("HomeWidget dispose");
    super.dispose();
  }

  void _openArtistPage(final ArtistInfo data){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => DetailsContentScreen(
          appBarBackgroundImage: data.artistArtPath,
          appBarTitle: data.name,
          bodyContent: FutureBuilder<List<AlbumInfo>>(
              future: widget.audioQuery.getAlbumsFromArtist(artist: data),
              builder:(context, snapshot){

                if (!snapshot.hasData)
                  return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                return AlbumGridWidget(
                    onAlbumClicked: _openAlbumPage,
                    albumList: snapshot.data
                );
              }
          ),
        ),
      ),
    );
  }

  void _openAlbumPage(final AlbumInfo album){
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => DetailsContentScreen(
          appBarBackgroundImage: album.albumArt,
          appBarTitle: album.title,
          bodyContent: FutureBuilder<List<SongInfo>>(
              future: widget.audioQuery.getSongsFromAlbum(
                  sortType: SongSortType.DISPLAY_NAME,
                  album: album
              ),

              builder:(context, snapshot){

                if (!snapshot.hasData)
                  return Utility.createDefaultInfoWidget(CircularProgressIndicator());

                return SongListWidget( songList: snapshot.data );
              }
          ),
        ),
      ),
    );
  }

  void _openGenrePage(final GenreInfo genre){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => GenreNavigationScreen(currentGenre: genre,))
    );
  }
}