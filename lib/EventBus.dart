import 'package:flutter/widgets.dart';
import 'dart:async';
import 'Subscription.dart';

/// Allow widgets to communicate to each other without direct coupling
class EventBus {
  final StreamController _streamController;

  /// User customer stream controller in event bus.
  ///
  /// Could be useful when using [Event Bus] with `RxDart`
  ///
  /// ```
  /// import 'package:rxdart/rxdart.dart';
  ///
  /// final eventBus = EventBus.customController(ReplaySubject());
  /// ```
  EventBus.customController(this._streamController);

  /// Create an event bus with default dart StreamController.
  /// You can use [sync] to identify whether the event bus should be sync or async, by default it is async.
  /// For more detail, check [Stream] document.
  EventBus({bool sync = false})
      : _streamController = StreamController<dynamic>.broadcast(sync: sync);

  Stream get _stream => _streamController.stream;

  /// Publish an event to all corresponding responders via EventBus
  void publish(dynamic event) {
    _streamController.add(event);
  }

  /// Shutdown the internal stream conroller.
  ///
  /// Barely used in production environment. Could be useful in test environment to clear up the environment.
  void dispose() {
    _streamController.close();
  }

  /// Subscribe `Eventbus` on a specific type of event, and register responder to it.
  ///
  /// When [T] is not given or given as `dynamic`, it listens to all events regardless of the type.
  /// Returns [Subscription], which can be disposed to cancel all the subsciption registered to itself.
  Subscription respond<T>(Responder<T> responder) =>
      Subscription(_stream).respond<T>(responder);

  /// Try to find [EventBus] provided by an ancestor [EventBusWidget]
  static EventBus of(BuildContext context) =>
      EventBusWidget.of(context).eventBus;

  /// An convenient call to publish event via the [EventBus] provided by an ancestor [EventBusWidget]
  ///
  /// Following code
  /// ```
  /// EventBus.publishTo(context, event);
  /// ```
  ///  is equivalent to
  /// ```
  /// EventBus.of(context).publish(event);
  /// ```
  static void publishTo(BuildContext context, dynamic event) =>
      of(context).publish(event);
}

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
  /// The [eventBus] param should be useful if you want to access eventBus from widget who hold [EventBusWidget],
  /// or you are using custom [StreamController] in Event Bus.
  EventBusWidget(
      {Key? key, required Widget child, EventBus? eventBus, bool sync = false})
      : eventBus = eventBus ?? EventBus(sync: sync),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(EventBusWidget oldWidget) =>
      eventBus != oldWidget.eventBus;

  /// Find the closest [EventBusWidget] from ancestor tree.
  static EventBusWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EventBusWidget>()!;
}
