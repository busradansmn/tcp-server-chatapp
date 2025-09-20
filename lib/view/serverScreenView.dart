import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/serverScreenViewmodel.dart';
import 'onlyreadScreen.dart';

class ServerScreen extends ConsumerWidget {    // ServerScreen, Riverpod ile çalişmak için ConsumerWidget kullaniyor
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);   // messagesProvider izleniyor ve mesajlar aliniyor
    final ip = ref.watch(serverViewModelProvider);  // serverViewModelProvider izleniyor ve sunucu IP'si aliniyor

 // serverViewModelProvider kullanilarak startServer fonksiyonu çağriliyor ve sunucu başlatiliyor
    ref.read(serverViewModelProvider.notifier).startServer(ref);
  
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/png/foto4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Şeffaf AppBar
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  AppBar(
                    title: Text('Sunucu'),
                    centerTitle: true,
                    foregroundColor: const Color.fromARGB(255, 44, 41, 41),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff9DCEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/png/7.png'),
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Oluşturulan Sunucunun Bilgileri:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16), // Başlik ile bilgiler arasinda boşluk
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.network_cell, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'IP Adresi: $ip',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.portable_wifi_off, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Port: ${ref.read(serverViewModelProvider.notifier).port}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                            
                              ref.read(serverViewModelProvider.notifier).startServer(ref); // Sunucuyu başlat
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Onlyreadscreen(messages: messages),
                                ),
                              );
                            },
                            child: Text('Sunucuya Gelen Mesajları Gör'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(107, 157, 243, 1),
                              foregroundColor: Colors.white, // Metin rengi
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
