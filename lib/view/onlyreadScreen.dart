import 'package:flutter/material.dart';

class Onlyreadscreen extends StatelessWidget {
  final List<String> messages; // ServerScreen'den gelen mesajları alacak

  Onlyreadscreen({required this.messages}); // Constructor, mesajları alır

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesaj Listesi'),
      ),
      body: ListView.builder(
        itemCount: messages.length, // Mesajların sayısına göre liste oluşturulur
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.white : Color(0xff9DCEFF), // Beyaz ve mavi renkler
              borderRadius: BorderRadius.circular(15), // Kenarları yuvarlamak için
            ),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Mesajlar arası boşluk
            child: ListTile(
              title: Text(
                messages[index], // Her bir mesajı ekranda göster
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
