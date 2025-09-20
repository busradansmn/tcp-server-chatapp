class Message {
  final String senderName;
  final String senderSurname;
  final String avatarPath;
  final String message;
  final bool isCurrentUser;

  Message({
    required this.senderName,
    required this.senderSurname,
    required this.avatarPath,
    required this.message,
    required this.isCurrentUser,
  });
}
