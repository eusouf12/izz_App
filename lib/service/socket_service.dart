/*
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../helper/shared_prefe/shared_prefe.dart';
import '../utils/app_const/app_const.dart';
import 'api_url.dart';

class SocketApi {
  // Singleton instance of the class
  factory SocketApi() {
    return _socketApi;
  }

  // Private constructor for singleton
  SocketApi._internal();

  static late io.Socket socket;
  static bool _isInitialized = false; // To track if the socket is initialized
  static bool _isReconnecting =
      false; // To avoid multiple reconnection attempts
  static Function? _onSocketConnectCallback; // Callback for socket connection

  ///<------------------------- Socket Initialization with Bearer Token ---------------->

  static Future<void> init({Function? onSocketConnect}) async {
    // If the socket is already initialized and connected, do nothing
    if (_isInitialized && socket.connected) {
      debugPrint('Socket is already connected. Skipping reinitialization.');
      return;
    }

    // Store the callback
    _onSocketConnectCallback = onSocketConnect;

    String bearerToken =
        await SharePrefsHelper.getString(AppConstants.bearerToken);
    if (bearerToken.isEmpty || bearerToken == "null") {
      debugPrint('Bearer token is missing or invalid');
      return;
    }

    _initializeSocket(bearerToken);
    _isInitialized = true;
  }

  static void _initializeSocket(String bearerToken) {
    socket = io.io(
      ApiUrl.socketUrl, // Replace with your actual socket URL
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew() // Ensures a new connection is created
          .setExtraHeaders({
            'Authorization': 'Bearer $bearerToken'
          }) // Add Bearer token to headers
          .enableReconnection() // Enable automatic reconnection
          .setReconnectionAttempts(50000) // Number of reconnection attempts
          .setReconnectionDelay(
              1000) // Delay between reconnection attempts (1 second)
          .setReconnectionDelayMax(
              5000) // Maximum delay between reconnection attempts (5 seconds)
          .build(),
    );

    debugPrint(
        '$bearerToken=============> Socket initialization, connected: ${socket.connected}');

    // Listen for socket connection
    socket.onConnect((_) {
      debugPrint(
          '==============>>>>>>> Socket Connected ${socket.connected} ===============<<<<<<<');
      _isReconnecting = false; // Reset reconnection flag

      // Trigger the callback if it exists
      if (_onSocketConnectCallback != null) {
        _onSocketConnectCallback!();
      }
    });

    // Listen for unauthorized events
    socket.on('unauthorized', (dynamic data) {
      debugPrint('Unauthorized');
    });

    // Listen for errors
    socket.onError((dynamic error) {
      debugPrint('Socket error: $error');
      _reconnectSocket(); // Attempt to reconnect on error
    });

    // Listen for disconnection
    socket.onDisconnect((dynamic data) {
      debugPrint('>>>>>>>>>> Socket instance disconnected <<<<<<<<<<<<$data');
      _reconnectSocket(); // Attempt to reconnect on disconnect
    });

    // Listen for reconnection attempts
    socket.onReconnectAttempt((dynamic data) {
      debugPrint('>>>>>>>>>> Reconnecting... Attempt: $data <<<<<<<<<<<<');
      _isReconnecting = true;
    });

    // Listen for reconnection failure
    socket.onReconnectFailed((dynamic data) {
      debugPrint('>>>>>>>>>> Reconnection failed <<<<<<<<<<<<');
      _isReconnecting = false;
    });
  }

  ///<------------------------- Reconnect Socket Logic ---------------->

  static Future<void> _reconnectSocket() async {
    if (_isReconnecting) return; // Avoid multiple reconnection attempts

    _isReconnecting = true;
    debugPrint('Attempting to reconnect socket...');

    // Fetch the latest Bearer token
    String bearerToken =
        await SharePrefsHelper.getString(AppConstants.bearerToken);
    if (bearerToken.isEmpty || bearerToken == "null") {
      debugPrint('Bearer token is missing or invalid');
      return;
    }

    // Reinitialize the socket
    _initializeSocket(bearerToken);
  }

  ///<------------------------- Send Event ---------------->

  static Future<void> sendEvent(String eventName, dynamic data) async {
    if (!socket.connected) {
      debugPrint('Socket is not connected. Attempting to reconnect...');
      await _reconnectSocket(); // Now this can be awaited
    }
    socket.emit(eventName, data);
  }

  // Static instance of the class
  static final SocketApi _socketApi = SocketApi._internal();
}
*/
