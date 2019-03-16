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
import io.flutter.plugin.common.MethodChannel;

public class GenreLoader extends AbstractLoader {

    private static final String[] GENRE_PROJECTION = {
            MediaStore.Audio.GenresColumns.NAME
    };

    public GenreLoader(Context context) {
        super(context);
    }

    @Override
    protected GenreLoadTask createLoadTask(
            final MethodChannel.Result result, final String selection,
            final String[] selectionArgs, final String sortOrder, final int type) {

        return new GenreLoadTask(result, getContentResolver(),
                selection, selectionArgs, sortOrder);
    }


    public void getGenres(final MethodChannel.Result result){
        createLoadTask(result, null, null, null,0).execute();
    }

    static class GenreLoadTask extends AbstractLoadTask<List<Map<String,Object>>>{

        /**
         * Constructor for AbstractLoadTask.
         *
         * @param selection     SQL selection param. WHERE clauses.
         * @param selectionArgs SQL Where clauses query values.
         * @param sortOrder     Ordering.
         */
        private MethodChannel.Result m_result;
        private ContentResolver m_resolver;

        GenreLoadTask(MethodChannel.Result result, ContentResolver resolver, String selection,
                      String[] selectionArgs, String sortOrder) {
            super(selection, selectionArgs, sortOrder);

            m_resolver = resolver;
            m_result = result;
        }

        @Override
        protected List<Map<String, Object>> loadData(String selection, String[] selectionArgs,
                                                     String sortOrder) {

            List<Map<String, Object>> dataList= new ArrayList<>();

            Cursor genreCursor = m_resolver.query(MediaStore.Audio.Genres.EXTERNAL_CONTENT_URI,
                    GENRE_PROJECTION, selection, selectionArgs, sortOrder);

            if (genreCursor != null){
                while ( genreCursor.moveToNext() ){
                    Map<String, Object> data = new HashMap<>();

                    for(String column : genreCursor.getColumnNames()){
                        data.put(column, genreCursor.getString(
                                genreCursor.getColumnIndex( column )));
                    }


                    dataList.add(data);
                }
                genreCursor.close();
            }

            return dataList;
        }

        @Override
        protected void onPostExecute(List<Map<String, Object>> data) {
            super.onPostExecute(data);
            m_result.success(data);
            m_result = null;
            m_resolver = null;
        }
    }
}