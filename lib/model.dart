import 'package:flutter/widgets.dart';
import 'package:gaana/gaana_notifier.dart';
// export 'example.dart';
// part 'example.dart'; // Ensure this is the correct part file

final exampleUsers = [
  'Alice',
  'Bob',
  'Charlie',
  'Ivy',
  'Don',
  'Caren',
  'Dick',
  'Sam',
  'Fred',
  'Mich',
  'Creig',
];
// Some random greeting texts.
const List<String> exampleGreetings = [
  "Hello",
  "Hi there",
  "Greetings",
  "Welcome",
  "Hey!",
];

class UsersNotifier extends GaanaNotifier {
  List<String> users;
  UsersNotifier(this.users);

  List<String> get getUsers => users;

  void set(List<String> newUsers) {
    users = newUsers;
    notify();
  }

  void shuffle() {
    users.shuffle();
    notify();
  }
}

class OldUsersNotifier extends ChangeNotifier {
  List<String> _users;

  OldUsersNotifier(this._users);

  List<String> get users => _users;

  /// Updates the list and notifies listeners.
  void set(List<String> newUsers) {
    _users = newUsers;
    notifyListeners();
  }

  /// Shuffles the list and notifies listeners.
  void shuffle() {
    _users.shuffle();
    notifyListeners();
  }
}

class Message {
  final int id;
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class ChatNotifier extends GaanaNotifier {
  // final String userName;
  final List<Message> messages;

  ChatNotifier({List<Message>? messages}) //required this.userName,
    : messages = messages ?? [];

  void add(Message message) {
    messages.insert(0, message);
    notify();
  }

  void remove(Message message) {
    messages.remove(message);
    notify();
  }

  void clean() {
    messages.clear();
    notify();
  }
}

class OldChatNotifier extends ChangeNotifier {
  final List<Message> messages;
  OldChatNotifier({List<Message>? messages}) : messages = messages ?? [] {
    // Now messages is a mutable list.
  }

  void addMessage(Message message) {
    messages.insert(0, message);
    // _messages.add(message);
    notifyListeners();
  }

  void removeMessage(Message message) {
    messages.remove(message);
    notifyListeners();
  }
}
