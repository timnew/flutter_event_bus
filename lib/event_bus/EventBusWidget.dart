import 'package:flutter/widgets.dart';

import 'EventBus.dart';

class EventBusWidget extends InheritedWidget {
  final EventBus eventBus;

  EventBusWidget({Key key, @required Widget child, bool sync = false})
      : eventBus = EventBus(sync: sync),
        super(key: key, child: child);

  EventBusWidget.bindEventBus(this.eventBus, {@required Widget child})
      : super(key: ObjectKey(eventBus), child: child);

  @override
  bool updateShouldNotify(EventBusWidget oldWidget) =>
      eventBus != oldWidget.eventBus;

  static EventBusWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(EventBusWidget) as EventBusWidget;
}
