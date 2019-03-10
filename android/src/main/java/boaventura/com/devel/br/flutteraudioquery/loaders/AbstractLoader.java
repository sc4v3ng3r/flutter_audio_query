package boaventura.com.devel.br.flutteraudioquery.loaders;

import android.content.ContentResolver;
import android.content.Context;

import boaventura.com.devel.br.flutteraudioquery.loaders.tasks.AbstractLoadTask;
import io.flutter.plugin.common.MethodChannel;

public abstract class AbstractLoader {
    private final ContentResolver m_resolver;

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
     * @return
     */
    protected abstract AbstractLoadTask createLoadTask(final MethodChannel.Result result, final String selection,
                                         final String[] selectionArgs, String sortOrder);

}
