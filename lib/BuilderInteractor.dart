import 'package:flutter/widgets.dart';
import 'Interactor.dart';

abstract class BuilderInteractorWidget extends StatefulWidget {
  final WidgetBuilder childBuilder;

  const BuilderInteractorWidget({Key key, @required this.childBuilder})
      : super(key: key);
}

abstract class BuilderInteractor<T extends BuilderInteractorWidget>
    extends Interactor<T> {
  @override
  Widget build(BuildContext context) => buildWrapper(context, buildChild);

  @protected
  Widget buildWrapper(BuildContext context, WidgetBuilder childBuilder) =>
      childBuilder(context);

  @protected
  Widget buildChild(BuildContext context) => widget.childBuilder(context);
}
