import 'dart:async';

import 'package:locstream/data/data_sources/remote_data_sources/wathcers_location_socket.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/data/repository/share_location_repository.dart';

class ShareLocationUseCase {
  ShareLocationUseCase({required this.shareLocationRepo});

  final ShareLocationRepository shareLocationRepo;

  Future<List<User>> fetchLocationReceivers() async {
    return await shareLocationRepo.fetchLocationReceivers();
  }

  Future<List<User>> fetchLocationSharers() async {
    return await shareLocationRepo.fetchLocationSharers();
  }

  Future<void> shareLocation({required String userId}) async {
    return await shareLocationRepo.shareLocation(userId: userId);
  }

  Future<void> stopSharingLocation({required String userId}) async {
    return await shareLocationRepo.stopSharingLocation(userId: userId);
  }

  StreamController<WatchingSocketEvent> watchingUsersStreamController() {
    return shareLocationRepo.watchingUsersStreamController();
  }

  void disconnectWatchingSocket() {
    return shareLocationRepo.disconnectWatchingSocket();
  }

  void connectWatchingSocket() {
    return shareLocationRepo.connectWatchingSocket();
  }
}
