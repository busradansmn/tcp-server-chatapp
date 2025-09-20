import 'dart:io';        // Socket işlemleri

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final messagesProvider = StateProvider<List<String>>(
  (ref) => []   // Mesajlari tutan bir Riverpod provider
  );

// ServerViewModel, sunucu işlemlerini yönetir ve IP adresini tutar
class ServerViewModel extends StateNotifier<String> {
  ServerViewModel() : super('');     // Başlangiç durumu boş bir IP adresi
  int _port = 8080;
  
  ServerSocket? _serverSocket; // Sunucu için ServerSocket nesnesi
  List<Socket> _clients = []; // Bağli istemcileri tutacak liste

  int get port => _port;

  // Sunucu başlatma metodu
  Future<void> startServer(WidgetRef ref) async {
    try {
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, _port); // Sunucuyu belirtilen portta başlat ve IPv4 adresine bağla
      String ip = await _getLocalIpAddress(); // Yerel IP adresini al
      state = ip;


      // İstemcileri dinle
      _serverSocket!.listen((client) {
        print('Yeni istemci bağlandı: ${client.remoteAddress}'); // Yeni istemci bağlandiğinda konsola yaz
        _clients.add(client); // Bağlanan istemciyi listeye ekle


        // Mesajları dinle
        client.listen((data) {
          String message = String.fromCharCodes(data); // Gelen veriyi stringe çevir

          // Mesaji parçala (| ayirici ile)
          List<String> messageParts = message.split('|');
          if (messageParts.length == 4) {
            String userName = messageParts[0];
            String userSurname = messageParts[1];
            String avatarPath = messageParts[2];
            String messageText = messageParts[3];

            String formattedMessage = '$userName $userSurname: $messageText'; // Mesaji formatla

            // Mesaji güncel listeye ekle ve ekrani güncelle
            ref.read(messagesProvider.notifier).update((state) => [...state, formattedMessage]);

            // Mesaji diğer istemcilere gönder
            _broadcastMessage('$userName|$userSurname|$avatarPath|$messageText', client);
          }
        });
      });
    } catch (e) {
      print('Sunucu başlatılamadı: $e');
    }
  }

  // Mesaji tüm istemcilere yayma metodu
  void _broadcastMessage(String message, Socket senderSocket) {
    for (var client in _clients) {
      if (client != senderSocket) {
        client.write('$message\n');
      }
    }
    print(message);
  }

  // Yerel IP adresini alma metodu
  Future<String> _getLocalIpAddress() async {
    for (var interface in await NetworkInterface.list()) {  // Ağ arayüzlerini listele
      for (var addr in interface.addresses) {   // Her arayüzdeki adresleri kontrol et
        if (addr.type == InternetAddressType.IPv4) {   // IPv4 adresini bul
          return addr.address;
        }
      }
    }
    return 'Bilinmiyor';
  }

  @override
  void dispose() {
    _serverSocket?.close(); // ServerSocket'i kapat
    super.dispose();
  }
}

// ServerViewModel için provider
final serverViewModelProvider = StateNotifierProvider<ServerViewModel, String>((ref) {
  return ServerViewModel(); // ServerViewModel'i sağlayan provider
});
