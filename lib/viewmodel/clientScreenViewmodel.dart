import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


class ClientViewModel extends StateNotifier<Socket?> {
  //başlangiç durumu olarak null (bağlanti yok) ayarlanir
  ClientViewModel() : super(null);

  // Sunucuya bağlanmak için asenkron metot
  Future<void> connectToServer(String ip, int port) async {
    try {
      
      final socket = await Socket.connect(ip, port);
      state = socket;
    } catch (e) {
    
      print('Bağlantı başarısız: $e');
      state = null;
    }
  }


  void disposeSocket() {
    state?.close();
  }
}

// clientViewModelProvider, ClientViewModel'i sağlayan bir StateNotifierProvider olarak tanimlanir.
final clientViewModelProvider = StateNotifierProvider<ClientViewModel, Socket?>((ref) {
  return ClientViewModel(); // Yeni bir ClientViewModel örneği oluşturur.
});
