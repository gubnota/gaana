import 'package:flutter/widgets.dart';
export 'screen.dart';
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

class UsersNotifier extends ChangeNotifier {
  List<String> _users;

  UsersNotifier(this._users);

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

class ChatNotifier extends ChangeNotifier {
  final List<Message> messages;
  ChatNotifier({List<Message>? messages}) : messages = messages ?? [] {
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
