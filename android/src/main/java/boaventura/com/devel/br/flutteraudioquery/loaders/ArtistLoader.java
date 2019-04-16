//Copyright (C) <2019>  <Marcos Antonio Boaventura Feitoza> <scavenger.gnu@gmail.com>
//
//        This program is free software: you can redistribute it and/or modify
//        it under the terms of the GNU General Public License as published by
//        the Free Software Foundation, either version 3 of the License, or
//        (at your option) any later version.
//
//        This program is distributed in the hope that it will be useful,
//        but WITHOUT ANY WARRANTY; without even the implied warranty of
//        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//        GNU General Public License for more details.
//
//        You should have received a copy of the GNU General Public License
//        along with this program.  If not, see <http://www.gnu.org/licenses/>.

package boaventura.com.devel.br.flutteraudioquery.loaders;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import boaventura.com.devel.br.flutteraudioquery.sortingtypes.ArtistSortType;
import io.flutter.plugin.common.MethodChannel;


public class ArtistLoader extends AbstractLoader {

    private static final String TAG = "MDBG";
    private static final int QUERY_TYPE_GENRE_ARTISTS = 0x01;
    //private static final int QUERY_TYPE_SEARCH_BY_NAME = 0x02;

    private static final String[] PROJECTION = new String[]{
            MediaStore.Audio.AudioColumns._ID, // row id
            MediaStore.Audio.ArtistColumns.ARTIST,
            MediaStore.Audio.ArtistColumns.NUMBER_OF_TRACKS,
            MediaStore.Audio.ArtistColumns.NUMBER_OF_ALBUMS,
    };

    public ArtistLoader(final Context context) {
        super(context);

        /*
        getContentResolver().registerContentObserver(
                MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI,
                false,
                new ContentObserver(null){
                    @Override
                    public boolean deliverSelfNotifications() {
                        return super.deliverSelfNotifications();
                    }

                    @Override
                    public void onChange(boolean selfChange) {
                        super.onChange(selfChange);
                        Log.i("MDBG", "onChange(self) in ArtistLoaderObserver");
                    }

                    @Override
                    public void onChange(boolean selfChange, Uri uri) {
                        super.onChange(selfChange, uri);
                        Log.i("MDBG", "onChange(self,uri) in ArtistLoaderObserver Uri: " + uri);
                    }
                }
        );*/
    }

    private String parseSortOrder(ArtistSortType sortType){
        String sortOrder;

        switch (sortType){

            case MORE_ALBUMS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Artists.NUMBER_OF_ALBUMS + " DESC";
                break;

            case LESS_ALBUMS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Artists.NUMBER_OF_ALBUMS + " ASC";
                break;

            case MORE_TRACKS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Artists.NUMBER_OF_TRACKS + " DESC";
                break;

            case LESS_TRACKS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Artists.NUMBER_OF_TRACKS + " ASC";
                break;

            case DEFAULT:
            default:
                sortOrder = MediaStore.Audio.Artists.DEFAULT_SORT_ORDER;
                break;
        }
        return sortOrder;
    }

    /**
     * This method queries in background all artists available in device storage.
     *
     * @param result MethodChannel results
     */
    public void getArtists(final MethodChannel.Result result, ArtistSortType sortType) {
        Log.i(TAG, "Artist sort type is: " + sortType );

        createLoadTask(result, null, null,
                parseSortOrder(sortType), QUERY_TYPE_DEFAULT).execute();
    }

    public void getArtistsFromGenre(final MethodChannel.Result result, final String genreName,
                                    ArtistSortType sortType) {
        createLoadTask(result, genreName, null,
                parseSortOrder(sortType), QUERY_TYPE_GENRE_ARTISTS).execute();
    }

    @Override
    protected ArtistLoadTask createLoadTask(
            final MethodChannel.Result result, final String selection,
            final String[] selectionArgs, final String sortOrder, final int type) {

        return new ArtistLoadTask(result, getContentResolver(), selection,
                selectionArgs, sortOrder, type);
    }



    static class ArtistLoadTask extends AbstractLoadTask<List<Map<String, Object>>> {
        private ContentResolver m_resolver;
        private MethodChannel.Result m_result;
        private int m_queryType;


        ArtistLoadTask(final MethodChannel.Result result, final ContentResolver resolver, final String selection,
                       final String[] selectionArgs, final String sortOrder, final int type) {
            super(selection, selectionArgs, sortOrder);

            m_resolver = resolver;
            m_result = result;
            m_queryType = type;
        }

        @Override
        protected void onPostExecute(List<Map<String, Object>> maps) {
            super.onPostExecute(maps);
            m_result.success(maps);
            m_result = null;
            m_resolver = null;
        }

        @Override
        protected List<Map<String, Object>> loadData(final String selection,
                                                     final String[] selectionArgs, final String sortOrder) {


            switch (m_queryType) {
                case ArtistLoader.QUERY_TYPE_DEFAULT:
                    return basicDataLoad(selection, selectionArgs, sortOrder);


                case ArtistLoader.QUERY_TYPE_GENRE_ARTISTS:
                    /// in this case the genre name comes from selection param
                    List<String> artistIds = loadArtistIdsGenre(selection);
                    int idCount = artistIds.size();

                    if (idCount > 0) {
                        if (idCount > 1) {
                            String[] args = artistIds.toArray(new String[idCount]);

                            String createdSelection = createMultipleValueSelectionArgs(
                                    MediaStore.Audio.Artists._ID, args);

                            return basicDataLoad(createdSelection, args,
                                    MediaStore.Audio.Artists.DEFAULT_SORT_ORDER);
                        } else {
                            return basicDataLoad(
                                    MediaStore.Audio.Artists._ID + " =?",
                                    new String[]{artistIds.get(0)},
                                    MediaStore.Audio.Artists.DEFAULT_SORT_ORDER);
                        }
                    }
                    return new ArrayList<>();
            }

            Cursor artistCursor = m_resolver.query(
                    MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI,
                    ArtistLoader.PROJECTION,
                    selection, selectionArgs, sortOrder);

            List<Map<String, Object>> list = new ArrayList<>();
            if (artistCursor != null) {

                while (artistCursor.moveToNext()) {
                    try {
                        Map<String, Object> map = new HashMap<>();
                        for (String artistColumn : PROJECTION) {
                            String data = artistCursor.getString(artistCursor.getColumnIndex(artistColumn));
                            map.put(artistColumn, data);
                        }
                        // some album artwork of this artist that can be used
                        // as artist cover picture if there is one.
                        map.put("artist_cover", getArtistArtPath((String) map.get(PROJECTION[1])));
                        list.add(map);
                    }
                    catch (Exception ex) {
                        Log.e(TAG_ERROR, "ArtistLoader::loadData method exception");
                        Log.e(TAG_ERROR, ex.getMessage());
                    }
                }

                artistCursor.close();
            }

            return list;
        }

        private List<Map<String, Object>> basicDataLoad(
                final String selection, final String[] selectionArgs, final String sortOrder) {
            Cursor artistCursor = m_resolver.query(
                    MediaStore.Audio.Artists.EXTERNAL_CONTENT_URI,
                    ArtistLoader.PROJECTION,
                    /*where clause*/selection,
                    /*where clause arguments */selectionArgs,
                    sortOrder);

            List<Map<String, Object>> list = new ArrayList<>();
            if (artistCursor != null) {

                while (artistCursor.moveToNext()) {
                    try {
                        Map<String, Object> map = new HashMap<>();
                        for (String artistColumn : PROJECTION) {
                            String data = artistCursor.getString(artistCursor.getColumnIndex(artistColumn));
                            map.put(artistColumn, data);
                        }
                        // some album artwork of this artist that can be used
                        // as artist cover picture if there is one.
                        map.put("artist_cover", getArtistArtPath((String) map.get(PROJECTION[1])));
                        //Log.i("MDGB", "getting: " +  (String) map.get(MediaStore.Audio.Media.ARTIST));
                        list.add(map);
                    }
                    catch (Exception ex) {
                        Log.e(TAG_ERROR, "ArtistLoader::basicDataLoad method exception");
                        Log.e(TAG_ERROR, ex.getMessage());
                    }

                }
                artistCursor.close();
            }

            return list;
        }

        /**
         * Method used to get some album artwork image path from an specific artist
         * and this image can be used as artist cover.
         *
         * @param artistName name of artist
         * @return Path String from some album from artist or null if there is no one.
         */
        private String getArtistArtPath(String artistName) {
            String artworkPath = null;

            Cursor artworkCursor = m_resolver.query(
                    MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    new String[]{
                            MediaStore.Audio.AlbumColumns.ALBUM_ART,
                            MediaStore.Audio.AlbumColumns.ARTIST
                    },

                    MediaStore.Audio.AlbumColumns.ARTIST + "=?",
                    new String[]{artistName},
                    MediaStore.Audio.Albums.DEFAULT_SORT_ORDER);

            if (artworkCursor != null) {
                //Log.i(TAG, "total paths " + artworkCursor.getCount());
                    while (artworkCursor.moveToNext()) {
                        try {
                            artworkPath = artworkCursor.getString(
                                    artworkCursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART)
                            );

                            // breaks in first valid path founded.
                            if (artworkPath != null)
                                break;
                        }
                        catch (Exception ex) {
                            Log.e(TAG_ERROR, "ArtistLoader::getArtistPath method exception");
                            Log.e(TAG_ERROR, ex.getMessage());
                        }
                    }
                //Log.i(TAG, "found path: " + artworkPath );
                artworkCursor.close();
            }

            return artworkPath;
        }

        /**
         * This methods query artist Id's filtered by a specific genre
         * in Media "TABLE".
         *
         * @param genreName genre name to filter artists.
         * @return List of strings with artist Id's
         */
        private List<String> loadArtistIdsGenre(final String genreName) {
            //Log.i("MDBG",  "Genero: " + genreName +" Artistas: ");
            List<String> artistsIds = new ArrayList<>();

            Cursor artistNamesCursor = m_resolver.query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    new String[]{"Distinct " + MediaStore.Audio.Media.ARTIST_ID, "genre_name"},
                    "genre_name" + " =?", new String[]{genreName}, null);

            if (artistNamesCursor != null) {

                while (artistNamesCursor.moveToNext()) {
                    try {
                        String artistName = artistNamesCursor.getString(artistNamesCursor.getColumnIndex(
                                MediaStore.Audio.Media.ARTIST_ID));

                        artistsIds.add(artistName);
                    }
                    catch (Exception ex) {
                        Log.e(TAG_ERROR, "ArtistLoader::loadArtistIdsGenre method exception");
                        Log.e(TAG_ERROR, ex.getMessage());
                    }
                }


                artistNamesCursor.close();
            }

            return artistsIds;
        }

    }
}
