//Copyright (C) <2019>  <Marcos Antonio Boaventura Feitoza> <scavenger.gnu@gmail.com>
//
//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.


part of flutter_audio_query;

class FlutterAudioQuery {
  static const String CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  /// key used for delegate type param.
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

  ///This method returns a list with all artists that belongs to [genre]
  ///
  /// [genre] must be non null
  Future< List<ArtistInfo>> getArtistsFromGenre({@required final GenreInfo genre}) async {
    List<dynamic> dataList = await _channel.invokeMethod('getArtistsFromGenre',
      {_SOURCE_KEY : _SOURCE_ARTIST, 'genre_name' : genre.name});
    return _parseArtistDataList(dataList);
  }

  /// This method returns a list of albums with all albums available in device storage.
  Future < List<AlbumInfo> > getAlbums() async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbums', {_SOURCE_KEY : _SOURCE_ALBUM});
    return _parseAlbumDataList(dataList);
  }

  ///This method returns a list with all albums that belongs to specific [genre]
  ///
  /// [genre] must be non null
  Future < List<AlbumInfo> > getAlbumsFromGenre({@required final GenreInfo genre }) async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbumsFromGenre',
        {_SOURCE_KEY : _SOURCE_ALBUM, 'genre_name' : genre.name});

    return _parseAlbumDataList(dataList);
  }

  /// This method returns all albums info from a specific artist.
  ///
  /// [artist] must be non null.
  Future< List<AlbumInfo> > getAlbumsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod('getAlbumsFromArtist', {
      'artist': artist.name, _SOURCE_KEY : _SOURCE_ALBUM} );

    return _parseAlbumDataList(dataList);
  }

  /// This method returns a list with all songs available on device storage.
  Future< List<SongInfo> > getSongs() async {
    List<dynamic> dataList = await _channel.invokeMethod( "getSongs",
        { _SOURCE_KEY : _SOURCE_SONGS,});

    return _parseSongDataList(dataList);
  }

  /// This method returns list with  all songs info from a specific artist.
  ///
  /// [artist] must be non null
  Future< List<SongInfo> > getSongsFromArtist( {@required final ArtistInfo artist} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromArtist", {'artist': artist.name, _SOURCE_KEY : _SOURCE_SONGS });

    return _parseSongDataList(dataList);
  }

  /// This method returns a list with of songs info with all songs that appears in
  /// specified[album].
  ///
  /// [album] must be non null.
  Future< List<SongInfo> > getSongsFromAlbum( {@required final AlbumInfo album} ) async {
    List<dynamic> dataList = await _channel.invokeMethod(
        "getSongsFromAlbum", {'album_id': album.id, _SOURCE_KEY : _SOURCE_SONGS });

    return _parseSongDataList(dataList);
  }

  /// This method returns a list fo songs info which all songs are from
  /// specified [genre].
  ///
  /// [genre] must be non null.
  Future< List<SongInfo> > getSongsFromGenre({@required final GenreInfo genre}) async{
    List<dynamic> dataList = await _channel.invokeMethod("getSongsFromGenre",
      {_SOURCE_KEY : _SOURCE_SONGS, 'genre_name' : genre.name });

    return _parseSongDataList(dataList);
  }

  /// This method returns a list of genre info with all genres available in device storage.
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
