import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/clientScreenViewmodel.dart';
import 'chatScreenView.dart';

Color get primaryColor2 => const Color(0xff9DCEFF);

class ClientScreen extends ConsumerStatefulWidget {
  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends ConsumerState<ClientScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  int _currentAvatarIndex = 0;
  String _selectedAvatarPath = '';
  bool _isDisposed = false; // Widget'in dispose edilip edilmediğini kontrol eden değişken


  List<String> _avatarPaths = [
    'lib/assets/png/memo_1.png',
    'lib/assets/png/memo_2.png',
    'lib/assets/png/memo_3.png',
    'lib/assets/png/memo_4.png',
    'lib/assets/png/memo_5.png',
    'lib/assets/png/memo_6.png',
    'lib/assets/png/memo_7.png',
    'lib/assets/png/memo_8.png',
    'lib/assets/png/memo_9.png',
    'lib/assets/png/memo_10.png',
    'lib/assets/png/memo_11.png',
    'lib/assets/png/memo_12.png',
    'lib/assets/png/memo_13.png',
    'lib/assets/png/memo_14.png',
    'lib/assets/png/memo_15.png',
    'lib/assets/png/memo_16.png',
    'lib/assets/png/memo_17.png',
    'lib/assets/png/memo_18.png',
    'lib/assets/png/memo_19.png',
    'lib/assets/png/memo_20.png',
    'lib/assets/png/memo_21.png',
    'lib/assets/png/memo_22.png',
    'lib/assets/png/memo_23.png',
    'lib/assets/png/memo_24.png',
    'lib/assets/png/memo_25.png',
    'lib/assets/png/memo_26.png',
    'lib/assets/png/memo_27.png',
    'lib/assets/png/memo_28.png',
    'lib/assets/png/memo_29.png',
    'lib/assets/png/memo_30.png',
  ];

  Future<void> _connectToServer() async {

    if (_isDisposed) return; // Widget zaten dispose edilmişse çik

    final ip = _ipController.text;
    final port = int.tryParse(_portController.text) ?? 0;

    if (port > 0) {
      try {
        await ref.read(clientViewModelProvider.notifier).connectToServer(ip, port);
        if (_isDisposed) return; // İşlemden sonra tekrar kontrol et

        Socket? socket = ref.read(clientViewModelProvider);
        if (socket != null) {
          _showConnectionSuccess();
          _showNameAndAvatarDialog(socket);
        }
      } catch (e) {
        print('Bağlanırken hata: $e');
      }
    } else {
      print('Geçersiz port numarası');
    }
  }

  // Bağlant başarili mesaji
  void _showConnectionSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bağlantı başarılı!'),
        duration: Duration(seconds: 2),
      ),
    );
  }


  void _showNameAndAvatarDialog(Socket socket) {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String surname = '';
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Ad, Soyad ve Avatarınızı Seçin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Ad'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Soyad'),
                  onChanged: (value) {
                    surname = value;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton( // Avatar sola kaydırma butonu
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          _currentAvatarIndex = (_currentAvatarIndex - 1) % _avatarPaths.length; // Avatarı sola kaydır
                          if (_currentAvatarIndex < 0) { // Eğer indeks negatifse
                            _currentAvatarIndex = _avatarPaths.length - 1; // Son elemana geç
                          }
                        });
                      },
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(_avatarPaths[_currentAvatarIndex]), // Mevcut avatar görseli
                    ),
                    IconButton( // Avatar sağa kaydirma butonu
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          _currentAvatarIndex = (_currentAvatarIndex + 1) % _avatarPaths.length; // Avatari sağa kaydir
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Diyaloğu kapat
                  _selectedAvatarPath = _avatarPaths[_currentAvatarIndex];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        socket: socket,
                        userName: name,
                        userSurname: surname,
                        avatarPath: _selectedAvatarPath,
                      ),
                    ),
                  );
                },
                child: Text('Tamam'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  AppBar(
                    title: Text('Sunucu Bilgileri'),
                    centerTitle: true,
                    foregroundColor: const Color.fromARGB(255, 37, 32, 32),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0), // İç boşluk
                  decoration: BoxDecoration(
                    color: primaryColor2,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _ipController,
                        decoration: InputDecoration(labelText: 'Sunucu IP Adresi'),
                      ),
                      TextField(
                        controller: _portController,
                        decoration: InputDecoration(labelText: 'Port Numarası'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _connectToServer,
                        child: Text('Bağlan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(107, 157, 243, 1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        'lib/assets/png/8.png',
                        width: 280,
                        height: 220,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true; // Widget dispose edildiğinde bayrak değiştir.
    _ipController.dispose(); // Kontrolcüleri temizle.
    _portController.dispose(); // Kontrolcüleri temizle.
    super.dispose(); // Üst sınıfın dispose metodunu çağır.
  }
}
