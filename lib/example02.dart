import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'example.dart';

class GaanaExample2 extends StatelessWidget {
  const GaanaExample2({super.key});

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
    final repository = PlotRepository();
    final petrolUseCase = PetrolUseCase(
      repository: repository,
      plotNotifier: GaanaService.instance.get<PlotNotifier>() ?? PlotNotifier(),
    );
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStyledButton(
                  context: context,
                  label: "Shuffle users",
                  onPressed: () {
                    GaanaService.instance.get<PlotNotifier>()?.clean();
                    if (Platform.isIOS) HapticFeedback.lightImpact();
                    usersNotifier.shuffle();
                    final usersNotifier2 =
                        GaanaService.instance.get<UsersNotifier>();
                    debugPrint(
                      (usersNotifier2 == Gaana.of(context).get<UsersNotifier>())
                          .toString(),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 149, 54, 244),
                ),
                buildStyledButton(
                  context: context,
                  label: "Stream data",
                  onPressed: () {
                    // For demonstration, instantiate PlotRepository and PetrolUseCase.
                    GaanaService.instance.get<PlotNotifier>()?.clean();
                    if (petrolUseCase.isRunning()) {
                      petrolUseCase.stop();
                    } else {
                      // Start the petrol use case if not already started.
                      petrolUseCase.start();
                    }
                  },
                  backgroundColor: const Color.fromARGB(255, 0, 142, 114),
                ),
              ],
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
          GraphDemo(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

/// A reusable function that builds a styled ElevatedButton.
ElevatedButton buildStyledButton({
  required BuildContext context,
  required String label,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? foregroundColor,
  TextStyle? textStyle,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: backgroundColor ?? Colors.red,
      foregroundColor: foregroundColor ?? Colors.white,
      // You can pass a textStyle here:
      textStyle:
          textStyle ??
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    onPressed: onPressed,
    child: Text(label),
  );
}

class GraphDemo extends StatelessWidget {
  const GraphDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SimpleGraph(data: GaanaService.get<PlotNotifier>()?.dots ?? []),
      ),
    );
  }
}
