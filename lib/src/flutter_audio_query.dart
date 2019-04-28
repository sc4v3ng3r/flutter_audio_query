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


enum PlayListMethodType { READ, WRITE }

class FlutterAudioQuery {
  static const String _CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";
  static const MethodChannel channel = const MethodChannel( _CHANNEL_NAME );

  /// key used for delegate type param.
  static const String SOURCE_KEY = "source";
  static const String QUERY_KEY = "query";
  static const String SOURCE_ARTIST = 'artist';
  static const String SOURCE_ALBUM = 'album';
  static const String SOURCE_SONGS = 'song';
  static const String SOURCE_GENRE = 'genre';
  static const String SORT_TYPE = "sort_type";
  static const String PLAYLIST_METHOD_TYPE = "method_type";
  static const String SOURCE_PLAYLIST = 'playlist';


  /// This method returns all artists info available on device storage
  Future< List<ArtistInfo> > getArtists({ArtistSortType sortType = ArtistSortType.DEFAULT}) async {
    List<dynamic> dataList = await channel.invokeMethod('getArtists',
        {
          SOURCE_KEY : SOURCE_ARTIST,
          SORT_TYPE : sortType.index,
        } );
    return _parseArtistDataList(dataList);
  }

  ///This method returns a list with all artists that belongs to [genre]
  ///
  /// [genre] must be non null
  Future< List<ArtistInfo> > getArtistsFromGenre({@required final GenreInfo genre,
    ArtistSortType sortType = ArtistSortType.DEFAULT}) async {

    List<dynamic> dataList = await channel.invokeMethod('getArtistsFromGenre',
      {
        SOURCE_KEY : SOURCE_ARTIST,
        'genre_name' : genre.name,
        SORT_TYPE : sortType.index,
      });
    return _parseArtistDataList(dataList);
  }

  /// This method search for artists which [name] property starts or match with [query] param.
  /// It returns a List of [ArtistInfo] instances or an empty list if no results.
  ///
  /// [query] String used to make the search
  Future< List<ArtistInfo> > searchArtists({@required String query,
    ArtistSortType sortType = ArtistSortType.DEFAULT }) async {
    List<dynamic> dataList = await channel.invokeMethod("searchArtistsByName",
        {
          SOURCE_KEY : SOURCE_ARTIST,
          SORT_TYPE : sortType.index,
          QUERY_KEY : query
        });
    return _parseArtistDataList(dataList);
  }

  /// This method returns a list of albums with all albums available in device storage.
  Future < List<AlbumInfo> > getAlbums({AlbumSortType sortType = AlbumSortType.DEFAULT}) async {
    List<dynamic> dataList = await channel.invokeMethod('getAlbums',
        {
          SOURCE_KEY : SOURCE_ALBUM,
          SORT_TYPE : sortType.index,
        });
    return _parseAlbumDataList(dataList);
  }

  ///This method returns a list with all albums that belongs to specific [genre]
  ///
  /// [genre] must be non null
  Future < List<AlbumInfo> > getAlbumsFromGenre({@required final GenreInfo genre,
    AlbumSortType sortType = AlbumSortType.DEFAULT }) async {
    List<dynamic> dataList = await channel.invokeMethod('getAlbumsFromGenre',
        {
          SOURCE_KEY : SOURCE_ALBUM,
          'genre_name' : genre.name,
           SORT_TYPE : sortType.index,
        });
    return _parseAlbumDataList(dataList);
  }

  /// This method returns all albums info from a specific artist.
  ///
  /// [artist] must be non null.
  Future< List<AlbumInfo> > getAlbumsFromArtist( {@required final ArtistInfo artist,
    AlbumSortType sortType = AlbumSortType.DEFAULT} ) async {
    List<dynamic> dataList = await channel.invokeMethod('getAlbumsFromArtist',
        {
          'artist': artist.name,
          SOURCE_KEY : SOURCE_ALBUM,
          SORT_TYPE : sortType.index,
        });
    return _parseAlbumDataList(dataList);
  }

  /// This method search for Albums which album [title] property starts or match with [query] param.
  /// It returns a List of [AlbumInfo] instances or an empty list if no results.
  ///
  /// [query] String used to make the search
  Future< List<AlbumInfo> > searchAlbums({@required final String query,
    AlbumSortType sortType = AlbumSortType.DEFAULT}) async{

    List<dynamic> dataList = await channel.invokeMethod('searchAlbums',
        {
          SOURCE_KEY : SOURCE_ALBUM,
          SORT_TYPE : sortType.index,
          QUERY_KEY : query,
        });
    return _parseAlbumDataList(dataList);
  }

  /// This method returns a list with all songs available on device storage.
  Future< List<SongInfo> > getSongs({SongSortType sortType = SongSortType.DEFAULT}) async {
    List<dynamic> dataList = await channel.invokeMethod( "getSongs",
        {
          SOURCE_KEY : SOURCE_SONGS,
          SORT_TYPE : sortType.index,
        });
    return _parseSongDataList(dataList);
  }

  /// This method returns list with  all songs info from a specific artist.
  ///
  /// [artist] must be non null
  Future< List<SongInfo> > getSongsFromArtist( {@required final ArtistInfo artist,
    SongSortType sortType = SongSortType.DEFAULT } ) async {
    List<dynamic> dataList = await channel.invokeMethod(
        "getSongsFromArtist",
        {
          'artist': artist.name,
          SOURCE_KEY : SOURCE_SONGS,
          SORT_TYPE : sortType.index,
        });

    return _parseSongDataList(dataList);
  }

  /// This method returns a list with of songs info with all songs that appears in
  /// specified[album].
  ///
  /// [album] must be non null.
  Future< List<SongInfo> > getSongsFromAlbum( {@required final AlbumInfo album,
    SongSortType sortType = SongSortType.DEFAULT} ) async {

    List<dynamic> dataList = await channel.invokeMethod(
        "getSongsFromAlbum",
        {
          'album_id': album.id,
          'artist': album.artist,
          SOURCE_KEY : SOURCE_SONGS,
          SORT_TYPE : sortType.index,
        });
    return _parseSongDataList(dataList);
  }

  /// This method returns a list fo songs info which all songs are from
  /// specified [genre].
  ///
  /// [genre] must be non null.
  Future< List<SongInfo> > getSongsFromGenre({@required final GenreInfo genre,
    SongSortType sortType = SongSortType.DEFAULT}) async{
    List<dynamic> dataList = await channel.invokeMethod("getSongsFromGenre",
      {
        SOURCE_KEY : SOURCE_SONGS,
        'genre_name' : genre.name,
        SORT_TYPE : sortType.index,
      });
    return _parseSongDataList(dataList);
  }

  // TODO possible go to PlaylistInfo class
  /// This method return a List with SongInfo instances that appears in playlist.
  /// The song order is the same that the playlist defines.
  /// An empty list is returned if the playlist has no songs.
  Future< List<SongInfo>> getSongsFromPlaylist({@required final PlaylistInfo playlist}) async{
    List<dynamic> dataList = await channel.invokeMethod( "getSongsFromPlaylist" ,
        {
          SOURCE_KEY : SOURCE_SONGS,
          'memberIds' : playlist.memberIds
        });

    return _parseSongDataList(dataList);
  }

  /// This method search for songs which [title] property starts or match with [query] string.
  /// It returns a List of [SongInfo] objects or an empty list if no results.
  ///
  /// [query] String used to make the search
  Future< List<SongInfo> > searchSongs({@required String query,
    SongSortType sortType = SongSortType.DEFAULT }) async {
    List<dynamic> dataList = await channel.invokeMethod("searchSongs",
        {
          SOURCE_KEY : SOURCE_SONGS,
          SORT_TYPE : sortType.index,
          QUERY_KEY : query
        });
    return _parseSongDataList(dataList);
  }
  
  /// This method returns a list of genre info with all genres available in device storage.
  Future< List<GenreInfo> > getGenres({GenreSortType sortType = GenreSortType.DEFAULT}) async {
    List<dynamic> dataList = await channel.invokeMethod('getGenres',
        {
          SOURCE_KEY : SOURCE_GENRE,
          SORT_TYPE : sortType.index,
        });
    return _parseGenreDataList(dataList);
  }

  /// This method search for genres which [name] property starts or match with [query] param.
  /// It returns a List of [GenreInfo] instances or an empty list if no results.
  ///
  /// [query] String used to make the search
  Future< List<GenreInfo> > searchGenres({@required final String query,
    GenreSortType sortType = GenreSortType.DEFAULT}) async {
    List<dynamic> dataList = await channel.invokeMethod("searchGenres",
        {
          SOURCE_KEY : SOURCE_GENRE,
          SORT_TYPE : sortType.index,
          QUERY_KEY : query,
        });

    return _parseGenreDataList(dataList);
  }

  /// This method returns a list of PlaylistInfo with all playlists available
  /// in device storage.
  Future< List<PlaylistInfo>> getPlaylists() async {
    List<dynamic> dataList = await channel.invokeListMethod("getPlaylists",
        {
          SOURCE_KEY : SOURCE_PLAYLIST,
          PLAYLIST_METHOD_TYPE : PlayListMethodType.READ.index,
        } );
    return _parsePlaylistsDataList(dataList);
  }

  /// This method search for playlist which [name] property starts or match with [query] param.
  /// It returns a List of [PlaylistInfo] instances or an empty list if no results.
  ///
  /// [query] String used to make the search
  Future< List<PlaylistInfo> > searchPlaylists({@required final String query}) async {
    List<dynamic> dataList = await channel.invokeMethod("searchPlaylists",
        {
          SOURCE_KEY : SOURCE_PLAYLIST,
          PLAYLIST_METHOD_TYPE : PlayListMethodType.READ.index,
          QUERY_KEY : query,
        });

    return _parsePlaylistsDataList(dataList);
  }

  /// This method creates a new empty playlist named [playlistName].
  /// If already exist a playlist with same name as [playlistName] an
  /// exception is throw.
  static Future <PlaylistInfo> createPlaylist({@required final String playlistName}) async {

    dynamic data = await FlutterAudioQuery.channel.invokeMethod("createPlaylist",
        {
          FlutterAudioQuery.SOURCE_KEY : FlutterAudioQuery.SOURCE_PLAYLIST,
          FlutterAudioQuery.PLAYLIST_METHOD_TYPE : PlayListMethodType.WRITE.index,
          "playlist_name" : playlistName,
        });
    return PlaylistInfo._(data);
  }

  static Future<void> removePlaylist({@required PlaylistInfo playlist}) async {
    await channel.invokeMethod("removePlaylist",
        {
          SOURCE_KEY : SOURCE_PLAYLIST,
          FlutterAudioQuery.PLAYLIST_METHOD_TYPE : PlayListMethodType.WRITE.index,
          "playlist_id" : playlist?.id
        });
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

  List < PlaylistInfo > _parsePlaylistsDataList(List<dynamic> dataList){
    return dataList.map<PlaylistInfo>(  (dynamic item)
    => PlaylistInfo._(item)).toList();
  }

}
