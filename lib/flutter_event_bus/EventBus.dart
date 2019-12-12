import 'dart:async';

import 'package:flutter/widgets.dart';

import 'EventBusWidget.dart';
import 'Responder.dart';
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
  /// You can use [sync] to indentify whether the event bus should be sync or async, by default it is async.
  /// For more detail, check [Stream] document.
  EventBus({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  Stream get _stream => _streamController.stream;

  /// Publish an event to all corresponding responders via EventBus
  void publish(event) {
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
  static void publishTo(BuildContext context, event) =>
      of(context).publish(event);
}
