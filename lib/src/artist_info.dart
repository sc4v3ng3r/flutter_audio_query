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


/// ArtistInfo class holds all information about a specific artist.
///
class ArtistInfo extends DataModel {

  ArtistInfo._(Map<dynamic, dynamic> map) : super._(map);

  /// Returns the name of artist
  String get name => _data['artist'];

  /// Returns the number of tracks of current artist
  String get numberOfTracks => _data['number_of_tracks'];

  /// Returns the number of albums of current artist
  String get numberOfAlbums => _data['number_of_albums'];

  /// Returns the path from an image file that can be used as
  /// artist art or null if there is no one. The image file
  /// is the first artist album art work founded.
  String get artistArtPath => _data['artist_cover'];

  @override
  String toString() {
    return "\nId: $id\nName: $name\nNumber of tracks: $numberOfTracks\n"
        "Number of albums: $numberOfAlbums\nArt path: $artistArtPath";
  }
}