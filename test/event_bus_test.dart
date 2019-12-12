import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_event_bus/flutter_event_bus.dart';

void main() {
  group("EventBus", () {
    test("should publish and respond to event", () {
      final eventBus = EventBus(sync: true);

      String capturedEvent;

      eventBus.respond<String>((String event) {
        capturedEvent = event;
      });

      eventBus.publish("event");

      expect(capturedEvent, "event");
    });

    test("should respond to event by type", () {
      final eventBus = EventBus(sync: true);

      List<String> capturedStrings = List();
      List<int> capturedNumbers = List();

      eventBus.respond<String>((String event) {
        capturedStrings.add(event);
      });

      eventBus.respond<int>((int event) {
        capturedNumbers.add(event);
      });

      eventBus.publish("1");
      eventBus.publish(2);

      eventBus.publish("3");
      eventBus.publish(4);

      expect(capturedStrings, ["1", "3"]);
      expect(capturedNumbers, [2, 4]);
    });

    test("should not recieve event after disposed subscription", () {
      final eventBus = EventBus(sync: true);

      List<String> capturedEvents = List();

      final subscription = eventBus.respond<String>((String event) {
        capturedEvents.add(event);
      });

      eventBus.publish("1");
      eventBus.publish("2");

      subscription.dispose();

      eventBus.publish("3");
      eventBus.publish("4");

      expect(capturedEvents, ["1", "2"]);
    });
  });
}
