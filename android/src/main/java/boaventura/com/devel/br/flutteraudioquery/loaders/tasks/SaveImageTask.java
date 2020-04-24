package boaventura.com.devel.br.flutteraudioquery.loaders.tasks;

import android.content.ContentResolver;
import android.os.AsyncTask;

import boaventura.com.devel.br.flutteraudioquery.loaders.cache.AlbumArtCache;

public class SaveImageTask extends AsyncTask<Void,Void,Void> {
    ContentResolver resolver;
    int albumId;
    public SaveImageTask(ContentResolver resolver,int albumId){
        this.resolver = resolver;
        this.albumId = albumId;
    }

    @Override
    protected Void doInBackground(Void... voids) {
        AlbumArtCache.getInstance().saveAlbumImage(resolver,albumId);
        return null;
    }
}
