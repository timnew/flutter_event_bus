import 'dart:async';

import 'package:flutter/widgets.dart';

import 'EventBusWidget.dart';
import 'Responder.dart';
import 'Subscription.dart';

class EventBus {
  final StreamController _streamController;

  EventBus.customController(this._streamController);

  EventBus({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  Stream get _stream => _streamController.stream;

  void publish(event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }

  Subscription respond<T>(Responder<T> responder) =>
      Subscription(_stream).respond<T>(responder);

  static EventBus of(BuildContext context) =>
      EventBusWidget.of(context).eventBus;

  static void publishTo(BuildContext context, event) =>
      of(context).publish(event);
}
