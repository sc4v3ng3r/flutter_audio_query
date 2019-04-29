//The MIT License
//
//        Copyright (C) <2019>  <Marcos Antonio Boaventura Feitoza> <scavenger.gnu@gmail.com>
//
//        Permission is hereby granted, free of charge, to any person obtaining a copy
//        of this software and associated documentation files (the "Software"), to deal
//        in the Software without restriction, including without limitation the rights
//        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//        copies of the Software, and to permit persons to whom the Software is
//        furnished to do so, subject to the following conditions:
//
//        The above copyright notice and this permission notice shall be included in
//        all copies or substantial portions of the Software.
//
//        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//        THE SOFTWARE.
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
    channel.setMethodCallHandler( new FlutterAudioQueryPlugin(delegate) );
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
                  m_delegate.playlistSourceHandler(call, result);
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
