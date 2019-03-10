import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';


/// widget that show a gridView with all albums of a specific artist
class AlbumGridViewWidget extends StatelessWidget {

  final Future< List<AlbumInfo> > future;
  final _onItemTap;

  AlbumGridViewWidget({@required this.future, void onItemTapCallback(final AlbumInfo info) })
      : _onItemTap = onItemTapCallback;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder< List<AlbumInfo> >(
      future: future,
      builder: (context , snapshot){
        if (!snapshot.hasData){
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        else {
          return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 16.0),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2),

              itemBuilder: (context, index){

                AlbumInfo album = snapshot.data[index];

                return ItemHolderWidget<AlbumInfo>(
                  onItemTap: _onItemTap,
                  title: Text(album.title, maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.0 ),
                  ),

                  subtitle: Text("Number of Songs: ${album.numberOfSongs}"),
                  infoText: Text("Year: ${album.firstYear ?? album.lastYear ?? ""}"),
                  imagePath: album.albumArt,
                  item: album,
                );
              }
          );
        }
      },
    );
  }
}
