
part of flutter_audio_query;

class FlutterAudioQuery {
  static const String CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";

  /*static final List<String> DELEGATE_MAP = ['artist_delegate',
    'album_delegate', 'song_delegate'];*/

  //static const String DELEGATE = "delegate";

  static const MethodChannel _channel =
      const MethodChannel(CHANNEL_NAME);

  // TODO this will burn!
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// This method returns all artists info available on device storage
  Future< List< ArtistInfo> > getArtists() async {
    List<dynamic> dataList = await _channel.invokeMethod('getArtists');
    return _parseArtistDataList(dataList);
  }

  /// This method returns all albums info available on device storage
  Future < List<AlbumInfo> > getAlbums() async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbums');
    return _parseAlbumDataList(dataList);
  }

  /// This method returns all albums info from a specifc artist
  /// [artist] must be non null.
  Future< List<AlbumInfo> > getAlbumsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbumsFromArtist', {'artist': artist.name} );
    return _parseAlbumDataList(dataList);
  }

  /// This method return all songs info available on device storage.
  Future< List<SongInfo> > getSongs() async {
    List<dynamic> dataList = await _channel.invokeMethod( "getSongs");

    return _parseSongDataList(dataList);
  }

  /// This method return all songs info from a specific artist.
  Future< List<SongInfo> > getSongsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromArtist", {'artist': artist.name});

    return _parseSongDataList(dataList);
  }

  /// This method return all songs info from a specific album
  Future< List<SongInfo> > getSongsFromAlbum( {@required final AlbumInfo album} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromAlbum", {'album_id': album.id});

    return _parseSongDataList(dataList);
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

}
