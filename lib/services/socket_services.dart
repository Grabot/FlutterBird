import 'package:flutter/material.dart';
import 'package:flutter_bird/models/friend.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'settings.dart';


class SocketServices extends ChangeNotifier {
  late io.Socket socket;

  static final SocketServices _instance = SocketServices._internal();

  SocketServices._internal() {
    startSockConnection();
  }

  factory SocketServices() {
    return _instance;
  }

  startSockConnection() {
    String baseUrlV1_0 = "";  // TODO: baseurl
    String socketUrl = baseUrlV1_0;
    socket = io.io(socketUrl, <String, dynamic>{
      'autoConnect': false,
      'path': "/socket.io",
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print("on connect");
      socket.emit('message_event', 'Connected!');
    });

    socket.onDisconnect((_) {
      print("on disconnect");
      socket.emit('message_event', 'Disconnected!');
    });
  }

  login(int userId) {
    joinRoom(userId);
  }

  logout(int userId) {
    leaveRoom(userId);
  }

  void joinRoom(int userId) {
    if (userId != -1) {
      socket.emit(
        "join",
        {
          'user_id': userId,
        },
      );
    }
  }

  void leaveRoom(int userId) {
    if (socket.connected) {
      socket.emit("leave", {
        'user_id': userId,
      });
    }
  }

  bool joinedFriendRooms = false;
  checkFriends() {
    if (joinedFriendRooms) {
      return;
    }
    joinedFriendRooms = true;
    socket.on('received_friend_request', (data) {
      Map<String, dynamic> from = data["from"];
      receivedFriendRequest(from);
      notifyListeners();
    });
    socket.on('denied_friend', (data) {
      int friendId = data["friend_id"];
      deniedFriendRequest(friendId);
      notifyListeners();
    });
    socket.on('accept_friend_request', (data) {
      print("accept friend request $data");
      Map<String, dynamic> from = data["from"];
      acceptFriendRequest(from);
      notifyListeners();
    });
  }

  receivedFriendRequest(Map<String, dynamic> from) {
    User? currentUser = Settings().getUser();
    if (currentUser != null) {
      int id = from["id"];
      String username = from["username"];
      Friend friend = Friend(id, false, false, 0, username);
      currentUser.addFriend(friend);
      showToastMessage("received a friend request from $username");
      // FriendWindowChangeNotifier().notify();
    }
  }

  deniedFriendRequest(int friendId) {
    User? currentUser = Settings().getUser();
    if (currentUser != null) {
      currentUser.removeFriend(friendId);
      // FriendWindowChangeNotifier().notify();
    }
  }

  acceptFriendRequest(Map<String, dynamic> from) {
    User? currentUser = Settings().getUser();
    if (currentUser != null) {
      User newFriend = User.fromJson(from);
      Friend friend = Friend(newFriend.getId(), true, false, 0, newFriend.getUserName());
      currentUser.addFriend(friend);
      showToastMessage("${newFriend.userName} accepted your friend request");
      // FriendWindowChangeNotifier().notify();
    }
  }

}