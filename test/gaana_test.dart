import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaana/example.dart';

void main() {
  group("Gaana tests", () {
    test("init", () {
      final gaana = Gaana(child: const SizedBox());
      gaana.notifier?.add(UsersNotifier(exampleUsers));
      final un = gaana.notifier?.get<UsersNotifier>();
      expect(un?.users.length, greaterThan(1));
    });

    test("unique notifier check", () {
      final composite = CompositeNotifier([]);
      composite.add(GaanaNotifier(key: "graph1"));
      composite.add(GaanaNotifier(key: "graph2"));
      final notifier = composite.get<GaanaNotifier>(key: "graph2");
      expect(notifier, isNotNull);
      expect(notifier!.key, equals("graph2"));

      composite.add(UsersNotifier(exampleUsers));
      final un = composite.get<UsersNotifier>();
      expect(un?.users.length, greaterThan(1));
    });

    test("advanced stream check", () {
      final composite = CompositeNotifier([]);
      composite.add(UsersNotifier(exampleUsers));
      final un = composite.get<UsersNotifier>();
      expect(un?.users.length, greaterThan(1));
    });

    test("chat notifier key check", () {
      final chat = ChatNotifier(
        messages: [
          Message(
            id: 1,
            sender: "Alice",
            content: "hello",
            timestamp: DateTime.now(),
          ),
        ],
      );
      GaanaService.add(chat); // Add to global composite.
      final fetchedChat = GaanaService.get<ChatNotifier>();
      expect(fetchedChat, isNotNull);
      expect(fetchedChat!.messages.first.sender, equals("Alice"));
    });

    test("chat notifier add and remove message", () {
      final chat = ChatNotifier();
      GaanaService.add(chat);
      final message = Message(
        id: 123,
        sender: "Bob",
        content: "Test Message",
        timestamp: DateTime.now(),
      );
      chat.add(message);
      expect(chat.messages.contains(message), isTrue);
      chat.remove(message);
      expect(chat.messages.contains(message), isFalse);
    });

    test("composite notifier clean", () {
      final composite = CompositeNotifier([]);
      composite.add(UsersNotifier(exampleUsers));
      composite.clean();
      expect(composite.notifiers.isEmpty, isTrue);
    });
  });
}
