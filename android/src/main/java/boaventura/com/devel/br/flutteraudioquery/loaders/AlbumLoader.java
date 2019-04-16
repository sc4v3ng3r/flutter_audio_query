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
import boaventura.com.devel.br.flutteraudioquery.sortingtypes.AlbumSortType;
import io.flutter.plugin.common.MethodChannel;

public class AlbumLoader extends AbstractLoader {

    //private final ContentResolver m_resolver;
    private static final int QUERY_TYPE_GENRE_ALBUM = 0x01;

    private static final String[] ALBUM_PROJECTION = {
            MediaStore.Audio.AudioColumns._ID,
            MediaStore.Audio.AlbumColumns.ALBUM,
            MediaStore.Audio.AlbumColumns.ALBUM_ART,
            MediaStore.Audio.AlbumColumns.ARTIST,
            MediaStore.Audio.AlbumColumns.FIRST_YEAR,
            MediaStore.Audio.AlbumColumns.LAST_YEAR,
            MediaStore.Audio.AlbumColumns.NUMBER_OF_SONGS/*, MediaStore.Audio.AlbumColumns.ALBUM_ID*/
            //MediaStore.Audio.AlbumColumns.NUMBER_OF_SONGS_FOR_ARTIST,
    };

    private static final String[] ALBUM_MEDIA_PROJECTION = {
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.IS_MUSIC
    };

    public AlbumLoader(final Context context) {
        super(context);
    }


    private String parseSortOrder(AlbumSortType sortType){
        String sortOrder;

        switch (sortType){

            case LESS_SONGS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Albums.NUMBER_OF_SONGS + " ASC";
                break;

            case MORE_SONGS_NUMBER_FIRST:
                sortOrder = MediaStore.Audio.Albums.NUMBER_OF_SONGS + " DESC";
                break;

            case ALPHABETIC_ARTIST_NAME:
                sortOrder = MediaStore.Audio.Albums.ARTIST;
                break;

            case MOST_RECENT_YEAR:
                sortOrder = MediaStore.Audio.Albums.LAST_YEAR + " DESC";
                break;

            case OLDEST_YEAR:
                sortOrder = MediaStore.Audio.Albums.LAST_YEAR + " ASC";
                break;

            case DEFAULT:
            default:
                sortOrder = MediaStore.Audio.Albums.DEFAULT_SORT_ORDER;
                break;
        }
        return sortOrder;
    }

    /**
     * This method queries in background all albums available in device storage
     *
     * @param result MethodChannel results object to send to Dart side
     *               the query results.
     */
    public void getAlbums(MethodChannel.Result result, AlbumSortType sortType) {
        createLoadTask(result, null, null,
                parseSortOrder(sortType), 0).execute();
    }

    /**
     * @param result
     * @param albumId
     */
    public void getAlbumById(MethodChannel.Result result, long albumId) {
        createLoadTask(result, ALBUM_PROJECTION[0] + " = ? ",
                new String[]{String.valueOf(albumId)},
                MediaStore.Audio.Albums.DEFAULT_SORT_ORDER, 0).execute();
    }

    public void getAlbumFromGenre(final MethodChannel.Result result, final String genre,
                                  AlbumSortType sortType) {
        createLoadTask(result, genre, null,
                parseSortOrder(sortType), QUERY_TYPE_GENRE_ALBUM).execute();
    }

    /**
     * @param result
     * @param artistName
     */
    public void getAlbumsFromArtist(MethodChannel.Result result, String artistName, AlbumSortType sortType) {
        createLoadTask(result, ALBUM_PROJECTION[3] + " = ? ",
                new String[]{artistName}, parseSortOrder(sortType), 0).execute();
    }


    @Override
    protected AlbumLoadTask createLoadTask(
            final MethodChannel.Result result, final String selection,
            final String[] selectionArgs, final String sortOrder, final int type) {

        return new AlbumLoadTask(result, getContentResolver(), selection, selectionArgs,
                sortOrder, type);

    }


    static class AlbumLoadTask extends AbstractLoadTask<List<Map<String, Object>>> {

        private ContentResolver m_resolver;
        private MethodChannel.Result m_result;
        private int m_queryType;

        private AlbumLoadTask(final MethodChannel.Result result, ContentResolver resolver,
                              final String selection, final String[] selectionArgs,
                              final String sortOrder, final int type) {
            super(selection, selectionArgs, sortOrder);

            m_result = result;
            m_resolver = resolver;
            m_queryType = type;
        }

        private String createMultipleValueSelectionArgs( /*String column */String[] params) {

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(MediaStore.Audio.Albums._ID + " IN(?");

            for (int i = 0; i < (params.length - 1); i++)
                stringBuilder.append(",?");

            stringBuilder.append(')');
            return stringBuilder.toString();
        }

        @Override
        protected List<Map<String, Object>> loadData(
                final String selection, final String[] selectionArgs,
                final String sortOrder) {

            switch (m_queryType) {
                case QUERY_TYPE_DEFAULT:
                    return this.basicDataLoad(selection, selectionArgs, sortOrder);

                case QUERY_TYPE_GENRE_ALBUM:
                    List<String> albumsFromGenre = getAlbumNamesFromGenre(selection);
                    int idCount = albumsFromGenre.size();

                    if (idCount > 0) {
                        if (idCount > 1) {
                            String[] params = albumsFromGenre.toArray(new String[idCount]);
                            String createdSelection = createMultipleValueSelectionArgs(params);

                            return basicDataLoad(createdSelection, params,
                                    MediaStore.Audio.Albums.DEFAULT_SORT_ORDER);
                        } else {
                            return basicDataLoad(
                                    MediaStore.Audio.Albums._ID + " =?",
                                    new String[]{albumsFromGenre.get(0)},
                                    MediaStore.Audio.Artists.DEFAULT_SORT_ORDER);
                        }
                    }

                default:
                    break;
            }

            return new ArrayList<>();
        }


        private List<Map<String, Object>> basicDataLoad(final String selection, final String[] selectionArgs,
                                                        final String sortOrder) {

            List<Map<String, Object>> dataList = new ArrayList<>();

            Cursor cursor = m_resolver.query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    ALBUM_PROJECTION, selection, selectionArgs, sortOrder);

            if (cursor != null) {

                //Sometimes the relationship album -> artist in Album "TABLE" are missing and I really
                //don't know why but I saw this happen in API level 19.So as work around, when we can't get
                //albums from a specific artist querying the Album "TABLE" doing something like
                //SELECT * FROM ALBUM WHERE artistName = "AndroidxRockAndRoll";
                //we go to Media "TABLE"to  get name and id of the albums from an specific
                //artist and then we query all album info from Album "TABLE".

                //It's not the best way to do this, but we get the results.

                if (cursor.getCount() == 0) {
                    cursor.close();
                    dataList = loadAlbumsInfoWithMediaSupport(selectionArgs[0]);
                } else {
                    while (cursor.moveToNext()) {
                        try {
                            Map<String, Object> dataMap = new HashMap<>();
                            for (String albumColumn : ALBUM_PROJECTION) {
                                String value = cursor.getString(cursor.getColumnIndex(albumColumn));
                                dataMap.put(albumColumn, value);
                                //Log.i(TAG, albumColumn + ": " + value);
                            }
                            dataList.add(dataMap);
                        } catch (Exception ex) {
                            Log.e("ERROR", "AlbumLoader::basicLoad", ex);
                            Log.e("ERROR", "while reading basic load cursor");
                        }

                    }
                }
                cursor.close();
            }
            return dataList;
        }

        private List<String> getAlbumNamesFromGenre(final String genre) {
            List<String> albumNames = new ArrayList<>();

            Cursor albumNamesCursor = m_resolver.query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    new String[]{"Distinct " + MediaStore.Audio.Media.ALBUM_ID, "genre_name"},
                    "genre_name" + " =?", new String[]{genre}, null);

            if (albumNamesCursor != null) {

                while (albumNamesCursor.moveToNext()) {
                    try {
                        String albumName = albumNamesCursor.getString(albumNamesCursor.getColumnIndex(
                                MediaStore.Audio.Media.ALBUM_ID));
                        albumNames.add(albumName);
                    } catch (Exception ex) {
                        Log.e("ERROR", "AlbumLoader::getAlbumNamesFromGenre", ex);
                    }

                }
                albumNamesCursor.close();

            }

            return albumNames;
        }

        private List<Map<String, Object>> loadAlbumsInfoWithMediaSupport(final String artistName) {

            List<Map<String, Object>> dataList = new ArrayList<>();

            // we get albums from an specific artist
            Cursor artistAlbumsCursor = m_resolver.query(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    ALBUM_MEDIA_PROJECTION,
                    MediaStore.Audio.Albums.ARTIST + "=?" + " and "
                            + MediaStore.Audio.Media.IS_MUSIC + "!=?"
                            + ") GROUP BY (" + MediaStore.Audio.Albums.ALBUM,
                    new String[]{artistName, "1"},
                    MediaStore.Audio.Media.DEFAULT_SORT_ORDER);

            if (artistAlbumsCursor != null) {
                ///TODO tem que ter try catch
                String albumId = artistAlbumsCursor.getString(
                        artistAlbumsCursor.getColumnIndex(ALBUM_MEDIA_PROJECTION[0]));

                // for earch album from desired artist we get all album info needed
                // from Album "TABLE"
                while (artistAlbumsCursor.moveToNext()) {

                    Cursor albumDataCursor = m_resolver.query(
                            MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                            ALBUM_PROJECTION,
                            MediaStore.Audio.Albums._ID + "=?",
                            new String[]{albumId},
                            MediaStore.Audio.Albums.DEFAULT_SORT_ORDER);

                    if (albumDataCursor != null) {

                        while (albumDataCursor.moveToNext()) {
                            try {
                                Map<String, Object> albumData = new HashMap<>();
                                for (String albumColumn : ALBUM_PROJECTION)
                                    albumData.put(albumColumn, albumDataCursor.
                                            getString(albumDataCursor.getColumnIndex(albumColumn)));

                                dataList.add(albumData);
                            }
                            catch (Exception ex) {
                                Log.e("ERROR", "AlbumLoader::loadAlbumsInfoWithMediaSupport", ex);
                            }
                        }
                        albumDataCursor.close();
                    }

                }

                artistAlbumsCursor.close();
            }

            return dataList;
        }

        @Override
        protected void onPostExecute(List<Map<String, Object>> data) {
            super.onPostExecute(data);
            m_resolver = null;
            m_result.success(data);
            m_result = null;
        }

    }
}
