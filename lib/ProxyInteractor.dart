import 'package:flutter/widgets.dart';
import 'Interactor.dart';

abstract class ProxyInteractorWidget extends StatefulWidget {
  final WidgetBuilder childBuilder;

  const ProxyInteractorWidget({Key key, @required this.childBuilder})
      : super(key: key);
}

abstract class ProxyInteractor<T extends ProxyInteractorWidget>
    extends Interactor<T> {
  @override
  Widget build(BuildContext context) => buildWrapper(context, buildChild);

  @protected
  Widget buildWrapper(BuildContext context, WidgetBuilder childBuilder) =>
      childBuilder(context);

  @protected
  Widget buildChild(BuildContext context) => widget.childBuilder(context);
}
