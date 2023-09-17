import 'package:flutter/material.dart';
import 'package:flutter_bird/models/friend.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/chat_box/chat_messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'settings.dart';


class SocketServices extends ChangeNotifier {
  late io.Socket socket;

  static final SocketServices _instance = SocketServices._internal();

  late ChatMessages chatMessages;

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

    // TODO: Fix the part after this
    // socket.open();
    ChatMessages chatMessages = ChatMessages();
    chatMessages.login();
    checkMessages(chatMessages);
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

  bool joinedChatRooms = false;
  void checkMessages(ChatMessages chatMessages) {
    if (joinedChatRooms) {
      return;
    }
    joinedChatRooms = true;
    this.chatMessages = chatMessages;
    // socket.on('send_message_global', (data) {
    //   String from = data["sender_name"];
    //   int senderId = data["sender_id"];
    //   String message = data["body"];
    //   String timestamp = data["timestamp"];
    //   receivedMessage(from, senderId, message, timestamp);
    //   notifyListeners();
    // });
    // socket.on('send_message_personal', (data) {
    //   print("received a personal message! :D");
    //   String from = data["sender_name"];
    //   int senderId = data["sender_id"];
    //   String to = data["receiver_name"];
    //   String message = data["message"];
    //   String timestamp = data["timestamp"];
    //   receivedMessagePersonal(from, senderId, to, message, timestamp);
    //   notifyListeners();
    // });
  }

  void receivedMessage(String from, int senderId, String message, String timestamp) {
    print("received message $senderId");
    chatMessages.addMessage(from, senderId, message, timestamp);
  }

  void receivedMessagePersonal(String from, int senderId, String to, String message, String timestamp) {
    chatMessages.addPersonalMessage(from, senderId, to, message, timestamp);
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
