package boaventura.com.devel.br.flutteraudioquery.loaders;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import io.flutter.plugin.common.MethodChannel;


public class PlaylistLoader extends AbstractLoader {

    public enum PlayListMethodType { READ, WRITE }

    private static final String[] PLAYLIST_PROJECTION = {
            MediaStore.Audio.Playlists._ID,
            MediaStore.Audio.Playlists.NAME,
            MediaStore.Audio.Playlists.DATA,
            MediaStore.Audio.Playlists._COUNT,
            MediaStore.Audio.Playlists.DATE_ADDED,// creation data,
    };

    private static final String[] PLAYLIST_MEMBERS_PROJECTION = {
            MediaStore.Audio.Playlists.Members.AUDIO_ID,
    };

    public PlaylistLoader(Context context) {
        super(context);
    }


    public void getPlaylists(final MethodChannel.Result result){
        createLoadTask(result,null,null,
                MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER,0).execute();
    }

    public void getPlaylistById(final MethodChannel.Result result, final String playlistId){
        createLoadTask(result, MediaStore.Audio.Playlists._ID, new String[]{playlistId},
                MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER, 0).execute();
    }

    public void createPlaylist(final MethodChannel.Result results, final String name) {
        if (name != null && name.length() > 0) {
            ContentResolver resolver = getContentResolver();
            final String selection =  PLAYLIST_PROJECTION[1] + " = '" + name + "'";

            if ( !verifyPlaylistExistence(new String[]{ PLAYLIST_PROJECTION[1] }, selection, null) ){
                ContentValues values = new ContentValues();
                values.put(PLAYLIST_PROJECTION[1], name);

                try {
                    Uri uri = resolver.insert(MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI, values);

                    Cursor cursor = resolver.query(
                            uri, PLAYLIST_PROJECTION, null, null,
                            MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER);

                    if (cursor!= null){
                        Map<String, Object> data = new HashMap<>();

                        while ( cursor.moveToNext() ){
                            try{
                                for (String key : PLAYLIST_PROJECTION) {
                                    data.put(key, cursor.getString( cursor.getColumnIndex( key )));
                                }
                            }

                            catch(Exception ex){
                                Log.i(TAG_ERROR, "PlaylistLoader::createPlaylist" + ex.getMessage());
                                results.error("Something wrong in new playlist reading", ex.getMessage(), ex);
                            }
                        }

                        results.success(data);
                        cursor.close();
                    }
                }

                catch (Exception ex){
                    Log.i(TAG_ERROR, "PlaylistLoader::createPlaylist " + ex.getMessage(), ex);
                    results.error("Was not possible create a new playlist", ex.getMessage(), ex);
                }
            }

            else
                results.error("Playlist named " + name + " already exists" ,
                        "", new Exception("Already exist a playlist named " + name));
        }

        else {
            results.error("Playlist name can't be null or empty",
                    "", new Exception("INVALID PLAYLIST NAME"));
        }

    }

    public void addSongToPlaylist(final MethodChannel.Result results, final String playlistId,
                                  final String songId){

        Uri playlistUri = MediaStore.Audio.Playlists.Members.getContentUri("external",
                Long.parseLong(playlistId));

        int base = getBase(playlistUri);

        if (base != -1){
            ContentResolver resolver = getContentResolver();
            ContentValues values = new ContentValues();
            values.put(MediaStore.Audio.Playlists.Members.AUDIO_ID, songId);
            values.put(MediaStore.Audio.Playlists.Members.PLAY_ORDER, base);
            resolver.insert(playlistUri, values);
            resolver.notifyChange(Uri.parse("content://media"), null);
            getPlaylistById(results, playlistId);
        }

        else {
            results.error("Error adding song to playlist", "base value " + base,
                    new Exception("Error adding song to playlist | base value " + base));
        }
    }

    public void removeSongFromPlaylist(final MethodChannel.Result results, final String playlistId,
                                       final String songId){

        if (playlistId != null && songId != null){
            final String selection = PLAYLIST_PROJECTION[0] + " = '" + playlistId + "'";
            if ( !verifyPlaylistExistence( new String[]{PLAYLIST_PROJECTION[0]}, selection, null )){
                Log.i("MDBG", "removeSongFromPlaylist::can't remove data on this playlist");
                results.error("Unavailable playlist", "", null);
                return;
            }

            ContentResolver resolver = getContentResolver();
            Uri uri = MediaStore.Audio.Playlists.Members.getContentUri("external",
                    Long.parseLong(playlistId ) );

            int deletedRows = resolver.delete(uri, MediaStore.Audio.Playlists.Members.AUDIO_ID + " ? ",
                    new String[]{ songId } );

            if (deletedRows > 0 ){
                Log.i("MDBG", "removeSongFromPlaylist::After call delete playlist");
                resolver.notifyChange(Uri.parse("content://media"), null);
                getPlaylistById(results, playlistId);
            }

            else results.error("Was not possible delete song data from this playlist","",null);
        }

        else {
            results.error("Error removing song from playlist", "",
                    new Exception("playlist or song can't be null"));
        }
    }

    private int getBase(final Uri playlistUri){
        String[] col = new String[]{ "cols(*)"};
        int base = -1;

        Cursor cursor = getContentResolver().query(playlistUri, col, null,null,null );
        if (cursor != null){
            cursor.moveToNext();
            base = cursor.getInt(0);
            Log.i("MDBG", "Current playlist base " + base );
            base +=1;
            cursor.close();
        }
        return base;
    }



    private boolean verifyPlaylistExistence(final String[] projection, final String selection, final String[] args){
        boolean flag = false;
        Cursor cursor = getContentResolver().query(MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI,
                projection, selection, args, null);

        if ( (cursor!=null) && (cursor.getCount() > 0) ){
            flag = true;
            cursor.close();
        }
        return flag;
    }

    @Override
    protected PlaylistLoadTask createLoadTask(
            MethodChannel.Result result, String selection, String[] selectionArgs, String sortOrder, int type) {

        return new PlaylistLoadTask(result, getContentResolver(), selection, selectionArgs,
                MediaStore.Audio.Playlists.DEFAULT_SORT_ORDER);
    }

    static class PlaylistLoadTask extends AbstractLoadTask< List<Map<String, Object>> >{
        private ContentResolver m_resolver;
        private MethodChannel.Result m_result;


        /**
         * Constructor for AbstractLoadTask.
         *
         * @param selection     SQL selection param. WHERE clauses.
         * @param selectionArgs SQL Where clauses query values.
         * @param sortOrder     Ordering.
         */
         PlaylistLoadTask(final MethodChannel.Result result, final ContentResolver resolver,
                                String selection, String[] selectionArgs, String sortOrder) {
            super(selection, selectionArgs, sortOrder);

            m_resolver = resolver;
            m_result = result;
        }

        @Override
        protected List<Map<String, Object>> loadData(String selection, String[] selectionArgs, String sortOrder) {
            Cursor cursor = m_resolver.query(MediaStore.Audio.Playlists.EXTERNAL_CONTENT_URI,
                    PLAYLIST_PROJECTION, selection, selectionArgs, sortOrder);

            List<Map<String,Object>> dataList = new ArrayList<>();

            if (cursor != null){
                while (cursor.moveToNext()){
                    try {
                        Map<String,Object> playlistData = new HashMap<>();
                        for (String key : PLAYLIST_PROJECTION){
                            String data = cursor.getString( cursor.getColumnIndex( key ));
                            Log.d("MDBG"," READING " + key + " : " + data );
                            playlistData.put(key, data );
                        }

                        playlistData.put("memberIds", getPlaylistMembers(
                                Long.parseLong( (String)playlistData.get(PLAYLIST_PROJECTION[0]))) );

                        dataList.add(playlistData);
                    }
                    catch (Exception ex){
                        Log.e(TAG_ERROR, "PlaylistLoader::loadData method exception");
                        Log.e(TAG_ERROR, ex.getMessage());
                    }
                }
                cursor.close();
            }
            return dataList;
        }

        @Override
        protected void onPostExecute(List<Map<String, Object>> maps) {
            super.onPostExecute(maps);
            m_result.success(maps);
            m_result = null;
            m_resolver = null;
        }

        private List<String> getPlaylistMembers(final long playlistId){
             Cursor membersCursor = m_resolver.query(MediaStore.Audio.Playlists.Members.getContentUri(
                     "external", playlistId),
                     PLAYLIST_MEMBERS_PROJECTION,
                     null,
                     null,
                     MediaStore.Audio.Playlists.Members.PLAY_ORDER,
                     null );

             List<String> memberIds = new ArrayList<>();

             if (membersCursor != null){

                 while ( membersCursor.moveToNext() ){
                     try{
                         memberIds.add( membersCursor.getString(
                                 membersCursor.getColumnIndex(PLAYLIST_MEMBERS_PROJECTION[0])) );
                     }
                     catch (Exception ex){
                         Log.e(TAG_ERROR, "PlaylistLoader::getPlaylistMembers method exception");
                         Log.e(TAG_ERROR, ex.getMessage());
                     }
                 }

                 membersCursor.close();
             }
             return memberIds;
         }
    }
}
