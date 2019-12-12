import 'package:flutter/widgets.dart';

import 'EventBus.dart';
import 'Subscription.dart';

abstract class Interactor<T extends StatefulWidget> extends State<T> {
  Subscription _subscription;

  EventBus get eventBus => EventBus.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription?.dispose();

    _subscription = subscribeEvents();
  }

  @override
  void dispose() {
    _subscription.dispose();

    super.dispose();
  }

  @protected
  Subscription subscribeEvents();
}
