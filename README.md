# flutter_event_bus

[![Star this Repo](https://img.shields.io/github/stars/timnew/flutter_event_bus.svg?style=flat-square)](https://github.com/timnew/flutter_event_bus)
[![Pub Package](https://img.shields.io/pub/v/flutter_event_bus.svg?style=flat-square)](https://pub.dev/packages/flutter_event_bus)

Flutter Event Bus is an `EventBus` designed specific for Flutter app, which enable developer to write flutter app with Interactor pattern, which is similar to Bloc but less structured on some aspect.

## Why another Event Bus

There is a [Event Bus](https://pub.dev/packages/event_bus) package, why create another one?

Marco Jakob did a great job while creating `Event Bus` package, which provides a generic Event Bus pattern implementation that can be used anywhere in Dart ecosystem.

But while writing app in Interactor pattern in flutter, there are a few common usages that existing library are not really convenient. So `Flutter Event Bus` has been carefully customised for these use cases.

## Event Bus

Event Bus is a pub/sub system to enable components collaborate with each other without direct coupling. Component can publish event to make announcement when something happens, or respond to event to take action.

## Basic Usage

```dart
class TextChangedEvent{
  final String text;
  const TextChangedEvent(this.text);
}

final eventBus = EventBus();

eventBus.respond<TextChangedEvent>((TextChangedEvent event) =>
  print("Text changed to ${event.text}");
);

eventBus.publish(TextChangedEvent("new text"));
```

### Stop responding events

```dart
final subscription = eventBus.respond<TextChangedEvent>(responder);

eventBus.publish(TextChangedEvent("Responded")); // This event will be responded by responder

subscription.dispose();

eventBus.publish(TextChangedEvent("Ignored")); // This event will not be responded by responder
```

### Respond to different type of events

```dart
final subscription = eventBus
  .respond<EventA>(responderA) // Subscribe to EventA
  .respond<EventB>(responderB) // Subscribe to EventB
  .respond<EventC>(responderC) // Subscribe to EventC
  .respond<EventA?>(responderNullableA) // Subscribe to EventA and any null
  .respond<EventB?>(responderNullableB) // Subscribe to EventB and any null
  .respond(genericResponder); // Subscribe to EventA EventB EventC null and any other event on event bus

  // Generic Responder could be useful for monitoring, logging or diagnosis purpose, probably will be hardly used to take action to event

subscription.dispose(); // All previous 4 subscriptions will be cancelled all together
```

## Used in Flutter

### Event Bus Widget

To embed `EventBus` in Flutter, you can use `EventBusWidget`, which provide `EventBus` to its child tree.

```dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
    EventBusWidget(
      child: MaterialApp(
        // .....
      )
    );
}
```

### Capture user interaction

You're like to publish event in stateless widget to broadcast user interaction into your app.

```dart
class SubmitFormEvent { }

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    FlatButton(
      child: const Text("Publish"),
      onPressed: () {
        EventBus.publish(context, SubmitFormEvent()); // Publish event to the event bus provided by ancestor EventBusWidget
      }
    )
}
```

### Capture state changes

You might also wish to publish some event when app state had a certain change

```dart
class MyWidgetState extends State<MyWidget> {
  int _counter = 0;
  EventBus eventBus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    eventBus = EventBus.of(context); // Find EventBus provided by ancestor EventBusWidget
  }


  void _incrementCounter(InreaseCounterEvent event) {
    setState(() {
      if(++_counter == 100) {
        eventBus.publish(CounterMaximizedEvent());
      }
    });
  }
}
```

### Respond events

To respond to events you can listening event bus directly. But more commonly you will do it via `Interactor`.

You can use `Interactor` as base class as your stateful widget state, and implements the `subscribeEvents` method to describe the events that interactor can handle. Interactor manages the subscription and cancel the subscription when it is removed from the tree.

```dart
class IncreaseCounterEvent {}
class DecreaseCounterEvent {}
class CounterChangedEvent {
  final int value;
  CounterChangedEvent(this.value);
}

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageInteractor createState() => _MyPageInteractor();
}

class _MyPageInteractor extends Interactor<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // Build the widget tree as usual
  }

  @override
  Subscription subscribeEvents(EventBus eventBus) => eventBus
    .respond<IncreaseCounterEvent>(_incrementCounter)
    .respond<DecreaseCounterEvent>(_decrementCounter);

  void _incrementCounter(IncreaseCounterEvent event) {
    setState(() {
      _counter++;

      eventBus.publish(CounterChangedEvent(_counter));
    });
  }

   void _decrementCounter(DecreaseCounterEvent event) {
    setState(() {
      _counter--;

      if(_counter < 0) {
        _counter = 0;
        eventBus.publish(CounterReachZeroEvent());
      }

      eventBus.publish(CounterChangedEvent(_counter));
    });
  }
}
```

## License

The MIT License (MIT)
