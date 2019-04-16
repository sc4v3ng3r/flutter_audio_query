
part of flutter_audio_query;
class PlaylistInfo extends DataModel {

  /// Ids of songs that appears on this playlist.
  List<String> _memberIds;

  PlaylistInfo._(Map<dynamic, dynamic> map) : super._(map);

  /// Returns playlist name
  String get name => _data["name"];

  String get count => _data["_count"];
  /// Returns a list with id's of SongInfo which are songs
  /// that appears in this playlist. You can retrieve SongInfo objects that
  /// appears in this playlist with getSongsFromPlayList method.
  /// The list is empty if there is no songs in this playlist.
  List<String> get memberIds => _memberIds ??= List<String>.from(_data["memberIds"]);

  /// Returns a String with a number in milliseconds (ms) that represents the
  /// date which this playlist was created.
  String get creationDate => _data["date_added"];

  /// This method appends a [song] into [playlist] and returns a PlaylistInfo
  /// updated.
  Future<void> addSong({@required final SongInfo song} ) async {
    dynamic updatedPlaylist = await FlutterAudioQuery.channel.invokeMethod( "addSongToPlaylist",
        {
          FlutterAudioQuery.SOURCE_KEY : FlutterAudioQuery.SOURCE_PLAYLIST,
          FlutterAudioQuery.PLAYLIST_METHOD_TYPE : PlayListMethodType.WRITE.index,
          "playlist_id" : this.id,
          "song_id" : song.id
        });

    PlaylistInfo data = PlaylistInfo._(updatedPlaylist);
    this._updatePlaylistData(data);
    //return PlaylistInfo._(updatedPlaylist);
  }

  Future<void> removeSong({@required SongInfo song}) async {
    var updatedPlaylist = await FlutterAudioQuery.channel.invokeMethod("removeSongFromPlaylist",
        {
          FlutterAudioQuery.SOURCE_KEY : FlutterAudioQuery.SOURCE_PLAYLIST,
          FlutterAudioQuery.PLAYLIST_METHOD_TYPE : PlayListMethodType.WRITE,
          "playlist_id" : this.id,
          "song_id" : song.id
        });

    PlaylistInfo data = PlaylistInfo._(updatedPlaylist);
    this._updatePlaylistData(data);
    //return PlaylistInfo._(updatedPlaylist);
  }

  void _updatePlaylistData(PlaylistInfo playlist){
    _memberIds = null;
    this._data = playlist._data;
  }

  @override
  String toString() {
    return "Name: $name\n creationDate: $creationDate members: $memberIds";
  }
}