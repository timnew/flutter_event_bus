import 'dart:async';

import 'Responder.dart';

class Subscription {
  final Stream _stream;
  final List<StreamSubscription> subscriptions = List();

  Subscription(this._stream);

  Stream<T> _cast<T>() =>
      (T == dynamic) ? _stream : _stream.where((event) => event is T).cast<T>();

  Subscription respond<T>(Responder<T> responder) {
    subscriptions.add(_cast<T>().listen(responder));

    return this;
  }

  void dispose() {
    if (subscriptions.isEmpty) return;

    subscriptions.forEach((s) => s.cancel());
    subscriptions.clear();
  }
}
