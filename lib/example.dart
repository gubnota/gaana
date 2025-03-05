import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gaana.dart';

class GaanaExample extends StatelessWidget {
  const GaanaExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the appState notifier.
    final appState = context.gaana;
    final usersNotifier = appState.get<UsersNotifier>();
    if (usersNotifier == null) {
      return const Scaffold(
        body: Center(child: Text("UsersNotifier not found")),
      );
    }
    // Some random greeting texts.
    const List<String> greetings = [
      "Hello",
      "Hi there",
      "Greetings",
      "Welcome",
      "Hey!",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Gaana state machine")),
      body: Column(
        children: [
          // A row of horizontally scrollable pills.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    usersNotifier.users.map((user) {
                      return GestureDetector(
                        onTap: () {
                          // When a user pill is tapped, check if a ChatNotifier exists.
                          ChatNotifier? chatNotifier =
                              appState.get<ChatNotifier>();
                          // If not, create one and add it.
                          if (chatNotifier == null) {
                            chatNotifier = ChatNotifier();
                            appState.add(ChatNotifier());
                          }
                          // Generate a random greeting.
                          final greeting =
                              greetings[Random().nextInt(greetings.length)];
                          final message = Message(
                            id: DateTime.now().millisecondsSinceEpoch,
                            sender: user,
                            content: "$greeting from $user!",
                            timestamp: DateTime.now(),
                          );
                          chatNotifier.add(message);
                        },
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),

                            child: Text(
                              user,
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          // Button to shuffle the users list.
          TextButton(
            onPressed: () {
              if (Platform.isIOS) HapticFeedback.lightImpact();
              usersNotifier.shuffle();
            },
            child: Card(
              color: Colors.red,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                child: Text(
                  "Shuffle Users",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          // Expanded grid view to display chat messages.
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: appState.notifiers.whereType<ChatNotifier>().fold<int>(
                0,
                (sum, notifier) => sum + notifier.messages.length,
              ), //chatNotifier.messages.length,
              itemBuilder: (context, index) {
                final allMessages =
                    appState.notifiers
                        .whereType<ChatNotifier>()
                        .expand((chat) => chat.messages)
                        .toList();
                final message = allMessages[index];
                return GestureDetector(
                  onTap: () {
                    // When a message tile is tapped, remove it from its ChatNotifier.
                    final chatNotifier = appState.get<ChatNotifier>(
                      predicate: (cn) => cn.messages.contains(message),
                    );
                    if (chatNotifier != null) {
                      chatNotifier.remove(message);
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(message.sender),
                      subtitle: Text(message.content),
                      trailing: Text(
                        "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}:${message.timestamp.second.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
