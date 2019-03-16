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

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import io.flutter.plugin.common.MethodChannel;

public abstract class AbstractLoader {
    private final ContentResolver m_resolver;
    static final int QUERY_TYPE_DEFAULT = 0x00;
    AbstractLoader(final Context context){
        m_resolver = context.getContentResolver();
    }

    final ContentResolver getContentResolver(){ return m_resolver; }

    /**
     * This method should create a new background task to run SQLite queries and return
     * the task.
     * @param result
     * @param selection
     * @param selectionArgs
     * @param sortOrder
     * @param type An integer number that can be used to identify what kind of task do you want
     *             to create.
     * @return
     */
    protected abstract AbstractLoadTask createLoadTask(final MethodChannel.Result result, final String selection,
                                         final String[] selectionArgs, String sortOrder, final int type );

}
