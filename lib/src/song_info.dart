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


/// SongInfo class holds all information about a specific song audio file.
class SongInfo extends DataModel {
  SongInfo._(Map<dynamic, dynamic> map) : super._(map);

  /// Returns the album id which this song appears.
  String get albumId => _data['album_id'];

  /// Returns the artist id who create this audio file.
  String get artistId => _data['artist_id'];

  /// Returns the artist name who create this audio file.
  String get artist =>_data['artist'];

  /// Returns the album title which this song appears.
  String get album => _data['album'];

  // Returns the genre name which this song belongs.
  //String get genre => _data['genre_name'];

  /// Returns the song title.
  String get title => _data['title'];

  /// Returns the song display name. Display name string
  /// is a combination of [Track number] + [Song title] [File extension]
  /// Something like 1 My pretty song.mp3
  String get displayName => _data['_display_name'];

  /// Returns the composer name of this song.
  String get composer => _data['composer'];

  /// Returns the year of this song was created.
  String get year => _data['year'];

  /// Returns the album track number if this song has one.
  String get track => _data['track'];

  /// Returns a String with a number in milliseconds (ms) that is the duration of this audio file.
  String get duration => _data['duration'];

  /// Returns in ms, playback position when this song was stopped.
  /// from the last time.
  String get bookmark => _data['bookmark'];

  /// Returns a String with a file path to audio data file
  String get filePath => _data['_data'];

  /// Returns a String with the size, in bytes, of this audio file.
  String get fileSize => _data['_size'];

  ///Returns album artwork path which current song appears.
  String get albumArtwork => _data['album_artwork'];

  bool get isMusic => _data['is_music'];

  bool get isPodcast => _data['is_podcast'];

  bool get isRingtone => _data['is_ringtone'];

  bool get isAlarm => _data['is_alarm'];

  bool get isNotification => _data['is_notification'];
}