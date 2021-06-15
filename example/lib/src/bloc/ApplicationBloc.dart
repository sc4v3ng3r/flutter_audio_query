import 'dart:async';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import './BlocBase.dart';

enum NavigationOptions { ARTISTS, ALBUMS, SONGS, GENRES, PLAYLISTS }
enum SearchBarState { COLLAPSED, EXPANDED }

class ApplicationBloc extends BlocBase {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  static const List<String> _artistSortNames = [
    "DEFAULT",
    "MORE ALBUMS NUMBER FIRST",
    "LESS ALBUMS NUMBER FIRST",
    "MORE TRACKS NUMBER FIRST",
    "LESS TRACKS NUMBER FIRST"
  ];

  static const List<String> _albumsSortNames = [
    "DEFAULT",
    "ALPHABETIC ARTIST NAME",
    "MORE SONGS NUMBER FIRST",
    "LESS SONGS NUMBER FIRST",
    "MOST RECENT YEAR",
    "OLDEST YEAR"
  ];

  static const List<String> _songsSortNames = [
    "DEFAULT",
    "ALPHABETIC COMPOSER",
    "GREATER DURATION",
    "SMALLER DURATION",
    "RECENT YEAR",
    "OLDEST YEAR",
    "ALPHABETIC ARTIST",
    "ALPHABETIC ALBUM",
    "GREATER TRACK NUMBER",
    "SMALLER TRACK NUMBER",
    "DISPLAY NAME"
  ];

  static const List<String> _genreSortNames = ["DEFAULT"];

  static const List<String> _playlistSortNames = [
    "DEFAULT",
    "NEWEST_FRIST",
    "OLDEST_FIRST"
  ];

  static const Map<NavigationOptions, List<String>> sortOptionsMap = {
    NavigationOptions.ARTISTS: _artistSortNames,
    NavigationOptions.ALBUMS: _albumsSortNames,
    NavigationOptions.SONGS: _songsSortNames,
    NavigationOptions.GENRES: _genreSortNames,
    NavigationOptions.PLAYLISTS: _playlistSortNames,
  };

  ArtistSortType _artistSortTypeSelected = ArtistSortType.DEFAULT;
  AlbumSortType _albumSortTypeSelected = AlbumSortType.DEFAULT;
  SongSortType _songSortTypeSelected = SongSortType.DEFAULT;
  GenreSortType _genreSortTypeSelected = GenreSortType.DEFAULT;
  PlaylistSortType _playlistSortTypeSelected = PlaylistSortType.DEFAULT;

  // Navigation Stream controler
  final StreamController<NavigationOptions> _navigationController =
      StreamController
          .broadcast(); // BehaviorSubject.seeded(NavigationOptions.ARTISTS);
  Stream<NavigationOptions> get currentNavigationOption =>
      _navigationController.stream;

  //DATA QUERY STREAMS

  final StreamController<List<ArtistInfo>> _artistController =
      StreamController.broadcast();
  Stream<List<ArtistInfo>> get artistStream => _artistController.stream;

  final StreamController<List<AlbumInfo>> _albumController =
      StreamController.broadcast();
  Stream<List<AlbumInfo>> get albumStream => _albumController.stream;

  final StreamController<List<GenreInfo>> _genreController =
      StreamController.broadcast();
  Stream<List<GenreInfo>> get genreStream => _genreController.stream;

  final StreamController<List<SongInfo>> _songController =
      StreamController.broadcast();
  Stream<List<SongInfo>> get songStream => _songController.stream;

  final StreamController<List<PlaylistInfo>> _playlistDataController =
      StreamController.broadcast();
  Stream<List<PlaylistInfo>> get playlistStream =>
      _playlistDataController.stream;

  final StreamController<SearchBarState> _searchBarController =
      StreamController.broadcast();
  Stream<SearchBarState> get searchBarState => _searchBarController.stream;

  ApplicationBloc() {
    _navigationController.stream.listen(onDataNavigationChangeCallback);
    _navigationController.sink.add(NavigationOptions.ARTISTS);
  }

  void loadPlaylistData() {
    audioQuery.getPlaylists().then((playlist) {
      if (playlist != null) _playlistDataController.sink.add(playlist);
    }).catchError((error) {
      _playlistDataController.sink.addError(error);
    });
  }

  int getLastSortSelectionChooseBasedInNavigation(NavigationOptions? option) {
    switch (option) {
      case NavigationOptions.ARTISTS:
        return _artistSortTypeSelected.index;

      case NavigationOptions.ALBUMS:
        return _albumSortTypeSelected.index;

      case NavigationOptions.SONGS:
        return _songSortTypeSelected.index;

      case NavigationOptions.GENRES:
        return _genreSortTypeSelected.index;

      case NavigationOptions.PLAYLISTS:
        return _playlistSortTypeSelected.index;

      default:
        return 0;
    }
  }

  void changeArtistSortType(ArtistSortType type) {
    _artistSortTypeSelected = type;
    _fetchArtistData();
  }

  void changeAlbumSortType(AlbumSortType type) {
    _albumSortTypeSelected = type;
    _fetchAlbumData();
  }

  void changeSongSortType(SongSortType type) {
    _songSortTypeSelected = type;
    _fetchSongData();
  }

  void changeGenreSortType(GenreSortType type) {
    _genreSortTypeSelected = type;
    _fetchSongData();
  }

  void changePlaylistSortType(final PlaylistSortType type) {
    _playlistSortTypeSelected = type;
    _fetchPlaylistData();
  }

  void changeNavigation(final NavigationOptions option) =>
      _navigationController.sink.add(option);

  void _fetchArtistData({String? query}) {
    if (query == null)
      audioQuery
          .getArtists(sortType: _artistSortTypeSelected)
          .then((data) => _artistController.sink.add(data))
          .catchError((error) => _artistController.sink.addError(error));
    else
      audioQuery
          .searchArtists(query: query)
          .then((data) => _artistController.sink.add(data))
          .catchError((error) => _artistController.sink.addError(error));
  }

  void _fetchPlaylistData({String? query}) {
    if (query == null)
      audioQuery
          .getPlaylists(sortType: _playlistSortTypeSelected)
          .then((playlistData) {
        if (playlistData != null)
          _playlistDataController.sink.add(playlistData);
        // ignore: return_of_invalid_type_from_catch_error
      }).catchError((error) => _playlistDataController.sink.addError(error));
    else
      audioQuery
          .searchPlaylists(query: query)
          .then(
              (playlistData) => _playlistDataController.sink.add(playlistData))
          .catchError((error) => _playlistDataController.sink.addError(error));
  }

  void _fetchAlbumData({String? query}) {
    if (query == null)
      audioQuery
          .getAlbums(sortType: _albumSortTypeSelected)
          .then((data) => _albumController.sink.add(data))
          .catchError((error) => _albumController.sink.addError(error));
    else
      audioQuery
          .searchAlbums(query: query)
          .then((data) => _albumController.sink.add(data))
          .catchError((error) => _albumController.sink.addError(error));
  }

  void _fetchSongData({String? query}) {
    if (query == null)
      audioQuery
          .getSongs(sortType: _songSortTypeSelected)
          .then((songList) => _songController.sink.add(songList))
          .catchError((error) => _songController.sink.addError(error));
    else
      audioQuery
          .searchSongs(query: query)
          .then((songList) => _songController.sink.add(songList))
          .catchError((error) => _songController.sink.addError(error));
  }

  void _fetchGenreData({String? query}) {
    if (query == null)
      audioQuery
          .getGenres(sortType: _genreSortTypeSelected)
          .then((data) => _genreController.sink.add(data))
          .catchError((error) => _genreController.sink.addError(error));
    else
      audioQuery
          .searchGenres(query: query)
          .then((data) => _genreController.sink.add(data))
          .catchError((error) => _genreController.sink.addError(error));
  }

  onDataNavigationChangeCallback(final NavigationOptions option) {
    switch (option) {
      case NavigationOptions.ARTISTS:
        _fetchArtistData();
        break;

      case NavigationOptions.PLAYLISTS:
        _fetchPlaylistData();
        break;

      case NavigationOptions.ALBUMS:
        _fetchAlbumData();
        break;

      case NavigationOptions.SONGS:
        _fetchSongData();
        break;

      case NavigationOptions.GENRES:
        _fetchGenreData();
        break;
    }
  }

  void search(
      {required NavigationOptions option, required final String query}) {
    switch (option) {
      case NavigationOptions.ARTISTS:
        _fetchArtistData(query: query);
        break;

      case NavigationOptions.PLAYLISTS:
        _fetchPlaylistData(query: query);
        break;

      case NavigationOptions.ALBUMS:
        _fetchAlbumData(query: query);
        break;

      case NavigationOptions.SONGS:
        _fetchSongData(query: query);
        break;

      case NavigationOptions.GENRES:
        _fetchGenreData(query: query);
        break;
    }
  }

  void changeSearchBarState(final SearchBarState newState) =>
      _searchBarController.sink.add(newState);

  @override
  void dispose() {
    _navigationController.close();
    _artistController.close();
    _albumController.close();
    _songController.close();
    _genreController.close();
    _playlistDataController.close();
    _searchBarController.close();
  }
}
