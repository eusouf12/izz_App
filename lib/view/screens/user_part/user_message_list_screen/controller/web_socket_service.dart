import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static WebSocketChannel? _channel;
  static bool isConnected = false;

  static void connect(String url) {
    String socketUrl = url;
    if (url.startsWith("https://")) {
      socketUrl = url.replaceFirst("https://", "wss://");
    } else if (url.startsWith("http://")) {
      socketUrl = url.replaceFirst("http://", "ws://");
    }

    print("🌐 Attempting to connect: $socketUrl");

    try {
      _channel = WebSocketChannel.connect(Uri.parse(socketUrl));

      _channel!.ready.then((_) {
        isConnected = true;
        print("✅ WebSocket Ready");
      }).catchError((e) {
        isConnected = false;
        print("❌ Connection Failed: $e");
      });
    } catch (e) {
      isConnected = false;
      print("❌ Catch Error: $e");
    }
  }

  static void send(Map<String, dynamic> data) {
    if (_channel != null && isConnected) {
      _channel!.sink.add(jsonEncode(data));
      print("📤 Sent: $data");
    } else {
      print("⚠️ Cannot send: WebSocket not connected");
    }
  }

  static Stream? get stream => _channel?.stream;

  static void disconnect() {
    _channel?.sink.close(status.goingAway);
    _channel = null;
    isConnected = false;
  }
}