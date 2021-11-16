import 'dart:async';

/// The function/method signature for the event handler
typedef void Responder<T>(T event);

/// The class manages the subscription to event bus
class Subscription {
  final Stream _stream;

  /// Subscriptions that registered to event bus
  final subscriptions = <StreamSubscription>[];

  /// Create the subscription
  ///
  /// Should barely used directly, to subscribe to event bus, use `EventBus.respond`.
  Subscription(this._stream);

  /// Returns an instance that indicates there is no subscription
  factory Subscription.empty() => const _EmptySubscription();

  Stream<T> _cast<T>() {
    if((T == dynamic)) {
      return _stream.cast();
    }

    return _stream.where((event) => event is T).cast<T>();
  }

  /// Register a [responder] to event bus for the event type [T].
  /// If [T] is omitted or given as `dyanmic`, it listens to all events that publised on [EventBus].
  ///
  /// Method call can be safely chained, and the order doesn't matter.
  ///
  /// ```
  /// eventBus
  ///   .respond<EventA>(responderA)
  ///   .respond<EventB>(responderB);
  /// ```
  Subscription respond<T>(Responder<T> responder) {
    subscriptions.add(_cast<T>().listen(responder));

    return this;
  }

  /// Cancel all the registered subscriptions.
  /// After calling this method, all the events published won't be delivered to the cleared responders any more.
  ///
  /// No harm to call more than once.
  void dispose() {
    if (subscriptions.isEmpty) return;

    subscriptions.forEach((s) => s.cancel());
    subscriptions.clear();
  }
}

class _EmptySubscription implements Subscription {
  static final List<StreamSubscription> emptyList =
  List.unmodifiable(<StreamSubscription>[]);

  const _EmptySubscription();

  @override
  void dispose() {}

  @override
  Subscription respond<T>(responder) => throw Exception("Not supported");

  @override
  List<StreamSubscription> get subscriptions => emptyList;

  @override
  Stream<T> _cast<T>() => throw Exception("Not supported");

  @override
  Stream get _stream => throw Exception("Not supported");
}
