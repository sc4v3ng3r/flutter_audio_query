import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import './ListItemWidget.dart';

typedef GenreItemTap = void Function(GenreInfo);

class GenreListWidget extends StatelessWidget {
  final List<GenreInfo> dataList;
  final GenreItemTap? onTap;

  GenreListWidget({required List<GenreInfo> genreList, this.onTap})
      : dataList = genreList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          GenreInfo genre = dataList[index];

          return Stack(
            children: [
              ListItemWidget(
                title: Text(genre.name),
              ),
              Positioned.fill(
                child: InkWell(
                  onTap: () {
                    if (onTap != null) onTap!(genre);
                  },
                ),
              ),
            ],
          );
        });
  }
}
