
part of flutter_audio_query;

class FlutterAudioQuery {
  static const String CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  static const String _SOURCE_KEY = "source";
  static const String _SOURCE_ARTIST = 'artist';
  static const String _SOURCE_ALBUM = 'album';
  static const String _SOURCE_SONGS = 'song';
  static const String _SOURCE_GENRE = 'genre';
  static const String _SOURCE_PLAYLIST = 'playlist';

  /// This method returns all artists info available on device storage
  Future< List< ArtistInfo> > getArtists() async {
    List<dynamic> dataList = await _channel.invokeMethod('getArtists', {_SOURCE_KEY : _SOURCE_ARTIST});
    return _parseArtistDataList(dataList);
  }

  Future< List<ArtistInfo>> getArtistsByGenre({@required final GenreInfo genre}) async {
    List<dynamic> dataList = await _channel.invokeMethod('getArtistsByGenre',
      {_SOURCE_KEY : _SOURCE_ARTIST, 'genre_name' : genre.name});
    return _parseArtistDataList(dataList);
  }
  /// This method returns all albums info available on device storage
  Future < List<AlbumInfo> > getAlbums() async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbums', {_SOURCE_KEY : _SOURCE_ALBUM});
    return _parseAlbumDataList(dataList);
  }

  Future < List<AlbumInfo> > getAlbumsFromGenre({@required final GenreInfo genre }) async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbumsFromGenre',
        {_SOURCE_KEY : _SOURCE_ALBUM, 'genre_name' : genre.name});

    return _parseAlbumDataList(dataList);
  }

  /// This method returns all albums info from a specifc artist
  /// [artist] must be non null.
  Future< List<AlbumInfo> > getAlbumsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbumsFromArtist', {
      'artist': artist.name, _SOURCE_KEY : _SOURCE_ALBUM} );

    return _parseAlbumDataList(dataList);
  }

  /// This method return all songs info available on device storage.
  Future< List<SongInfo> > getSongs() async {
    List<dynamic> dataList = await _channel.invokeMethod( "getSongs",
        { _SOURCE_KEY : _SOURCE_SONGS,

        });

    return _parseSongDataList(dataList);
  }

  /// This method return all songs info from a specific artist.
  Future< List<SongInfo> > getSongsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromArtist", {'artist': artist.name, _SOURCE_KEY : _SOURCE_SONGS });

    return _parseSongDataList(dataList);
  }

  /// This method return all songs info from a specific album
  Future< List<SongInfo> > getSongsFromAlbum( {@required final AlbumInfo album} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromAlbum", {'album_id': album.id, _SOURCE_KEY : _SOURCE_SONGS });

    return _parseSongDataList(dataList);
  }


  Future< List<GenreInfo> > getGenres() async {
    List<dynamic> dataList = await _channel.invokeMethod('getGenres', {_SOURCE_KEY : _SOURCE_GENRE });
    return _parseGenreDataList(dataList);
  }

  List< ArtistInfo > _parseArtistDataList( List<dynamic> dataList ){
    return dataList.map<ArtistInfo>( (dynamic item)
    => ArtistInfo._(item)).toList();
  }

  List< AlbumInfo > _parseAlbumDataList( List<dynamic > dataList){
    return dataList.map<AlbumInfo>( (dynamic item)
    => AlbumInfo._(item) ).toList();
  }

  List< SongInfo > _parseSongDataList( List<dynamic > dataList){
    return dataList.map<SongInfo>( (dynamic item)
    => SongInfo._(item) ).toList();
  }

  List < GenreInfo > _parseGenreDataList(List<dynamic> dataList){
    return dataList.map<GenreInfo>(  (dynamic item)
      => GenreInfo._(item)).toList();
  }
}
