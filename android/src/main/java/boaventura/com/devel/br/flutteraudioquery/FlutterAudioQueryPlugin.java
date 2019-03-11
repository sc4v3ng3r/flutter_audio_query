package boaventura.com.devel.br.flutteraudioquery;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;

import java.lang.reflect.Method;

import androidx.core.app.ActivityCompat;
import boaventura.com.devel.br.flutteraudioquery.loaders.AlbumLoader;
import boaventura.com.devel.br.flutteraudioquery.loaders.ArtistLoader;
import boaventura.com.devel.br.flutteraudioquery.loaders.SongLoader;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAudioQueryPlugin */
public class FlutterAudioQueryPlugin implements MethodCallHandler/*,
        PluginRegistry.RequestPermissionsResultListener*/  {
  /** Plugin registration. */

  private final Activity m_activity;
  private final ArtistLoader m_artistLoader;
  private final AlbumLoader m_albumLoader;
  private final SongLoader m_songLoader;

  private static final String CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";

  static final int REQUEST_READ_PERMISSION = 0x1;

  private FlutterAudioQueryPlugin(Registrar registrar){
    m_activity = registrar.activity();
    m_artistLoader = new ArtistLoader(registrar.context());
    m_albumLoader = new AlbumLoader(registrar.context());
    m_songLoader = new SongLoader( registrar.context() );
  }

  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null)
      return;

    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(new FlutterAudioQueryPlugin(registrar));

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      switch (call.method){
          case "getArtists":
              m_artistLoader.getArtists(result);
              break;

          case "getAlbums":
              m_albumLoader.getAlbums(result);
              break;

          case "getAlbumsFromArtist":
              String artist = call.argument("artist" );
              m_albumLoader.getAlbumsFromArtist(result, artist);
              break;

          case "getSongs":
              m_songLoader.getSongs(result);
              break;

          case "getSongsFromArtist":
              m_songLoader.getSongsFromArtist( result, (String) call.argument("artist" ) );
              break;

          case "getSongsFromAlbum":
              m_songLoader.getSongsFromAlbum( result, (String) call.argument("album_id" ) );
              break;

          default:
              result.notImplemented();
              break;
      }

  }
  /*
  private boolean isReadPermissionGranted(){
    /// if we already have permission
    return ActivityCompat.checkSelfPermission( m_registrar.context(),
            Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    boolean permissionGranted =
            grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;

    return false;
  }*/
}
