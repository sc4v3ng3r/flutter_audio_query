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


/// AlbumInfo class holds all information about a specific artist album.
///
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

  String get firstYear => _data['minyear'];

  String get lastYear => _data['maxyear'];

  /// Returns the number of songs that this album contains.
  String get numberOfSongs => _data['numsongs'];

}