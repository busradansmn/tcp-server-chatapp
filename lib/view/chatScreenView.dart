import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/clientScreenModel.dart';

//ChatNotifer sinifi mesajlarin listesini yönetsin tutsun diye
class ChatNotifier extends StateNotifier<List<Message>> {    //riverpodun statenotifier yapisi
  ChatNotifier() : super([]);        //baslangic durumu boş bir liste oluyor

  void addMessage(Message message) {       //mevcut mesajlar listesine yeni bir mesaj ekle ve durumu güncelle
    state = [...state, message];
  }
}

// StateNotifier kullanan bir Riverpod sağlayicisi oluştur
final chatProvider = StateNotifierProvider<ChatNotifier, List<Message>>((ref) {
  return ChatNotifier();
});

class ChatScreen extends ConsumerStatefulWidget {   //normal StatefulWidget sinifinin Riverpod'a özel build+ref
  final Socket socket;     //TCP bağlantisini temsil eden bir Socket nesnesi
  final String userName;
  final String userSurname;
  final String avatarPath;

  ChatScreen({
    required this.socket,
    required this.userName,
    required this.userSurname,
    required this.avatarPath,
  });

  @override
  //ChatScreen widget'inin durumunu yöneten bir state sinifi
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {

  // mesaj girişi yapmak için bir metin alani oluşturulacak ve bu kontrolcü, mesaj gönderme işlemlerinde kullanilacak
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.socket.listen((data) {
      String message = String.fromCharCodes(data);
      List<String> messageParts = message.split('|');    // Mesaj string'i dikey çizgi (|) ile ayrilmiş dört parçaya bölünür:
      if (messageParts.length == 4) {
        String userName = messageParts[0];
        String userSurname = messageParts[1];
        String avatarPath = messageParts[2];
        String messageText = messageParts[3];

  
        //TCP soketi üzerinden gelen bir mesaji alip sohbet ekranina ekle
        ref.read(chatProvider.notifier).addMessage(   //chatProvider'daki ChatNotifier sinifinin addMessage fonks çagir
          Message(
            senderName: userName,
            senderSurname: userSurname,
            avatarPath: avatarPath,
            message: messageText,
            isCurrentUser: false,    //diğer kullanicidan gelen bir mesaj
          ),
        );
      }
    });
  }

// Kullanici mesaj yazip gönderdiğinde, bu mesaj hem TCP soket üzerinden diğerlerine iletilir hem de mesajlar listesine eklenir
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {  //mesaj giriş alanini boş mu
      String message = _messageController.text;       //metin giriş alanina yazdiği mesaji al
      String formattedMessage =
          '${widget.userName}|${widget.userSurname}|${widget.avatarPath}|$message';
      widget.socket.write(formattedMessage);

//gönderilen mesajin ayni zamanda uyg arayüzünde de görünmesini sağlar
      ref.read(chatProvider.notifier).addMessage(
        Message(
          senderName: widget.userName,
          senderSurname: widget.userSurname,
          avatarPath: widget.avatarPath,
          message: 'Siz: $message',
          isCurrentUser: true,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // chatProvider içindeki mesajlari dinle ve ekrana yansit
    final messages = ref.watch(chatProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesajlaşma Ekranı'),
        backgroundColor: const Color.fromARGB(255, 116, 181, 234),
         foregroundColor: Colors.white, // Metin rengi // AppBar arka plan rengi mavi
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment:
                        msg.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!msg.isCurrentUser)
                        CircleAvatar(
                          backgroundImage: AssetImage(msg.avatarPath),
                          backgroundColor:Colors.blue[100] ,
                        ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: msg.isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (!msg.isCurrentUser)
                            Text('${msg.senderName} ${msg.senderSurname}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: msg.isCurrentUser
                                  ? Colors.blue[100]
                                  : const Color.fromARGB(255, 222, 213, 223),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg.message),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Mesaj yazın...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: const Color.fromARGB(255, 95, 181, 252),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {   // TCP soketini kapatarak daha fazla mesaj alimini durdurur
    widget.socket.close();
    super.dispose();
  }
}
