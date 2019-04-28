import 'package:flutter/material.dart';
import 'package:flutter_audio_query_example/src/bloc/ApplicationBloc.dart';
import 'package:flutter_audio_query_example/src/bloc/BlocProvider.dart';
import 'package:flutter_audio_query_example/src/ui/screens/MainScreen.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  final MainScreenBloc bloc = MainScreenBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Audio Query",
      home: BlocProvider(
        bloc: bloc,
        child: MainScreen(),
      ),
    );
  }
}
