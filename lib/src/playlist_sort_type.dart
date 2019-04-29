part of flutter_audio_query;

/// Options for playlist query sorting.
enum PlaylistSortType {
  /// The Default sort order for playlist. DEFAULT value the playlist
  /// query will return playlists sorted by alphabetically
  DEFAULT,

  /// The most recent playlist will come first with this
  /// sort type param.
  NEWEST_FIRST,

  /// The most old playlists will come first with this
  /// sort type param.
  OLDEST_FIRST
}
