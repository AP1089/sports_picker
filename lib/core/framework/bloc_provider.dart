import 'package:flutter/material.dart';

// https://www.didierboelens.com/2018/12/reactive-programming-streams-bloc-practical-use-cases/
// https://www.raywenderlich.com/4074597-getting-started-with-the-bloc-pattern

// All blocs extend this class to force a dispose method to close all streams
abstract class Bloc {
  void dispose();
}

// For access to the Bloc between screens instead of using a plug in
class BlocProvider<T extends Bloc> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends Bloc>(BuildContext context) {
    var provider = context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>();

    _BlocProviderInherited<T> widget = provider?.widget;
    return widget?.bloc;
  }
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
