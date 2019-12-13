part of 'flutter_event_bus.dart';

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
  /// If [eventBus] is not given, a new [EventBus] is created, and [sync] is respected. [sync] decides the created event bus
  /// is `synchronized` or `asynchronized`, default to `asynchronized`.
  /// If [eventBus] is given, [sync] is ignored
  ///
  /// The [eventBus] param chould be useful if you want to access eventBus from widget who hold [EventBusWidget],
  /// or you are using custom [StreamController] in Event Bus.
  EventBusWidget(
      {Key key, @required Widget child, EventBus eventBus, bool sync = false})
      : eventBus = eventBus ?? EventBus(sync: sync),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(EventBusWidget oldWidget) =>
      eventBus != oldWidget.eventBus;

  /// Find the closeset [EventBusWidget] from ancester tree.
  static EventBusWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EventBusWidget>();
}
