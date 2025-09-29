import 'dart:async';
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
        print("Connected to socket");
       try {
         socket!.on(AppConstants.locationSharesSocketEvent, (data) {
           final shareres = data as List<dynamic>;

           shareres.map((e) {
             final user = User.fromJson(e);
             streamController.sink.add(
               (WatchingSocketEvent(
                 event: AppConstants.locationSharesSocketEvent,
                 user: user,
               )),
             );
           });
         });

         socket!.on(AppConstants.locationChangeSocketEvent, (data) {
           final user = User.fromJson(data);
           streamController.sink.add(
             (WatchingSocketEvent(
               event: AppConstants.locationChangeSocketEvent,
               user: user,
             )),
           );
         });
       }catch(e) {
         print("Error initializing custom events $e");
       }
      });

      socket?.onDisconnect((error) {
        print("disconnected error ${error}");
        streamController.sink.add(
          (WatchingSocketEvent(event: AppConstants.connectionErrorEvent)),
        );
      });

      socket?.onConnectError((error) {
        print("connection error ${error}");
        streamController.sink.addError(
          (WatchingSocketEvent(event: AppConstants.connectionErrorEvent)),
        );
      });

      socket?.onReconnect((reconnect) {
        print("reconnection error ${reconnect}");
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
