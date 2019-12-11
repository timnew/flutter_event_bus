import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:interactor/interactor.dart';

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
  Subscription subscribeEvents() =>
      eventBus.respond<ButtonPressedEvent>(this._onValueChanged);

  void _onValueChanged(ButtonPressedEvent event) {
    setState(() {
      this._value = event.newText;
    });
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
          home: Scaffold(
              body: Row(
        children: <Widget>[
          InteractorWidget(),
          FlatButton(
              child: const Text("Button"),
              onPressed: () {
                EventBus.publishTo(context, ButtonPressedEvent("Pressed"));
              })
        ],
      )));
}

void main() {
  testWidgets("should work", (WidgetTester tester) async {
    await tester.pumpWidget(EventBusWidget(sync: true, child: TestWidget()));

    expect(find.text("None"), findsOneWidget);

    await tester.press(find.byType(FlatButton));

    await tester.pump();

    expect(find.text("Pressed"), findsOneWidget);
  });
}
