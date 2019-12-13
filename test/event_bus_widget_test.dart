import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_event_bus/flutter_event_bus.dart';

class ButtonPressedEvent {
  final String newText;

  ButtonPressedEvent(this.newText);
}

class InteractorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestInteractor();
}

class TestInteractor extends Interactor<InteractorWidget> {
  String _value = "None";

  @override
  Widget build(BuildContext context) => Text(_value, key: const Key("text"));

  @override
  Subscription subscribeEvents(EventBus eventBus) => eventBus
      .respond<ButtonPressedEvent>(this._onValueChanged)
      .respond(this._logEvent);

  void _logEvent(dynamic event) {
    print("logEvent: $event");
  }

  void _onValueChanged(ButtonPressedEvent event) {
    setState(() {
      this._value = event.newText;
    });
  }
}

class TestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
      child: const Text("Button"),
      onPressed: () {
        EventBus.publishTo(context, ButtonPressedEvent("Pressed"));
      });
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
          home: Scaffold(
              body: Row(
        children: <Widget>[InteractorWidget(), TestButton()],
      )));
}

void main() {
  testWidgets("should work", (WidgetTester tester) async {
    await tester.pumpWidget(EventBusWidget(sync: true, child: TestWidget()));

    expect(find.text("None"), findsOneWidget);

    await tester.tap(find.byType(RaisedButton));

    await tester.pump();

    expect(find.text("Pressed"), findsOneWidget);
  });
}
