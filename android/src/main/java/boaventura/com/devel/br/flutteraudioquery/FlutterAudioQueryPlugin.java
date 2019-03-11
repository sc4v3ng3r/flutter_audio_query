package boaventura.com.devel.br.flutteraudioquery;

import android.util.Log;

import boaventura.com.devel.br.flutteraudioquery.delegate.AudioQueryDelegate;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAudioQueryPlugin */
public class FlutterAudioQueryPlugin implements MethodCallHandler/*,
        PluginRegistry.RequestPermissionsResultListener*/  {
  /** Plugin registration. */

  static final int REQUEST_READ_PERMISSION = 0x1;
  private static final String CHANNEL_NAME = "boaventura.com.devel.br.flutteraudioquery";
  private final AudioQueryDelegate m_delegate;



  private FlutterAudioQueryPlugin(AudioQueryDelegate delegate){
      m_delegate = delegate;
  }

  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null)
      return;

    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
    final AudioQueryDelegate delegate = new AudioQueryDelegate( registrar );

    channel.setMethodCallHandler(new FlutterAudioQueryPlugin(delegate));

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

      String source = call.argument("source");
      if (source != null ){

          switch (source){
              case "artist":
                  Log.i("MDBG", "onMethodCall:: calling artistSourceHandler");
                  m_delegate.artistSourceHandler(call, result);
                  break;

              case "album":
                  Log.i("MDBG", "onMethodCall:: calling albumSourceHandler");
                  m_delegate.albumSourceHandler(call, result);
                  break;

              case "song":
                  Log.i("MDBG", "onMethodCall:: calling songSourceHandler");
                  m_delegate.songSourceHandler(call, result);
                  break;

              case "genre":
                  result.notImplemented();
                  break;

              case "playlist":
                  result.notImplemented();
                  break;

                  default:
                      result.error("unknown_source",
                              "method call was made by an unknown source", null);
                      break;

          }
      }

      else {
          result.error("no_source", "There is no source in your method call", null);
      }

      /*
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
      }*/

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
