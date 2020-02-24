import 'package:flutter/material.dart';

import './src/bloc/ApplicationBloc.dart';
import './src/bloc/BlocProvider.dart';
import './src/ui/screens/MainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ApplicationBloc bloc = ApplicationBloc();

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
