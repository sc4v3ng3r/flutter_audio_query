import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/bloc/BlocBase.dart';
import 'package:rxdart/rxdart.dart';


enum NavigationOptions { ARTISTS, ALBUMS, SONGS, GENRES, PLAYLISTS }

class ApplicationBloc extends BlocBase {

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

  ArtistSortType _artistSortTypeSelected = ArtistSortType.DEFAULT;
  ArtistSortType get lastArtistSortTypeSelected => _artistSortTypeSelected;

  AlbumSortType _albumSortTypeSelected = AlbumSortType.DEFAULT;
  AlbumSortType get lastAlbumSortTypeSelected => _albumSortTypeSelected;

  SongSortType _songSortTypeSelected = SongSortType.DEFAULT;
  SongSortType get lastSongSortTypeSelected => _songSortTypeSelected;

  GenreSortType _genreSortTypeSelected = GenreSortType.DEFAULT;
  GenreSortType get lastGenreSortTypeSelected => _genreSortTypeSelected;

  final BehaviorSubject<NavigationOptions> _navigationSubject = BehaviorSubject();
  Observable<NavigationOptions> get currentNavigationOption => _navigationSubject.stream;

  final BehaviorSubject<ArtistSortType> _artistSortType =
    BehaviorSubject.seeded( ArtistSortType.DEFAULT );
  Observable<ArtistSortType> get artistSortTypeStream => _artistSortType.stream;

  final BehaviorSubject<AlbumSortType> _albumSortType =
    BehaviorSubject.seeded( AlbumSortType.DEFAULT );
  Observable<AlbumSortType> get albumSortTypeStream => _albumSortType.stream;

  final BehaviorSubject<SongSortType> _songSortType =
    BehaviorSubject.seeded( SongSortType.DEFAULT);
  Observable<SongSortType> get songSortTypeStream => _songSortType.stream;

  final BehaviorSubject<GenreSortType> _genreSortType =
    BehaviorSubject.seeded(GenreSortType.DEFAULT);
  Observable<GenreSortType> get genreSortTypeStream => _genreSortType.stream;

  
  final BehaviorSubject<List<PlaylistInfo>> _playlistDataController = BehaviorSubject();
  Observable<List<PlaylistInfo>> get fetchPlaylist => _playlistDataController.stream;

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
        return _artistSortTypeSelected.index;

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
    _artistSortType.sink.add(type);
    _artistSortTypeSelected = type;
  }

  void changeAlbumSortType(AlbumSortType type) {
    _albumSortType.sink.add(type);
    _albumSortTypeSelected = type;
  }

  void changeSongSortType(SongSortType type) {
    _songSortType.sink.add(type);
    _songSortTypeSelected = type;
  }

  void changeGenreSortType(GenreSortType type) {
    _genreSortType.sink.add(type);
    _genreSortTypeSelected = type;
  }

  void changePlaylistSortType(){}

  void changeNavigation(final NavigationOptions option) {
    _navigationSubject.sink.add(option);
  }
  
  @override
  void dispose() {
    _navigationSubject?.close();
    _artistSortType?.close();
    _albumSortType?.close();
    _songSortType?.close();
    _genreSortType.close();
    _playlistDataController?.close();
  }
}