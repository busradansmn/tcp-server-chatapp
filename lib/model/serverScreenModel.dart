class Message {
  final String userName;
  final String userSurname;
  final String avatarPath;
  final String messageText;

  Message({
    required this.userName,
    required this.userSurname,
    required this.avatarPath,
    required this.messageText,
  });

  @override
  String toString() {
    return '$userName $userSurname: $messageText';
  }
}
