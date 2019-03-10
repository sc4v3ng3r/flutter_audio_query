package boaventura.com.devel.br.flutteraudioquery.loaders;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import io.flutter.plugin.common.MethodChannel;

public class AlbumLoader {

    private final ContentResolver m_resolver;

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

    public AlbumLoader(final Context context){
        m_resolver = context.getContentResolver();
    }

    /**
     * This method queries in background all albums available in device storage
     * @param result MethodChannel results object to send to Dart side
     *               the query results.
     */
    public void getAlbums(MethodChannel.Result result){
        createLoadTask(result,null, null,
                MediaStore.Audio.Artists.DEFAULT_SORT_ORDER).execute();
    }

    /**
     *
     * @param result
     * @param albumId
     */
    public void getAlbumById(MethodChannel.Result result, long albumId){
        createLoadTask(result, ALBUM_PROJECTION[0] + " = ? ",
                new String[] { String.valueOf(albumId) },
                MediaStore.Audio.Albums.DEFAULT_SORT_ORDER ).execute();
    }

    /**
     *
     * @param result
     * @param artistName
     */
    public void getAlbumsFromArtist(MethodChannel.Result result, String artistName){
        createLoadTask(result,ALBUM_PROJECTION[3] + " = ? ",
                new String[] { artistName }, MediaStore.Audio.Albums.DEFAULT_SORT_ORDER ).execute();
    }

    private AlbumLoadTask createLoadTask(final MethodChannel.Result result,  final String selection,
                                         final String[] selectionArgs, String sortOrder){


        return new AlbumLoadTask(result,m_resolver, selection, selectionArgs, sortOrder);
    }


    static class AlbumLoadTask extends AbstractLoadTask< List<Map<String,Object>> >{

        private ContentResolver m_resolver;
        private MethodChannel.Result m_result;

        private AlbumLoadTask(final MethodChannel.Result result, ContentResolver resolver,
                             final String selection, final String[] selectionArgs, String sortOrder){
            super(selection, selectionArgs,sortOrder);

            m_result = result;
            m_resolver = resolver;
        }

        @Override
        protected List< Map<String,Object> > loadData(
                final String selection, final String [] selectionArgs,
                final String sortOrder ){

            List< Map<String,Object> > dataList = new ArrayList<>();

            Cursor cursor = m_resolver.query( MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    ALBUM_PROJECTION, selection, selectionArgs, sortOrder );

            if  ( cursor != null ){
            /*
              Sometimes the relationship album -> artist in Album "TABLE" are missing and I really
              don't know why but I saw this happen in API level 19.So as work around, when we can't get
              albums from a specific artist querying the Album "TABLE" doing something like
              SELECT * FROM ALBUM WHERE artistName = "AndroidxRockAndRoll";
              we go to Media "TABLE"to  get name and id of the albums from an specific
              artist and then we query all album info from Album "TABLE".

              It's not the best way to do this, but we get the results.
             */
                if (cursor.getCount() == 0){
                    cursor.close();
                    dataList = loadAlbumsInfoWithMediaSupport( selectionArgs[0] );
                }

                else {
                    //Log.i(TAG, "TOTAL ALBUMS: " + cursor.getCount() );
                    while ( cursor.moveToNext() ){
                        Map<String, Object> dataMap = new HashMap<>();
                        for (String albumColumn : ALBUM_PROJECTION) {
                            String value = cursor.getString(cursor.getColumnIndex(albumColumn));
                            dataMap.put(albumColumn, value);
                            //Log.i(TAG, albumColumn + ": " + value);
                        }
                        dataList.add( dataMap );
                    }
                }
                cursor.close();
            }
            return dataList;
        }

        private List<Map<String, Object>> loadAlbumsInfoWithMediaSupport(final String artistName){

            List<Map<String,Object>> dataList = new ArrayList<>();

            // we get albums from an specific artist
            Cursor artistAlbumsCursor = m_resolver.query(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    ALBUM_MEDIA_PROJECTION,
                    MediaStore.Audio.Albums.ARTIST +"=?" + " and "
                            + MediaStore.Audio.Media.IS_MUSIC + "!=?"
                            + ") GROUP BY (" + MediaStore.Audio.Albums.ALBUM,
                    new String[] { artistName, "0" },
                    MediaStore.Audio.Media.DEFAULT_SORT_ORDER );

            if ( artistAlbumsCursor != null ){
                String albumId = artistAlbumsCursor.getString(
                        artistAlbumsCursor.getColumnIndex( ALBUM_MEDIA_PROJECTION [0]) );

                // for earch album from desired artist we get all album info needed
                // from Album "TABLE"
                while( artistAlbumsCursor.moveToNext() ){

                    Cursor albumDataCursor = m_resolver.query(
                            MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                            ALBUM_PROJECTION,
                            MediaStore.Audio.Albums._ID + "=?",
                            new String[] { albumId },
                            MediaStore.Audio.Albums.DEFAULT_SORT_ORDER );

                    if ( albumDataCursor != null ){

                        while( albumDataCursor.moveToNext() ){
                            Map<String, Object> albumData = new HashMap<>();

                            for (String albumColumn : ALBUM_PROJECTION)
                                albumData.put(albumColumn, albumDataCursor.
                                        getString( albumDataCursor.getColumnIndex( albumColumn) ) );

                            dataList.add( albumData );
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
