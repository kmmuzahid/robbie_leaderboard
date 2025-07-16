import 'dart:convert';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/recent_activity_receive_model.dart';
import 'package:the_leaderboard/models/ticket_won_socket_model.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class SocketService {
  // Singleton pattern
  SocketService._privateConstructor();
  static final SocketService _instance = SocketService._privateConstructor();
  static SocketService get instance => _instance;

  late IO.Socket _socket;

  void connect() {
    _socket = IO.io(
      AppUrls.socketUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    _socket.onConnect((_) {
      print('Socket connected');
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  // Method to send investment data
  void sendInvest(String userName, int amount) {
    if (!_socket.connected) {
      print("Socket is not connected. Connecting...");
      connect();
    }

    final data = {
      "userName": userName,
      "result": {"amount": amount}
    };

    _socket.emit('invest', data);
    print('Sent invest data: $data');
  }

  void createTicket(String userName, Map<String, dynamic> result) {
    if (!_socket.connected) {
      appLog("Socket is not connected. Connecting...");
      connect();
    }
    appLog(result);
    final data = {
      "result": jsonEncode(result),
      "userName": userName,
    };

    _socket.emit('new tickets', data);
    appLog('Sent invest data: $data');
  }

  void sendReportData(
      String userName, String email, Map<String, dynamic> result) {
    if (!_socket.connected) {
      appLog("Socket is not connected. Connecting...");
      connect();
    }
    appLog(result);
    final data = {
      "result": jsonEncode(result),
      "user": {"name": userName, "email": email}
    };
// result, user: { name: user.name, email: user.email }
    _socket.emit('report', data);
    appLog('Sent report data: $data');
  }

  //with ack
//   Future<RecentActivityReceiveModel> sendInvest(String userName, int amount) async {
//   if (!_socket.connected) {
//     print("Socket is not connected. Connecting...");
//     connect();
//     // Optional: wait for connection to establish
//     await Future.delayed(const Duration(milliseconds: 500));
//   }

//   final data = {
//     "userName": userName,
//     "result": {"amount": amount}
//   };

//   print('🔼 Sending invest data: $data');

//   final response = _socket.emitWithAck('invest', data);

//   print('✅ Received response: $response');

//   return RecentActivityReceiveModel.fromJson(response);
// }

  // Method to listen for 'new invest message received' event
  void onNewInvestMessageReceived(
      void Function(RecentActivityReceiveModel) callback) {
    _socket.on('new invest message received', (data) {
      appLog('Received invest message: $data');
      Get.find<NotificationController>().increment();
      callback(RecentActivityReceiveModel.fromJson(data));
    });
  }

  void onCreatingTicketResponse(void Function(TicketWonSocketModel) callback) {
    _socket.on('ticket message received', (data) {
      appLog('Received invest message: $data');
      Get.find<NotificationController>().increment();
      callback(TicketWonSocketModel.fromJson(data));
    });
  }

  void dispose() {
    _socket.dispose();
  }
}
