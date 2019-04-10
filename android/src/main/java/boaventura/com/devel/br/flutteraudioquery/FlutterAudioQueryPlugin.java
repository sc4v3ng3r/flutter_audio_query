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

package boaventura.com.devel.br.flutteraudioquery;


import boaventura.com.devel.br.flutteraudioquery.delegate.AudioQueryDelegate;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAudioQueryPlugin */
public class FlutterAudioQueryPlugin implements MethodCallHandler {

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
                  m_delegate.artistSourceHandler(call, result);
                  break;

              case "album":
                  m_delegate.albumSourceHandler(call, result);
                  break;

              case "song":
                  m_delegate.songSourceHandler(call, result);
                  break;

              case "genre":
                  m_delegate.genreSourceHandler(call, result);
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
  }

}
