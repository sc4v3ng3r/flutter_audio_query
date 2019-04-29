# Flutter Audio Query

A Flutter plugin, Android only at this moment, that allows you query for audio metadata info about artists, 
albums, songs audio files and genres available on device storage. All work is made using Android native
[MediaStore API](https://developer.android.com/reference/android/provider/MediaStore) with 
[ContentResolver API](https://developer.android.com/reference/android/content/ContentResolver) and query methods
run in background thread. AndroidX support it's OK!

Note: This plugin is under development, Works in Android devices only and some APIs are not available yet.
Feedback, pull request, bug reports and suggestions are all welcome!

Feel free to help!  

# Example app included
 
![](https://i.ibb.co/pX7jV3N/artists.gif) | 
![](https://i.ibb.co/RBf12n6/albums.gif) | 
![](https://i.ibb.co/ncZvtrS/songs.gif) | 
![](https://i.ibb.co/c2XNMhp/genres.gif) | 


## Features
* Android permission READ_EXTERNAL_STORAGE built-in
* Get all artists audio info available on device storage.
* Get all artists available from a specific genre.
* Artist comes with some album Artwork cover if available.
* Get all albums info available on device storage.
* Get all albums available from a specific artist.
* Get all albums available from a specific genre.
* Album artwork included if available.
* Get songs all songs available on device storage.
* Get songs from a specific album.
* Get available genre.
* Get artists by genre.
* Get album by genre.
* Song comes with album artwork which the specific song appears.

## TO DO

* Make this basic implementation for iOS.
* CRUD operations against playlist provider.
* Streams support.
* Improvements in background tasks.
* More tests and probably bug fixes.

## Usage
To use this plugin, add `flutter_audio_query` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
  dependencies:
    flutter_audio_query
```

## API

### FlutterAudioQuery
To get get audio files metadata info you just need `FlutterAudioQuery` object instance.

```dart
///you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

/// create a FlutterAudioQuery instance.
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

List<ArtistInfo> artists = await audioQuery.getArtists(); // returns all artists available
 
artists.forEach( (artist){
      print(artist); /// prints all artist property values
    } );

/// getting all albums available from a specific artist
List<AlbumInfo> albums = await audioQuery.getAlbumsFromArtist(artist: artist);
    albums.forEach( (artistAlbum) {
      print(artistAlbum); //print all album property values
    });

 /// getting all albums available on device storage
 List<AlbumInfo> albumList = await audioQuery.getAlbums(); 
 
/// getting all genres available
 List<GenreInfo> genreList = audioQuery.getGenres();


 genreList.foreach( (genre){
   /// getting all artists available from specific genre.
   await audioQuery.getArtistsFromGenre(genre: genre);
 
   /// getting all albums which appears on genre [genre].
   await audioQuery.getAlbumsFromGenre(genre: genre);
   
   /// getting all songs which appears on genre [genre]
   await audioQuery.getSongsFromGenre(genre: genre);
    
 } );
 
 
 /// getting all songs available on device storage
List<SongInfo> songs = await audioQuery.getSongs();


albumList.foreach( (album){  
  /// getting songs from specific album
  audioQuery.getSongsFromAlbum(album: album);
 } );

```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT LICENSE](https://opensource.org/licenses/MIT)
