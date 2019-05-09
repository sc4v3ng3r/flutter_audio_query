## 0.2.1

* **Breaking change**: Now getSongsFromAlbum don't take an ArtistInfo in parameter. If you want to get 
    all songs from an specific album you can use getSongsFromAlbum method. But if you want to get
    all songs from an specific album from an specific artist do this with getSongsFromArtistAlbum
    method. 

* Now is possible fetch songs by ID's with getSongsById method.

* Now is possible fetch albums by ID's with getAlbumsById method.

## 0.1.1

* **Bug fix**: Before this fix, getGenre method was returning genres that has no one data
    related, no one artist, album or a song. Now getGenre calls return only genres which 
    at least one artist, album or song appears. 

## 0.1.0

* Documentation completed

## 0.0.1

* Initial Release
