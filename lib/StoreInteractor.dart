part of 'flutter_event_bus.dart';

abstract class StoreInteractor<T extends StatefulWidget> extends Interactor<T> {
  @override
  Widget build(BuildContext context) =>
      buildWrapper(context, buildChild(context));

  /// The method builds wrappers around [child] according to [storeBuilders] specifies.
  /// If [storeBuilders] is null or empty, then no wrapper is built around [child]
  @protected
  Widget buildWrapper(BuildContext context, Widget child) {
    if (storeBuilders == null || storeBuilders.isEmpty) {
      return child;
    }

    return storeBuilders.fold(
        child, (previous, builder) => builder(context, previous));
  }

  /// Define the hierarchy of stores to be rendered.
  /// Typeically [StoreWidgetBuilder] returns a [InertedWidget] or [InteritedModel], which provides the value to child wigets.
  /// When the interactor state changed, interactor should update these store widgets accordingly,
  /// so the child depends on them will be rerendered accordingly.
  @protected
  List<StoreWidgetBuilder> get storeBuilders;

  /// Build the visual child widgets like normal [build] method does
  @protected
  Widget buildChild(BuildContext context);
}
