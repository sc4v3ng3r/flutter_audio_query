import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../bloc/BlocBase.dart';

class NewPlaylistDialog extends StatefulWidget {
  @override
  _NewPlaylistDialogState createState() => _NewPlaylistDialogState();
}

class _NewPlaylistDialogState extends State<NewPlaylistDialog> {
  TextEditingController? _textEditingController;
  final PlaylistDialogBloc bloc = PlaylistDialogBloc();

  bool creationStatus = false;
  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Playlist"),
      actions: <Widget>[
        StreamBuilder<PlaylistInfo>(
            stream: bloc.creationOutput,
            builder: (context, snapshot) {
              return TextButton(
                child: Text("Create"),
                onPressed: () async {
                  bloc.createPlaylist(_textEditingController!.text, context);
                },
              );
            }),
      ],
      content: StreamBuilder<String>(
        stream: bloc.errorOutput,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              hintText: 'Playlist name',
              errorText: snapshot.error as String?,
            ),
            autofocus: true,
            controller: _textEditingController,
            maxLines: 1,
            minLines: 1,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class PlaylistDialogBloc extends BlocBase {
  final StreamController<String> _errorController = new StreamController();
  Stream<String> get errorOutput => _errorController.stream;

  final StreamController<PlaylistInfo> _creationController = StreamController();
  Stream<PlaylistInfo> get creationOutput => _creationController.stream;

  createPlaylist(final String playlistName, BuildContext context) async {
    if (playlistName.isEmpty)
      _errorController.sink.addError("Playlist name is empty!");
    else {
      FlutterAudioQuery.createPlaylist(playlistName: playlistName).then((data) {
        print('Playlist created ${data.name}');
        Navigator.pop(context, data);
      }).catchError((error) {
        print('creatoin error ${error.toString()}');
        _errorController.sink.addError(error.toString());
      });
    }
  }

  @override
  void dispose() {
    _errorController.close();
    _creationController.close();
  }
}
