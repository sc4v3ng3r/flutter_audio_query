import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_audio_query_example/src/ui/widgets/ItemHolderWidget.dart';

class GenreNavigationScreen extends StatefulWidget {
  final GenreInfo currentGenre;

  GenreNavigationScreen({@required this.currentGenre});

  @override
  _GenreNavigationScreenState createState() => _GenreNavigationScreenState();
}

class _GenreNavigationScreenState extends State<GenreNavigationScreen> {
  static const String artistLabel = "Artists";
  static const String albumsLabel = "Albums";
  final FlutterAudioQuery audioQuery = new FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentGenre.name}"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _createGenreArtistsWidget(
                audioQuery.getArtistsByGenre(genre: widget.currentGenre)),
            ///gets all albums from current genre and show them
            _createGenreAlbumsWidget( audioQuery.getAlbumsFromGenre(
                genre: widget.currentGenre)),
          ],
        ),
      ),
    );
  }

  Widget _createGenreArtistsWidget(Future<List<ArtistInfo>> future) {
    return FutureBuilder<List<ArtistInfo>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("No future response..."),
            );

          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading your artists"),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            if (!snapshot.hasData || (snapshot.data.isEmpty)) {
              return Center(child: Text("There is no data to show"));
            }

            if (snapshot.data.isEmpty){
              return Center(child: Text("There is no data to show"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0),
                  child: Text("${widget.currentGenre.name} $artistLabel",
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                Container(
                  height: 220,
                  alignment: Alignment.center,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,

                      itemBuilder: (context, index) {
                        ArtistInfo currentArtist = snapshot.data[index];

                        return ItemHolderWidget<ArtistInfo>(
                          width: 160,
                          title: Text("Artist: ${currentArtist.name}", overflow: TextOverflow.ellipsis,),
                          subtitle: Text(
                              "Songs: ${currentArtist.numberOfTracks}"),
                          infoText: Text("Albums: ${currentArtist.numberOfAlbums}"),

                          /// if artist has no artwork (null) this is already handled inside ItemHolderWidget
                          imagePath: currentArtist.artistArtPath,
                          onItemTap: (artist) {},
                        );
                      }),
                ),
              ],
            );
        }
      },
    );
  }

  //transformar num metodo generico que recebe o itemBuilder  e o tipo de dado
  // a ser tratado!
  Widget _createGenreAlbumsWidget(Future<List<AlbumInfo>> future) {
    return FutureBuilder<List<AlbumInfo>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("No future response..."),
            );

          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading your albums"),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            if (!snapshot.hasData || (snapshot.data.isEmpty)) {
              return Center(child: Text("There is no data to show"));
            }

            if (snapshot.data.isEmpty){
              return Center(child: Text("There is no data to show"));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0),
                  child: Text("${widget.currentGenre.name} $albumsLabel",
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                Container(
                  height: 220,
                  alignment: Alignment.center,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,

                      itemBuilder: (context, index) {
                        AlbumInfo currentAlbum = snapshot.data[index];

                        return ItemHolderWidget<ArtistInfo>(
                          width: 160,
                          title: Text("Album: ${currentAlbum.title}", overflow: TextOverflow.ellipsis,),
                          subtitle: Text(
                              "Songs: ${currentAlbum.numberOfSongs}"),
                          infoText: Text(currentAlbum.lastYear ?? currentAlbum.lastYear ?? "" ),

                          /// if artist has no artwork (null) this is already handled inside ItemHolderWidget
                          imagePath: currentAlbum.albumArt,
                          onItemTap: (album) {},
                        );
                      }),
                ),
              ],
            );
        }
      },
    );
  }
}
