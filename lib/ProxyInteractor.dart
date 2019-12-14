import 'package:flutter/widgets.dart';
import 'Interactor.dart';

abstract class ProxyInteractorWidget extends StatefulWidget {
  final Widget child;

  const ProxyInteractorWidget({Key key, @required this.child})
      : super(key: key);
}

abstract class ProxyInteractor<T extends ProxyInteractorWidget>
    extends Interactor<T> {
  @override
  Widget build(BuildContext context) => buildWrapper(context, widget.child);

  @protected
  Widget buildWrapper(BuildContext context, Widget child) => child;
}
