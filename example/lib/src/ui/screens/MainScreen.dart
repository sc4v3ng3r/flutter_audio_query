import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../Utility.dart';
import '../../bloc/ApplicationBloc.dart';
import '../../bloc/BlocProvider.dart';
import './DetailsContentScreen.dart';
import './GenreNavigationScreen.dart';
import '../widgets/AlbumGridWidget.dart';
import '../widgets/ArtistListWidget.dart';
import '../widgets/GenreListWidget.dart';
import '../widgets/NewPlaylistDialog.dart';
import '../widgets/NoDataWidget.dart';
import '../widgets/PlaylistListWidget.dart';
import '../widgets/SongListWidget.dart';
import '../widgets/ChooseDialog.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late NavigationOptions _currentNavigationOption;
  late SearchBarState _currentSearchBarState;
  late TextEditingController _searchController;
  ApplicationBloc? bloc;

  static final Map<NavigationOptions, String> _titles = {
    NavigationOptions.ARTISTS: "Artists",
    NavigationOptions.ALBUMS: "Albums",
    NavigationOptions.SONGS: "Songs",
    NavigationOptions.GENRES: "Genres",
    NavigationOptions.PLAYLISTS: "Playlist",
  };

  @override
  void initState() {
    super.initState();
    _currentNavigationOption = NavigationOptions.ARTISTS;
    _currentSearchBarState = SearchBarState.COLLAPSED;
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    bloc ??= BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<SearchBarState>(
            initialData: _currentSearchBarState,
            stream: bloc!.searchBarState,
            builder: (context, snapshot) {
              if (snapshot.data == SearchBarState.EXPANDED)
                return TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (typed) {
                    print("make search for: ${_searchController.text}");
                    bloc!.search(
                        option: _currentNavigationOption,
                        query: _searchController.text);
                  },
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.grey)),
                );

              return Text('Flutter AudioQuery Plugin');
            }),
        actions: <Widget>[
          StreamBuilder<SearchBarState>(
              initialData: _currentSearchBarState,
              stream: bloc!.searchBarState,
              builder: (context, snapshot) {
                switch (snapshot.data) {
                  case SearchBarState.EXPANDED:
                    return IconButton(
                        icon: Icon(
                          Icons.close,
                        ),
                        tooltip:
                            "Search for ${_titles[_currentNavigationOption]}",
                        onPressed: () => bloc!
                            .changeSearchBarState(SearchBarState.COLLAPSED));
                  default:
                    //case SearchBarState.COLLAPSED:
                    return IconButton(
                        icon: Icon(
                          Icons.search,
                        ),
                        tooltip:
                            "Search for ${_titles[_currentNavigationOption]}",
                        onPressed: () => bloc!
                            .changeSearchBarState(SearchBarState.EXPANDED));
                }
              }),
          StreamBuilder<NavigationOptions>(
              initialData: _currentNavigationOption,
              stream: bloc!.currentNavigationOption,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(
                    Icons.sort,
                  ),
                  tooltip: "${_titles[snapshot.data!]} Sort Type",
                  onPressed: () => _displaySortChooseDialog(snapshot.data),
                );
              }),
        ],
      ),
      body: StreamBuilder<NavigationOptions>(
        initialData: _currentNavigationOption,
        stream: bloc!.currentNavigationOption,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _currentNavigationOption = snapshot.data!;

            switch (_currentNavigationOption) {
              case NavigationOptions.ARTISTS:
                return StreamBuilder<List<ArtistInfo>>(
                  stream: bloc!.artistStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Utility.createDefaultInfoWidget(
                          Text("${snapshot.error}"));

                    if (!snapshot.hasData)
                      return Utility.createDefaultInfoWidget(
                          CircularProgressIndicator());

                    return (snapshot.data!.isEmpty)
                        ? NoDataWidget(
                            title: "There is no Artists",
                          )
                        : ArtistListWidget(
                            artistList: snapshot.data,
                            onArtistSelected: _openArtistPage);
                  },
                );

              case NavigationOptions.ALBUMS:
                return StreamBuilder<List<AlbumInfo>>(
                  stream: bloc!.albumStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Utility.createDefaultInfoWidget(
                          Text("${snapshot.error}"));

                    if (!snapshot.hasData)
                      return Utility.createDefaultInfoWidget(
                          CircularProgressIndicator());

                    return (snapshot.data!.isEmpty)
                        ? NoDataWidget(
                            title: "There is no Albums",
                          )
                        : AlbumGridWidget(
                            onAlbumClicked: _openAlbumPage,
                            albumList: snapshot.data);
                  },
                );

              case NavigationOptions.GENRES:
                return StreamBuilder<List<GenreInfo>>(
                  stream: bloc!.genreStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Utility.createDefaultInfoWidget(
                          Text("${snapshot.error}"));

                    if (!snapshot.hasData)
                      return Utility.createDefaultInfoWidget(
                          CircularProgressIndicator());

                    return (snapshot.data!.isEmpty)
                        ? NoDataWidget(
                            title: "There is no Genres",
                          )
                        : GenreListWidget(
                            onTap: _openGenrePage, genreList: snapshot.data);
                  },
                );

              case NavigationOptions.SONGS:
                return StreamBuilder<List<SongInfo>>(
                    stream: bloc!.songStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Utility.createDefaultInfoWidget(
                            Text("${snapshot.error}"));

                      if (!snapshot.hasData)
                        return Utility.createDefaultInfoWidget(
                            CircularProgressIndicator());

                      return (snapshot.data!.isEmpty)
                          ? NoDataWidget(
                              title: "There is no Songs",
                            )
                          : SongListWidget(songList: snapshot.data);
                    });

              case NavigationOptions.PLAYLISTS:
                return StreamBuilder<List<PlaylistInfo>>(
                  stream: bloc!.playlistStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Utility.createDefaultInfoWidget(
                          Text("${snapshot.error}"));

                    if (!snapshot.hasData)
                      return Utility.createDefaultInfoWidget(
                          CircularProgressIndicator());

                    return (snapshot.data!.isEmpty)
                        ? NoDataWidget(
                            title: "There is no Playlist",
                          )
                        : PlaylistListWidget(
                            appBloc: bloc, dataList: snapshot.data);
                  },
                );
            }
          }

          return NoDataWidget(
            title: "Something goes wrong!",
          );
        },
      ),
      bottomNavigationBar: _createBottomBarNavigator(),
      floatingActionButton: StreamBuilder<NavigationOptions>(
        initialData: _currentNavigationOption,
        stream: bloc!.currentNavigationOption,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case NavigationOptions.PLAYLISTS:
              return FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => _showNewPlaylistDialog());
            default:
              return Container();
          }
        },
      ),
    );
  }

  /// this method returns bottom bar navigator widget layout
  Widget _createBottomBarNavigator() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: StreamBuilder<NavigationOptions>(
          initialData: _currentNavigationOption,
          stream: bloc!.currentNavigationOption,
          builder: (context, snapshot) {
            if (snapshot.hasData) _currentNavigationOption = snapshot.data!;

            return BottomNavigationBar(
              currentIndex: _currentNavigationOption.index,
              onTap: (indexSelected) {
                bloc!.changeNavigation(NavigationOptions.values[indexSelected]);
              },
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box, color: Colors.white),
                  label: 'Artists',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.album,
                    color: Colors.white,
                  ),
                  label: "Albums",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music, color: Colors.white),
                  label: "Songs",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note, color: Colors.white),
                  label: "Genre",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list, color: Colors.white),
                  label: "Playlists",
                ),
              ],
            );
          }),
    );
  }

  void _displaySortChooseDialog(final NavigationOptions? option) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ChooseDialog(
            title: "${_titles[option!]} Sort Options",
            initialSelectedIndex:
                bloc!.getLastSortSelectionChooseBasedInNavigation(option),
            options: ApplicationBloc.sortOptionsMap[option],
            onChange: (index) {
              switch (option) {
                case NavigationOptions.ARTISTS:
                  bloc!.changeArtistSortType(ArtistSortType.values[index]);
                  break;

                case NavigationOptions.ALBUMS:
                  bloc!.changeAlbumSortType(AlbumSortType.values[index]);
                  break;

                case NavigationOptions.SONGS:
                  bloc!.changeSongSortType(SongSortType.values[index]);
                  break;

                case NavigationOptions.GENRES:
                  bloc!.changeGenreSortType(GenreSortType.values[index]);
                  break;

                case NavigationOptions.PLAYLISTS:
                  bloc!.changePlaylistSortType(PlaylistSortType.values[index]);
                  break;
              }
              Navigator.pop(context);
            },
          );
        });
  }

  void _showNewPlaylistDialog() async {
    showDialog(context: context, builder: (context) => NewPlaylistDialog())
        .then((data) {
      if (data != null) bloc!.loadPlaylistData();
    });
  }

  @override
  void dispose() {
    print("HomeWidget dispose");
    super.dispose();
  }

  void _openArtistPage(final ArtistInfo artist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsContentScreen(
          appBarBackgroundImage: artist.artistArtPath,
          appBarTitle: artist.name,
          bodyContent: FutureBuilder<List<AlbumInfo>>(
              future:
                  bloc!.audioQuery.getAlbumsFromArtist(artist: artist.name!),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Utility.createDefaultInfoWidget(
                      CircularProgressIndicator());

                return AlbumGridWidget(
                    onAlbumClicked: (album) {
                      _openArtistAlbumPage(artist, album);
                    },
                    albumList: snapshot.data);
              }),
        ),
      ),
    );
  }

  void _openArtistAlbumPage(final ArtistInfo artist, final AlbumInfo album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsContentScreen(
          appBarBackgroundImage: album.albumArt,
          appBarTitle: album.title,
          bodyContent: FutureBuilder<List<SongInfo>>(
              future: bloc!.audioQuery.getSongsFromArtistAlbum(
                  artist: artist.name!,
                  sortType: SongSortType.DISPLAY_NAME,
                  albumId: album.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Utility.createDefaultInfoWidget(
                      CircularProgressIndicator());

                return SongListWidget(songList: snapshot.data);
              }),
        ),
      ),
    );
  }

  void _openAlbumPage(final AlbumInfo album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsContentScreen(
          appBarBackgroundImage: album.albumArt,
          appBarTitle: album.title,
          bodyContent: FutureBuilder<List<SongInfo>>(
              future: bloc!.audioQuery.getSongsFromAlbum(
                  sortType: SongSortType.DISPLAY_NAME, albumId: album.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Utility.createDefaultInfoWidget(
                      CircularProgressIndicator());

                return SongListWidget(songList: snapshot.data);
              }),
        ),
      ),
    );
  }

  void _openGenrePage(final GenreInfo genre) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GenreNavigationScreen(
                  currentGenre: genre,
                )));
  }

  bool searchBarIsOpen() {
    return _currentSearchBarState == SearchBarState.EXPANDED;
  }
}
