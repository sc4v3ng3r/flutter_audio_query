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

class DataModel {

  /// unique database row register identify.
  static const String ID = "_id";

  /// model data
  Map<dynamic, dynamic> _data;

  DataModel._(this._data);

  /// The data model id
  String get id => _data[ID] ?? "";

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}