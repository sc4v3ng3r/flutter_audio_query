import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/bloc/BlocBase.dart';
import 'package:rxdart/rxdart.dart';


enum NavigationOptions { ARTISTS, ALBUMS, SONGS, GENRES, PLAYLISTS }
enum SearchBarState {COLLAPSED, EXPANDED }

class MainScreenBloc extends BlocBase {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  static const List<String> _artistSortNames = ["DEFAULT", "MORE ALBUMS NUMBER FIRST",
  "LESS ALBUMS NUMBER FIRST", "MORE TRACKS NUMBER FIRST", "LESS TRACKS NUMBER FIRST"];

  static const List<String> _albumsSortNames = ["DEFAULT", "ALPHABETIC ARTIST NAME", "MORE SONGS NUMBER FIRST",
  "LESS SONGS NUMBER FIRST", "MOST RECENT YEAR", "OLDEST YEAR"];

  static const List<String> _songsSortNames = ["DEFAULT", "ALPHABETIC COMPOSER", "GREATER DURATION",
  "SMALLER DURATION", "RECENT YEAR", "OLDEST YEAR", "ALPHABETIC ARTIST",
  "ALPHABETIC ALBUM", "GREATER TRACK NUMBER", "SMALLER TRACK NUMBER", "DISPLAY NAME"];

  static const List<String> _genreSortNames = ["DEFAULT"];

  static const Map<NavigationOptions, List<String> > sortOptionsMap = {
    NavigationOptions.ARTISTS : _artistSortNames,
    NavigationOptions.ALBUMS : _albumsSortNames,
    NavigationOptions.SONGS : _songsSortNames,
    NavigationOptions.GENRES : _genreSortNames,
    NavigationOptions.PLAYLISTS : _genreSortNames,
  };

  ArtistSortType artistSortTypeSelected = ArtistSortType.DEFAULT;
  ArtistSortType get lastArtistSortTypeSelected => artistSortTypeSelected;

  AlbumSortType _albumSortTypeSelected = AlbumSortType.DEFAULT;
  AlbumSortType get lastAlbumSortTypeSelected => _albumSortTypeSelected;

  SongSortType _songSortTypeSelected = SongSortType.DEFAULT;
  SongSortType get lastSongSortTypeSelected => _songSortTypeSelected;

  GenreSortType _genreSortTypeSelected = GenreSortType.DEFAULT;
  GenreSortType get lastGenreSortTypeSelected => _genreSortTypeSelected;

  // Navigation Stream controler
  final BehaviorSubject<NavigationOptions> _navigationController = BehaviorSubject.seeded(NavigationOptions.ARTISTS);
  Observable<NavigationOptions> get currentNavigationOption => _navigationController.stream;


  
  //DATA QUERY STREAMS

  final BehaviorSubject< List<ArtistInfo> > _artistController = BehaviorSubject();
  Observable< List<ArtistInfo> > get artistStream => _artistController.stream;

  final BehaviorSubject<List<AlbumInfo>> _albumController = BehaviorSubject();
  Observable<List<AlbumInfo>> get albumStream => _albumController.stream;

  final BehaviorSubject<List<GenreInfo>> _genreController = BehaviorSubject();
  Observable< List<GenreInfo> > get genreStream => _genreController.stream;

  final BehaviorSubject<List<SongInfo>> _songController = BehaviorSubject();
  Observable<List<SongInfo>> get songStream => _songController.stream;

  final BehaviorSubject<List<PlaylistInfo>> _playlistDataController = BehaviorSubject();
  Observable<List<PlaylistInfo>> get playlistStream => _playlistDataController.stream;
  
  final BehaviorSubject<SearchBarState> _searchBarController = BehaviorSubject.seeded(SearchBarState.COLLAPSED);
  Observable<SearchBarState> get searchBarState => _searchBarController.stream;

  MainScreenBloc(){
    _navigationController.listen( onDataNavigationChangeCallback );
  }

  void loadPlaylistData(){
    audioQuery.getPlaylists().then(
            (playlist){
              _playlistDataController.sink.add(playlist);
            }).catchError(
            (error){
              _playlistDataController.sink.addError(error);
            });
  }

  int getLastSortSelectionChooseBasedInNavigation(NavigationOptions option){
    switch(option){
      case NavigationOptions.ARTISTS:
        return artistSortTypeSelected.index;

      case NavigationOptions.ALBUMS:
        return _albumSortTypeSelected.index;

      case NavigationOptions.SONGS:
        return _songSortTypeSelected.index;

      case NavigationOptions.GENRES:
        return _genreSortTypeSelected.index;

      case NavigationOptions.PLAYLISTS:
        return 0;

      default:
        return 0;
    }

  }

  void changeArtistSortType(ArtistSortType type) {
    artistSortTypeSelected = type;
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

  void changePlaylistSortType(){}

  void changeNavigation(final NavigationOptions option) => _navigationController.sink.add(option);

  void _fetchArtistData({String query}){
    if (query == null)
      audioQuery.getArtists(sortType: artistSortTypeSelected)
        .then( (data) => _artistController.sink.add(data))
        .catchError( (error) => _artistController.sink.addError(error));
    else
      audioQuery.searchArtists(query: query).then((data) => _artistController.sink.add(data))
          .catchError( (error) => _artistController.sink.addError(error));
  }

  void _fetchPlaylistData({String query}){
    if (query == null)
      audioQuery.getPlaylists()
        .then( (playlistData) => _playlistDataController.sink.add(playlistData) )
        .catchError( (error) => _playlistDataController.sink.addError(error) );

    else
      audioQuery.searchPlaylists(query: query)
          .then( (playlistData) => _playlistDataController.sink.add(playlistData) )
          .catchError( (error) => _playlistDataController.sink.addError(error) );
  }

  void _fetchAlbumData({String query}){
    if (query == null)
      audioQuery.getAlbums(sortType: _albumSortTypeSelected)
        .then( (data) => _albumController.sink.add(data) )
        .catchError((error) => _albumController.sink.addError(error));
    else
      audioQuery.searchAlbums(query: query)
          .then( (data) => _albumController.sink.add(data) )
          .catchError((error) => _albumController.sink.addError(error));
  }

  void _fetchSongData({String query}){
    if (query == null)
      audioQuery.getSongs(sortType: _songSortTypeSelected)
        .then((songList) => _songController.sink.add( songList ))
        .catchError( (error) => _songController.sink.addError(error) );
    else
      audioQuery.searchSongs(query: query)
          .then((songList) => _songController.sink.add( songList ))
          .catchError( (error) => _songController.sink.addError(error) );
  }

  void _fetchGenreData({String query}){
    if (query == null)
      audioQuery.getGenres(sortType: _genreSortTypeSelected)
        .then( (data) => _genreController.sink.add(data))
        .catchError((error) => _genreController.sink.addError(error));
    else
      audioQuery.searchGenres(query: query)
          .then( (data) => _genreController.sink.add(data))
          .catchError((error) => _genreController.sink.addError(error));
  }

  onDataNavigationChangeCallback(final NavigationOptions option){
    switch(option){

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

  void search({NavigationOptions option, final String query}){
    switch(option){

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
  void changeSearchBarState(final SearchBarState newState) => _searchBarController.sink.add(newState);

  @override
  void dispose() {
    _navigationController?.close();
    //_albumSortType?.close();
    //_songSortType?.close();
    //_genreSortType?.close();
    _artistController?.close();
    _albumController?.close();
    _songController?.close();
    _genreController?.close();
    _playlistDataController?.close();
    _searchBarController?.close();
  }
}