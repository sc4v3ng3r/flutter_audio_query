package boaventura.com.devel.br.flutteraudioqueryexample;

import io.flutter.app.FlutterActivity;
import android.os.Bundle;
import boaventura.com.devel.br.flutteraudioquery.FlutterAudioQueryPlugin;


public class V1Activity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterAudioQueryPlugin.registerWith(
                registrarFor("boaventura.com.devel.br.flutteraudioquery")
        );
    }
}