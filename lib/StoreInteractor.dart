import 'package:flutter/widgets.dart';
import 'Interactor.dart';

abstract class StoreInteractor<T extends StatefulWidget> extends Interactor<T> {
  @override
  Widget build(BuildContext context) => buildWrapper(context, buildChild);

  @protected
  Widget buildWrapper(BuildContext context, WidgetBuilder childBuilder) =>
      childBuilder(context);

  /// Build the visual child widgets like normal [build] method does
  @protected
  Widget buildChild(BuildContext context);
}
