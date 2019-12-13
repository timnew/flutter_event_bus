import 'package:flutter/widgets.dart';

import '../flutter_event_bus.dart';

/// Base class for the top level [Interactor] which should be used as the top widget
/// RootInteractor will provide [EventBus] and [Store] to children widgets
abstract class RootInteractor<T extends StatefulWidget>
    extends StoreInteractor<T> {
  @override
  final EventBus eventBus;

  /// Create an instance of the RootInteractor
  /// If [eventBus] if not given, a default one will be created
  RootInteractor({EventBus eventBus}) : eventBus = eventBus ?? EventBus();

  @override
  Widget build(BuildContext context) => EventBusWidget(
      eventBus: eventBus, child: buildStores(context, buildChild(context)));

  /// Build Stores to provide states to child widgets
  @protected
  Widget buildStores(BuildContext context, Widget child) => storeBuilders.fold(
      child, (previous, builder) => builder(context, previous));

  /// Build the widget like normal [build] method does

  @protected
  Widget buildChild(BuildContext context);
}
