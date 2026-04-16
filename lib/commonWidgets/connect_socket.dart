import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../app/data/api_url.dart';
import '../utils/prefsKey.dart';
import 'constant.dart';

IO.Socket? socket;
String? socketID;

connectSocket() {
  final userId = box.read(PrefsKey.userId);
  log("Connecting socket for userId: $userId");

  socket = IO.io(ApiUrl.baseUrl, <String, dynamic>{
    'transports': ['websocket', 'polling'],
    'autoConnect': true,
    'reconnection': true,
    'path': '/socket.io',
  });

  socket?.on('connect', (_) {
    log("Socket connected: ${socket?.connected}");
    log("tokenId :- ${box.read(PrefsKey.tokenId)}");
    socket?.emit('socket_register', {'user_id': userId, 'token_id': box.read(PrefsKey.tokenId)});
    socket?.on('socket_register', (data) {
      log("socketRegisterData :- $data");
    });

    socketID = socket?.id;

    log("Socket registered with ID: $socketID");
    log("tokenId: ${box.read(PrefsKey.tokenId)}");

    Future.delayed(const Duration(seconds: 2), () {
      box.write(PrefsKey.socketId, socketID);
    });
  });

  socket?.on('connect_error', (error) {
    log("Socket connection error: $error");
  });

  socket?.on('disconnect', (_) {
    log("Socket disconnected");
  });
}
