import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/data/data_sources/local_data_sources/auth_local_data_source.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:locstream/data/model/user_model.dart';

class WatchingSocketEvent {
  final String event;
  final User? user;

  const WatchingSocketEvent({required this.event, this.user});
}

class WatchingUserLocationsSocket {
  io.Socket? socket;

  final streamController = StreamController<WatchingSocketEvent>();

  void connect() async {
    try {
      if (socket != null) return;

      final token = await AuthLocalDataSource().getAuthToken();

      if (token == null) return;

      socket = io.io(
        AppConstants.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({
              'token': token,
            }) //Important or events will not work
            .build(),
      );

      socket?.onConnect((_) {
        if (kDebugMode) {
          print('Connected to socket');
        }
      });

      socket!.on(AppConstants.locationSharesSocketEvent, (data) {
        if (kDebugMode) {
          print('connected data is =========> $data');
        }

        try {
          final watching = data as List<dynamic>;

          for (var e in watching) {
            final user = User.fromJson(e);

            streamController.sink.add(
              (WatchingSocketEvent(
                event: AppConstants.locationSharesSocketEvent,
                user: user,
              )),
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('error in ${AppConstants.locationSharesSocketEvent} is $e');
          }
        }
      });

      socket!.on(AppConstants.locationChangeSocketEvent, (data) {
        if (kDebugMode) {
          print('Location change event =======> $data');
        }

        final user = User.fromJson(data);
        streamController.sink.add(
          (WatchingSocketEvent(
            event: AppConstants.locationChangeSocketEvent,
            user: user,
          )),
        );
      });

      socket?.onDisconnect((error) {
        if (kDebugMode) {
          print('disconnected error $error');
        }

        streamController.sink.add(
          (WatchingSocketEvent(event: AppConstants.connectionErrorEvent)),
        );
      });

      socket?.onConnectError((error) {
        if (kDebugMode) {
          print('connection error $error');
        }
        streamController.sink.addError(
          (WatchingSocketEvent(event: AppConstants.connectionErrorEvent)),
        );
      });

      socket?.onReconnect((reconnect) {
        if (kDebugMode) {
          print('reconnection error $reconnect');
        }
        streamController.sink.add(
          (WatchingSocketEvent(event: AppConstants.reconnectedEvent)),
        );
      });

      socket?.connect();
    } catch (e) {
      rethrow;
    }
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
