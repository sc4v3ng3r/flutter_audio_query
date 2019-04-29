import 'package:flutter/widgets.dart';
import './BlocBase.dart';

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Key key;
  final Widget child;
  final T bloc;

  static Type _typeOf<T>() => T;

  BlocProvider({this.key, @required this.child, @required this.bloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocProviderState();

  static T of<T extends BlocBase>(final BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();

    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    print("Provider dispose!");
    widget.bloc.dispose();
    super.dispose();
  }
}
