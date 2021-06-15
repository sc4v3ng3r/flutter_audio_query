import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../Utility.dart';
import './ListItemWidget.dart';
import './NoDataWidget.dart';

class SongListWidget extends StatelessWidget {
  final List<SongInfo>? songList;
  final String _dialogTitle = "Choose Playlist";
  final bool addToPlaylistAction;

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  SongListWidget({required this.songList, this.addToPlaylistAction = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songList!.length,
        itemBuilder: (context, songIndex) {
          SongInfo song = songList![songIndex];
          return ListItemWidget(
              title: Text("${song.title}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Artist: ${song.artist}"),
                  Text(
                    "Duration: ${Utility.parseToMinutesSeconds(int.parse(song.duration!))}",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              trailing: (addToPlaylistAction == true)
                  ? IconButton(
                      icon: Icon(Icons.playlist_add),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(_dialogTitle),
                                content: FutureBuilder<List<PlaylistInfo>?>(
                                    future: audioQuery.getPlaylists(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print("has error");
                                        return Utility.createDefaultInfoWidget(
                                            Text("${snapshot.error}"));
                                      }

                                      if (snapshot.hasData) {
                                        if (snapshot.data!.isEmpty) {
                                          print("is Empty");
                                          return NoDataWidget(
                                            title: "There is no playlists",
                                          );
                                        }

                                        return PlaylistDialogContent(
                                          options: snapshot.data!
                                              .map((playlist) => playlist.name)
                                              .toList(),
                                          onSelected: (index) {
                                            snapshot.data![index!]
                                                .addSong(song: song);
                                            Navigator.pop(context);
                                          },
                                        );
                                      }

                                      print("has no data");
                                      return Utility.createDefaultInfoWidget(
                                          CircularProgressIndicator());
                                    }),
                              );
                            });
                      },
                      tooltip: "add to playlist",
                    )
                  : Container(
                      width: .0,
                      height: .0,
                    ),
              imagePath: song.albumArtwork,
              leading: (song.albumArtwork == null)
                  ? FutureBuilder<Uint8List>(
                      future: audioQuery.getArtwork(
                          type: ResourceType.SONG,
                          id: song.id,
                          size: Size(100, 100)),
                      builder: (_, snapshot) {
                        if (snapshot.data == null)
                          return CircleAvatar(
                            child: CircularProgressIndicator(),
                          );

                        if (snapshot.data!.isEmpty)
                          return CircleAvatar(
                            backgroundImage: AssetImage("assets/no_cover.png"),
                          );

                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: MemoryImage(
                            snapshot.data!,
                          ),
                        );
                      })
                  : null);
        });
  }
}

typedef OnSelected = void Function(int? index);

class PlaylistDialogContent extends StatefulWidget {
  final List<String?> options;
  final OnSelected? onSelected;
  final int? initialIndexSelected;

  PlaylistDialogContent(
      {required this.options, this.onSelected, this.initialIndexSelected});

  @override
  _PlaylistDialogContentState createState() => _PlaylistDialogContentState();
}

class _PlaylistDialogContentState extends State<PlaylistDialogContent> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndexSelected;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          return RadioListTile(
              title: Text(widget.options[index]!),
              value: index,
              groupValue: selectedIndex,
              onChanged: (dynamic value) {
                setState(() {
                  selectedIndex = value;
                });
                if (widget.onSelected != null)
                  widget.onSelected!(selectedIndex);
              });
        });
  }
}
