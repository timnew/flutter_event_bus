import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_event_bus/flutter_event_bus.dart';

void main() {
  group("EventBus", () {
    test("should publish and respond to event", () {
      final eventBus = EventBus(sync: true);

      late String capturedEvent;

      eventBus.respond<String>((String event) {
        capturedEvent = event;
      });

      eventBus.publish("event");

      expect(capturedEvent, "event");
    });

    test("should publish and respond to nullable event", () {
      final eventBus = EventBus(sync: true);

      String? capturedEvent = 'some-random-value';

      eventBus.respond<String?>((String? event) {
        capturedEvent = event;
      });

      eventBus.publish(null);

      expect(capturedEvent, null);
    });

    test("should respond to event by type", () {
      final eventBus = EventBus(sync: true);

      final capturedStrings = <String>[];
      final capturedNumbers = <int>[];

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

    test("should respond to dynamic events", () {
      final eventBus = EventBus(sync: true);

      final capturedDynamics = <dynamic>[];
      final capturedStrings = <String>[];

      eventBus.respond<dynamic>((dynamic event) {
        capturedDynamics.add(event);
      });

      eventBus.respond<String>((String event) {
        capturedStrings.add(event);
      });

      eventBus.publish("1");
      eventBus.publish(2);
      eventBus.publish(null);
      eventBus.publish(true);
      eventBus.publish("3");

      expect(capturedDynamics, ["1", 2, null, true, "3"]);
      expect(capturedStrings, ["1", "3"]);
    });

    test("should respond to nullable events by type", () {
      final eventBus = EventBus(sync: true);

      final capturedStrings = <String?>[];
      final capturedNumbers = <int?>[];

      eventBus.respond<String?>((String? event) {
        capturedStrings.add(event);
      });

      eventBus.respond<int?>((int? event) {
        capturedNumbers.add(event);
      });

      eventBus.publish("1");
      eventBus.publish(2);
      eventBus.publish(null);

      eventBus.publish("3");
      eventBus.publish(4);
      eventBus.publish(null);

      expect(capturedStrings, ["1", null, "3", null]);
      expect(capturedNumbers, [2, null, 4, null]);
    });

    test("should respond to some nullable events and some not-nullable events by type", () {
      final eventBus = EventBus(sync: true);

      final capturedStrings = <String?>[];
      final capturedNumbers = <int>[];

      eventBus.respond<String?>((String? event) {
        capturedStrings.add(event);
      });

      eventBus.respond<int>((int event) {
        capturedNumbers.add(event);
      });

      eventBus.publish("1");
      eventBus.publish(2);
      eventBus.publish(null);

      eventBus.publish("3");
      eventBus.publish(4);
      eventBus.publish(null);

      expect(capturedStrings, ["1", null, "3", null]);
      expect(capturedNumbers, [2, 4]);
    });

    test("should not receive event after disposed subscription", () {
      final eventBus = EventBus(sync: true);

      final capturedEvents = <String?>[];

      final subscription = eventBus.respond<String?>((String? event) {
        capturedEvents.add(event);
      });

      eventBus.publish("1");
      eventBus.publish("2");
      eventBus.publish(null);

      subscription.dispose();

      eventBus.publish("3");
      eventBus.publish("4");
      eventBus.publish(null);

      expect(capturedEvents, ["1", "2", null]);
    });

    test("should respond to event by type ignoring nulls", () {
      final eventBus = EventBus(sync: true);

      final capturedEvents = <String>[];

      eventBus.respond<String>((String event) {
        capturedEvents.add(event);
      });

      eventBus.publish("1");
      eventBus.publish("2");
      eventBus.publish(null);

      expect(capturedEvents, ["1", "2"]);
    });
  });
}
