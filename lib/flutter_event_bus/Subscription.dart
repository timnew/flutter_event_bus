import 'dart:async';

import 'Responder.dart';

/// The class manages the subscription to event bus
class Subscription {
  final Stream _stream;

  /// Subscriptions that registered to event bus
  final List<StreamSubscription> subscriptions = List();

  /// Create the subscription
  ///
  /// Should barely used directly, to subscribe to event bus, use `EventBus.respond`.
  Subscription(this._stream);

  Stream<T> _cast<T>() =>
      (T == dynamic) ? _stream : _stream.where((event) => event is T).cast<T>();

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
