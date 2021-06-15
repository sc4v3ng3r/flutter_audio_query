import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../Utility.dart';
import '../../bloc/BlocBase.dart';
import '../../bloc/BlocProvider.dart';
import './DetailsContentScreen.dart';
import '../widgets/ListItemWidget.dart';
import '../widgets/NoDataWidget.dart';

class PlaylistDetailScreen extends StatefulWidget {
  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late PlaylistDetailScreenBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PlaylistDetailScreenBloc>(context);

    return DetailsContentScreen(
      appBarTitle: bloc._playlist.name,
      bodyContent: StreamBuilder<List<SongInfo>>(
        stream: bloc.playlistSongs,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Utility.createDefaultInfoWidget(Text("${snapshot.error}"));

          if (!snapshot.hasData)
            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

          if (snapshot.data!.isEmpty)
            return NoDataWidget(title: "This playlist has no songs");

          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListItemWidget(
                  title: Text("${snapshot.data![index].title}"),
                  imagePath: snapshot.data![index].albumArtwork,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Artist: ${snapshot.data![index].artist}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0),
                      ),
                      Text(
                        "Album: ${snapshot.data![index].album}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      bloc.removeSong(snapshot.data![index]);
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}

class PlaylistDetailScreenBloc extends BlocBase {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final StreamController<List<SongInfo>> _playlistSongsSubject =
      StreamController.broadcast();

  Stream<List<SongInfo>> get playlistSongs => _playlistSongsSubject.stream;
  PlaylistInfo _playlist;

  PlaylistDetailScreenBloc(PlaylistInfo playlist) : _playlist = playlist {
    audioQuery
        .getSongsFromPlaylist(playlist: playlist)
        .then(_addToSink)
        .catchError((error) => _playlistSongsSubject.sink.addError(error));
  }

  void _addToSink(List<SongInfo> songs) {
    _playlistSongsSubject.sink.add(songs);
  }

  void removeSong(SongInfo song) {
    _playlist.removeSong(song: song).then((_) {
      audioQuery
          .getSongsFromPlaylist(playlist: _playlist)
          .then(_addToSink)
          .catchError((error) => _playlistSongsSubject.sink.addError(error));
    });
  }

  @override
  void dispose() {
    print("playlistdetails bloc dispose");
    _playlistSongsSubject.close();
  }
}
