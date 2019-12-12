import 'package:flutter/widgets.dart';

import 'EventBus.dart';

/// Widget to provide [EventBus] into child widget tree
///
/// Typeically should be used as top widget above or right under application widget
///
/// ```
/// class MyApp extends StatelessWidget {
///
///   @override
///   Widget build(BuildContext context) =>
///     EventBusWidget(
///          child: MaterialApp(
///             home: MyHomeScreen()
///          )
///     );
/// }
/// ```
class EventBusWidget extends InheritedWidget {
  /// [EventBus] that provided by this widget
  final EventBus eventBus;

  /// Default constructor that create a default [EventBus] and provided it to [child] widget and its children.
  /// A [key] can be provided if necessary
  /// And [sync] can be used to control whether [EventBus] is `synchronized` or `asynchronized`, default to `asynchronized`.
  EventBusWidget({Key key, @required Widget child, bool sync = false})
      : eventBus = EventBus(sync: sync),
        super(key: key, child: child);

  /// Create widget with prebuilt [EventBus]
  ///
  /// Could be useful when you have want to provide an existing [EventBus] to children or you are using custom stream controller in EventBus
  EventBusWidget.bindEventBus(this.eventBus, {@required Widget child})
      : super(key: ObjectKey(eventBus), child: child);

  @override
  bool updateShouldNotify(EventBusWidget oldWidget) =>
      eventBus != oldWidget.eventBus;

  /// Find the closeset [EventBusWidget] from ancester tree.
  static EventBusWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EventBusWidget>();
}
