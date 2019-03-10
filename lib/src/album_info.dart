
part of flutter_audio_query;

class AlbumInfo extends DataModel {
  AlbumInfo._(Map<dynamic, dynamic> map) : super._(map);

  /// Returns the album title .
  String get title => _data['album'];

  /// Returns an image file path fof this album artwork
  /// or null if there is no one.
  String get albumArt => _data['album_art'];

  /*
  /// Return Id from this album
  /// the method id return the id of database row register.
  String get albumId => _data['album_id'];
  */
  ///Returns the artist name that songs appears in this album.
  String get artist => _data['artist'];

  int get firstYear => _data['minyear'];

  int get lastYear => _data['maxyear'];

  /// Returns the number of songs that this album contains.
  String get numberOfSongs => _data['numsongs'];

}