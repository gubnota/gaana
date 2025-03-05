import 'dart:async';
import 'gaana_service.dart';
import 'model.dart';

class GaanaRepository {
  void sendMessage(String text) {
    final chatNotifier = GaanaService.get<ChatNotifier>();
    if (chatNotifier != null) {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch,
        sender: 'GaanaRepository',
        content: text,
        timestamp: DateTime.now(),
      );
      chatNotifier.clean();
      chatNotifier.add(message);
    }
  }

  void triggerDelayedMessage() {
    Timer(const Duration(seconds: 0), () {
      sendMessage('Hello from GaanaRepository!');
    });
    Timer(const Duration(seconds: 2), () {
      sendMessage('Hello after 2 seconds response from the server!');
    });
  }
}
