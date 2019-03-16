# Flutter Audio Query

FlutterAudioQuery plugin allows you to query ANDROID ONLY YET MediaStore Audio data info like artists, 
albums, songs and genres available on device storage. 

## Features

* Get all Artists audio info available on device storage.
* Artist Artwork cover
* Get all albums info available on device storage;
* Get albums from a specific artist
* Get songs all songs available on device storage
* Get songs from a specific album
* Permission Handling built in
* Get available genre
* Get artists by genre
* Get album by genre

## TO DO

* iOS implementation
* CRUD on user playlists
* Streams support



## Installation



```bash
You need include in your pubspec.yaml flutter_audio_query
```

## Usage

```dart
//you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

// create a FlutterAudioQuery instance.
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

List<ArtistInfo> artists = await audioQuery.getArtists(); // returns all artists available
 
artists.forEach( (artist){
      print(artist); // prints all artist property values
    } );

// gets all albums available from a specific artist
List<AlbumInfo> albums = await audioQuery.getAlbumsFromArtist(artist: artist);
    albums.forEach( (artistAlbum) {
      print(artistAlbum); //print all album property values
    });

List<SongInfo> songs = await  audioQuery.getSongs(); // gets all songs available on device storage

```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)


# flutter_audio_query

A new Flutter plugin to query android MediaStore Audio data.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
