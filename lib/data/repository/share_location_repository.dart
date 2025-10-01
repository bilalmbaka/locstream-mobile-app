import 'dart:async';

import 'package:locstream/data/data_sources/remote_data_sources/share_location_remote_data_source.dart';
import 'package:locstream/data/data_sources/remote_data_sources/watching_location_socket.dart';
import 'package:locstream/data/model/user_model.dart';

class ShareLocationRepository {
  final _remoteDataSource = ShareLocationRemoteDataSource();
  final _watchingUserLocationsSocket = WatchingUserLocationsSocket();

  Future<List<User>> fetchLocationReceivers() async {
    return await _remoteDataSource.fetchLocationReceivers();
  }

  Future<List<User>> fetchLocationSharers() async {
    return await _remoteDataSource.fetchLocationSharers();
  }

  Future<void> shareLocation({required String userId}) async {
    return await _remoteDataSource.shareLocation(userId: userId);
  }

  Future<void> stopSharingLocation({required String userId}) async {
    return await _remoteDataSource.stopSharingLocation(userId: userId);
  }

  StreamController<WatchingSocketEvent> watchingUsersStreamController() {
    return _watchingUserLocationsSocket.streamController;
  }

  void disconnectWatchingSocket() {
    _watchingUserLocationsSocket.disconnect();
  }

  void connectWatchingSocket() {
    _watchingUserLocationsSocket.connect();
  }
}
