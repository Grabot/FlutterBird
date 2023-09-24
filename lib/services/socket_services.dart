import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bird/constants/url_base.dart';
import 'package:flutter_bird/models/friend.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'rest/auth_service_login.dart';
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

    socket.on('message_event', (data) {
      checkMessageEvent(data);
    });

    socket.open();
  }

  retrieveAvatar() {
    AuthServiceLogin().getAvatarUser().then((value) {
      if (value != null) {
        Uint8List avatar = base64Decode(value.replaceAll("\n", ""));
        Settings().setAvatar(avatar);
        if (Settings().getUser() != null) {
          Settings().getUser()!.setAvatar(avatar);
        }
        ProfileChangeNotifier().notify();
      }
    }).onError((error, stackTrace) {
      // TODO: What to do on an error? Reset?
      print("error: $error");
    });
  }

  void checkMessageEvent(data) {
    if (data == "Avatar creation done!") {
      retrieveAvatar();
    }
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
