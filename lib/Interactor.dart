import 'package:flutter/widgets.dart';
import 'Subscription.dart';
import 'EventBus.dart';

/// Base class for the busiess object that handles events that published on [EventBus].
/// It should be used as base class to a [State] of a [StatefulWidget].
///
/// ```
/// class MyInteractorWidget extends StatefulWidget {
///  @override
///  MyInteractor createState() => MyInteractor();
/// }
///
/// class MyInteractor extends Interactor<MyInteractorWidget> {
///   @override
///   Widget build(BuildContext context) {
///     ...
///   }
///
///   @override
///   Subscription subscribeEvents() => eventBus
///     .respond<EventA>(this._responderA)
///     .respond<EventB>(this._responderB);
/// }
/// ```
abstract class Interactor<T extends StatefulWidget> extends State<T> {
  Subscription? _subscription;

  /// [EventBus] provided by ancestor [EventBusWidget]
  /// Cannot not be accessed in [initState] or [dispose], as state has not yet or had been removed from element tree.
  @protected
  EventBus get eventBus => EventBus.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription?.dispose();

    _subscription = subscribeEvents(eventBus);
  }

  @override
  void dispose() {
    _subscription?.dispose();

    super.dispose();
  }

  /// A method that all concrete interactors should implement, should calling subscribe to EventBus here.
  /// ```
  /// @override
  ///   Subscription subscribeEvents() => eventBus
  ///     .respond<EventA>(this._responderA)
  ///     .respond<EventB>(this._responderB);
  /// ```
  ///
  /// If there is absolutely no subscription in this interactor, an empty [Subscription] can be obtained
  /// via `Subscription.empty()`.
  @protected
  Subscription subscribeEvents(EventBus eventBus);
}
