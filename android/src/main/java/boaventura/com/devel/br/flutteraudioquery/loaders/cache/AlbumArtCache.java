package boaventura.com.devel.br.flutteraudioquery.loaders.cache;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.net.Uri;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class AlbumArtCache {
    private static final String ALBUM_DIR = "albums";
    private static AlbumArtCache instance;

    public static String CAHCE_DIR = "";

    public static AlbumArtCache getInstance() {
        if (instance == null) {
            instance = new AlbumArtCache();
        }
        return instance;
    }

    private AlbumArtCache() {
    }

    public String getPathForAlbum(int albumId) {
        String path = Uri.parse(CAHCE_DIR).buildUpon()
                .appendPath(ALBUM_DIR)
                .build().toString();
        path += "/" + albumId + ".jpg";
        return path;
    }

    public String saveAlbumImage(ContentResolver resolver, int albumId) {
        Uri sArtworkUri = Uri
                .parse("content://media/external/audio/albumart");
        Uri albumArtUri = ContentUris.withAppendedId(sArtworkUri, albumId);

        try {
            InputStream inputStream = resolver.openInputStream(albumArtUri);
            File file = createFileForId(albumId);
            file.createNewFile();
            writeStreamToFile(inputStream, file);
            return file.getAbsolutePath();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void writeStreamToFile(InputStream inputStream, File file)
            throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream(file);
        while (inputStream.available() > 0) {
            fileOutputStream.write(inputStream.read());
        }
        fileOutputStream.close();
        inputStream.close();
    }

    private File createFileForId(int albumId) {

        createAlbumsDirectory();
        String path = Uri.parse(CAHCE_DIR).buildUpon().appendPath(ALBUM_DIR)
                .build().toString();
        path += "/" + albumId + ".jpg";
        File file = new File(path);

        if (file.exists()) {
            file.delete();
        }
        return file;
    }

    private void createAlbumsDirectory() {
        String path = Uri.parse(CAHCE_DIR).buildUpon().appendPath(ALBUM_DIR).build().toString();

        File file = new File(path);

        if (file.exists()) {
            return;
        }

        file.mkdirs();
    }

    public boolean artExists(int albumId) {
        String path = getPathForAlbum(albumId);
        File file = new File(path);
        return file.exists();
    }
}
