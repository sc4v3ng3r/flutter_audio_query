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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import io.flutter.plugin.common.MethodChannel;

public class SongLoader extends AbstractLoader {

    //final private ContentResolver m_resolver;
    private static final String TAG = "MDBG";
    private static final String GENRE_NAME = "genre_name";

    private static final int QUERY_TYPE_GENRE_SONGS = 0x01;

    //private static final String MOST_PLAYED = "most_played"; //undocumented column
    //private static final String RECENTLY_PLAYED = "recently_played"; // undocumented column

    private static final String[] SONG_ALBUM_PROJECTION = {
            MediaStore.Audio.AlbumColumns.ALBUM,
            MediaStore.Audio.AlbumColumns.ALBUM_ART
    };

    private static final String[] SONG_PROJECTION = {
            MediaStore.Audio.Media._ID,// row id
            MediaStore.Audio.Media.ALBUM_ID,
            MediaStore.Audio.Media.ARTIST_ID,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            GENRE_NAME,
            MediaStore.Audio.Media.IS_MUSIC,
            MediaStore.Audio.Media.IS_PODCAST,
            MediaStore.Audio.Media.IS_RINGTONE,
            MediaStore.Audio.Media.IS_ALARM,
            MediaStore.Audio.Media.IS_NOTIFICATION,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.COMPOSER,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.TRACK,
            MediaStore.Audio.Media.DURATION, // duration of the audio file in ms
            MediaStore.Audio.Media.BOOKMARK, // position, in ms, where playback was at in last stopped
            MediaStore.Audio.Media.DATA, // file data path
            MediaStore.Audio.Media.SIZE, // string with file size in bytes

    };

    public SongLoader(final Context context){
        super(context);
    }


    public void getSongs( final MethodChannel.Result result ){
        createLoadTask( result,null,null,
                MediaStore.Audio.Media.DEFAULT_SORT_ORDER,QUERY_TYPE_DEFAULT).execute();
    }


    public void getSongsFromAlbum(final MethodChannel.Result result, final String albumId){
       createLoadTask( result, MediaStore.Audio.Media.ALBUM_ID + " =? ",
                new String[] {albumId},
               MediaStore.Audio.Media.DEFAULT_SORT_ORDER,QUERY_TYPE_DEFAULT ).execute();
    }


    public void getSongsFromArtist(final MethodChannel.Result result, final String artistName){
        createLoadTask(result, MediaStore.Audio.Media.ARTIST + " =? ",
                new String[] { artistName }, MediaStore.Audio.Media.DEFAULT_SORT_ORDER,QUERY_TYPE_DEFAULT )
                .execute();
    }

    public void getSongsFromGenre(final MethodChannel.Result result, final String genre){
        createLoadTask(result, genre, null,
                MediaStore.Audio.Media.DEFAULT_SORT_ORDER, QUERY_TYPE_GENRE_SONGS )
                .execute();
    }

    @Override
    protected SongTaskLoad createLoadTask(MethodChannel.Result result, final String selection, final String [] selectionArgs,
                                final String sortOrder, final int type){

        return new SongTaskLoad(result, getContentResolver(), selection, selectionArgs, sortOrder, type);

    }

    private static class SongTaskLoad extends AbstractLoadTask< List< Map<String,Object> > > {
        private MethodChannel.Result m_result;
        private ContentResolver m_resolver;
        private int m_queryType;

        /**
         *
         * @param result
         * @param m_resolver
         * @param selection
         * @param selectionArgs
         * @param sortOrder
         */
        SongTaskLoad(MethodChannel.Result result, ContentResolver m_resolver, String selection,
                     String[] selectionArgs, String sortOrder, int type){

            super(selection, selectionArgs, sortOrder);
            this.m_resolver = m_resolver;
            this.m_result =result;
            this.m_queryType = type;
        }

        @Override
        protected void onPostExecute(List<Map<String, Object>> map) {
            super.onPostExecute(map);
            m_result.success(map);
            this.m_resolver = null;
            this.m_result = null;
        }

        @Override
        protected List< Map<String,Object> > loadData(
                final String selection, final String [] selectionArgs,
                final String sortOrder ){

            switch (m_queryType){
                case QUERY_TYPE_DEFAULT:
                    return  basicLoad(selection, selectionArgs, sortOrder);


                case QUERY_TYPE_GENRE_SONGS:
                    List<String> songIds = getSongIdsFromGenre(selection);
                    int idCount = songIds.size();
                    if ( idCount > 0){

                        if (idCount > 1 ){
                            String[] args = songIds.toArray( new String[idCount] );
                            String createdSelection = createMultipleValueSelectionArgs(args);
                            return  basicLoad(
                                    createdSelection,
                                    args,MediaStore.Audio.Media.DEFAULT_SORT_ORDER );
                        }

                        else {
                            return basicLoad(MediaStore.Audio.Media._ID + " =?",
                                    new String[]{ songIds.get(0)},
                                    MediaStore.Audio.Media.DEFAULT_SORT_ORDER );
                        }
                    }
                    break;

                default:
                    break;
            }

            return new ArrayList<>();
            /*
            List< Map<String, Object> > dataList = new ArrayList<>();

            Cursor songsCursor = m_resolver.query(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    SongLoader.SONG_PROJECTION, selection, selectionArgs, sortOrder );

            if (songsCursor != null){
                Map<String,String> albumArtMap = new HashMap<>();

                while( songsCursor.moveToNext() ){

                    Map<String, Object> songData = new HashMap<>();
                    for (String column: songsCursor.getColumnNames())
                        songData.put(column, songsCursor.getString( songsCursor.getColumnIndex( column )) );

                    String albumKey = songsCursor.getString(
                            songsCursor.getColumnIndex( SONG_PROJECTION[4] ));

                    String artPath = null;
                    if (!albumArtMap.containsKey(albumKey) ){

                        artPath = getAlbumArtPathForSong(albumKey);
                        albumArtMap.put(albumKey,artPath );

                        Log.i("MDBG", "song for album  " + albumKey + "adding path: " + artPath);
                    }

                    artPath = albumArtMap.get(albumKey);
                    songData.put("album_artwork", artPath);

                    dataList.add( songData );
                }

                songsCursor.close();
            }

            return dataList;*/
        }

        private String createMultipleValueSelectionArgs( /*String column */String[] params){

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.append(MediaStore.Audio.Media._ID + " IN(?" );

            for(int i=0; i < (params.length-1); i++)
                stringBuilder.append(",?");

            stringBuilder.append(')');
            return stringBuilder.toString();
        }

        private List<String> getSongIdsFromGenre(final String genre){
           Cursor songIdsCursor = m_resolver.query(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    new String[] {"Distinct " + MediaStore.Audio.Media._ID, "genre_name" },
                    "genre_name" + " =?",new String[] {genre},null);

           List<String> songIds = new ArrayList<>();

           if (songIdsCursor != null){

               while ( songIdsCursor.moveToNext() ){
                   String id = songIdsCursor.getString( songIdsCursor.getColumnIndex( MediaStore.Audio.Media._ID));
                   songIds.add(id);
               }
               songIdsCursor.close();
           }

           return songIds;
        }

        private List<Map<String,Object>> basicLoad(final String selection, final String[] selectionArgs,
                                                   final String sortOrder){

            List< Map<String, Object> > dataList = new ArrayList<>();

            Cursor songsCursor = m_resolver.query(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    SongLoader.SONG_PROJECTION, selection, selectionArgs, sortOrder );

            if (songsCursor != null){
                Map<String,String> albumArtMap = new HashMap<>();

                while( songsCursor.moveToNext() ){

                    Map<String, Object> songData = new HashMap<>();
                    for (String column: songsCursor.getColumnNames())
                        songData.put(column, songsCursor.getString( songsCursor.getColumnIndex( column )) );

                    String albumKey = songsCursor.getString(
                            songsCursor.getColumnIndex( SONG_PROJECTION[4] ));

                    String artPath;
                    if (!albumArtMap.containsKey(albumKey) ){

                        artPath = getAlbumArtPathForSong(albumKey);
                        albumArtMap.put(albumKey,artPath );

                        //Log.i("MDBG", "song for album  " + albumKey + "adding path: " + artPath);
                    }

                    artPath = albumArtMap.get(albumKey);
                    songData.put("album_artwork", artPath);

                    dataList.add( songData );
                }

                songsCursor.close();
            }

            return dataList;
        }

        private String getAlbumArtPathForSong(String album){
            Cursor artCursor = m_resolver.query(
                    MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    SONG_ALBUM_PROJECTION,
                    SONG_ALBUM_PROJECTION[0] +  " =?",
                    new String[] {album},
                    null);

            String artPath = null;

            if (artCursor !=null){
                while (artCursor.moveToNext())
                    artPath = artCursor.getString( artCursor.getColumnIndex( SONG_ALBUM_PROJECTION[1]));
                artCursor.close();
            }

            return artPath;
        }
    }
}


/*
 *  NON DOCUMENTED MEDIA COLUMNS
 *
 * album_artist
 * duration
 * genre_name
 * recently_played
 * most_played
 *
 */

/*
 *          ALL MEDIA COLUMNS
 *
 * I/MDBG    (15056): Column: _id
 * I/MDBG    (15056): Column: _data
 * I/MDBG    (15056): Column: _display_name
 * I/MDBG    (15056): Column: _size
 * I/MDBG    (15056): Column: mime_type
 * I/MDBG    (15056): Column: date_added
 * I/MDBG    (15056): Column: is_drm
 * I/MDBG    (15056): Column: date_modified
 * I/MDBG    (15056): Column: title
 * I/MDBG    (15056): Column: title_key
 * I/MDBG    (15056): Column: duration
 * I/MDBG    (15056): Column: artist_id
 * I/MDBG    (15056): Column: composer
 * I/MDBG    (15056): Column: album_id
 * I/MDBG    (15056): Column: track
 * I/MDBG    (15056): Column: year
 * I/MDBG    (15056): Column: is_ringtone
 * I/MDBG    (15056): Column: is_music
 * I/MDBG    (15056): Column: is_alarm
 * I/MDBG    (15056): Column: is_notification
 * I/MDBG    (15056): Column: is_podcast
 * I/MDBG    (15056): Column: bookmark
 * I/MDBG    (15056): Column: album_artist
 * I/MDBG    (15056): Column: is_sound
 * I/MDBG    (15056): Column: year_name
 * I/MDBG    (15056): Column: genre_name
 * I/MDBG    (15056): Column: recently_played
 * I/MDBG    (15056): Column: most_played
 * I/MDBG    (15056): Column: recently_added_remove_flag
 * I/MDBG    (15056): Column: is_favorite
 * I/MDBG    (15056): Column: bucket_id
 * I/MDBG    (15056): Column: bucket_display_name
 * I/MDBG    (15056): Column: recordingtype
 * I/MDBG    (15056): Column: latitude
 * I/MDBG    (15056): Column: longitude
 * I/MDBG    (15056): Column: addr
 * I/MDBG    (15056): Column: langagecode
 * I/MDBG    (15056): Column: is_secretbox
 * I/MDBG    (15056): Column: is_memo
 * I/MDBG    (15056): Column: label_id
 * I/MDBG    (15056): Column: weather_ID
 * I/MDBG    (15056): Column: sampling_rate
 * I/MDBG    (15056): Column: bit_depth
 * I/MDBG    (15056): Column: recorded_number
 * I/MDBG    (15056): Column: recording_mode
 * I/MDBG    (15056): Column: is_ringtone_theme
 * I/MDBG    (15056): Column: is_notification_theme
 * I/MDBG    (15056): Column: is_alarm_theme
 * I/MDBG    (15056): Column: datetaken
 * I/MDBG    (15056): Column: artist_id:1
 * I/MDBG    (15056): Column: artist_key
 * I/MDBG    (15056): Column: artist
 * I/MDBG    (15056): Column: album_id:1
 * I/MDBG    (15056): Column: album_key
 * I/MDBG    (15056): Column: album
 *
 *
 */
