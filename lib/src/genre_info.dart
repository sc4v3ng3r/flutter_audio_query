part of flutter_audio_query;


class GenreInfo extends DataModel{
  GenreInfo._(Map<dynamic, dynamic> map) : super._(map);

  String get name => _data['name'];
}