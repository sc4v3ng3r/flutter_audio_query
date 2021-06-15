import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../Utility.dart';
import '../widgets/CardItemWidget.dart';

class GenreNavigationScreen extends StatefulWidget {
  final GenreInfo currentGenre;

  GenreNavigationScreen({required this.currentGenre});

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

                /// getting all artists from genre
                audioQuery.getArtistsFromGenre(
                    genre: widget.currentGenre.name!)),

            ///getting all albums from current genre and show them
            _createGenreAlbumsWidget(
                audioQuery.getAlbumsFromGenre(genre: widget.currentGenre.name!)),
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
          case ConnectionState.waiting:
            return Utility.createDefaultInfoWidget(CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data!.isEmpty)
              return Utility.createDefaultInfoWidget(
                  Text("There is no Artists data to show"));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0),
                  child: Text(
                    "${widget.currentGenre.name} $artistLabel",
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ArtistInfo artist = snapshot.data![index];
                        return CardItemWidget(
                          width: 150.0,
                          height: 250.0,
                          title: "Artist: ${artist.name}",
                          subtitle:
                              "Number of Albums: ${artist.numberOfAlbums}",
                          infoText: "Number of Songs: ${artist.numberOfTracks}",
                          backgroundImage: artist.artistArtPath,
                        );
                      }),
                ),
              ],
            );

          default:
            return Center(
              child: Text("No future response..."),
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
          case ConnectionState.waiting:
            return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading your albums"),
              ],
            );

          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data!.isEmpty)
              return Utility.createDefaultInfoWidget(
                  Text("There is no Albums data to show"));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0, left: 16.0),
                  child: Text(
                    "${widget.currentGenre.name} $albumsLabel",
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        AlbumInfo album = snapshot.data![index];
                        return CardItemWidget(
                          width: 150.0,
                          height: 250.0,
                          title: album.title,
                          subtitle: "Number of Songs: ${album.numberOfSongs}",
                          infoText: "Artist: ${album.artist}",
                          backgroundImage: album.albumArt,
                        );
                      }),
                ),
              ],
            );

          default:
            return Center(
              child: Text("No future response..."),
            );
        }
      },
    );
  }
}
