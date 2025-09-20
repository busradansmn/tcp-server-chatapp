import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/clientScreenModel.dart';
import '../view/chatScreenView.dart';


class ChatViewModel {
  final Socket socket; // Socket nesnesi, TCP bağlantisini
  final String userName;
  final String userSurname;
  final String avatarPath;
  final WidgetRef ref; // Riverpod'dan durum yönetimi için referans

  
  ChatViewModel({
    required this.socket,
    required this.userName,
    required this.userSurname,
    required this.avatarPath,
    required this.ref,
  })


  {
    // Socket dinleyicisini ayarla
    socket.listen((data) {
      String message = String.fromCharCodes(data);   // Alinan veriyi karakter dizisine çevirir
      List<String> messageParts = message.split('|');
      if (messageParts.length == 4) {
        String userName = messageParts[0];
        String userSurname = messageParts[1];
        String avatarPath = messageParts[2];
        String messageText = messageParts[3];

        // Mesaji ekle
        ref.read(chatProvider.notifier).addMessage( // Mesaji Riverpod durumu araciliğiyla ekler
          Message(
            senderName: userName,
            senderSurname: userSurname,
            avatarPath: avatarPath,
            message: messageText,
            isCurrentUser: false, // Gönderenin mevcut kullanici olmadiğini söyler
          ),
        );
      }
    });
  }

  // Mesaj gönderme metodu
  void sendMessage(String message) {
    if (message.isNotEmpty) {
      String formattedMessage =
          '$userName|$userSurname|$avatarPath|$message';

      socket.write(formattedMessage); // Biçimlendirilmiş mesaji sokete yazar

      ref.read(chatProvider.notifier).addMessage( // Mesaji Riverpod durumu araciliğiyla ekler
        Message(
          senderName: userName,
          senderSurname: userSurname,
          avatarPath: avatarPath,
          message: 'Siz: $message',
          isCurrentUser: true,
        ),
      );
    }
  }

  void dispose() {
    socket.close(); // Soketi kapatır.
  }
}
