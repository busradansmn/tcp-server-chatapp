import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serversocket/view/serverScreenView.dart';

import '../class/colorClass.dart';
import '../viewmodel/choiceScreenViewmodel.dart';
import 'clientScreenView.dart';

class WhatYourChoiceView extends ConsumerWidget {      //verileri dinleyip kullanicinin seçimine göre ekrani güncelle
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //selectedChoiceIndex,şu an seçilinin indeksini tutar.
    var selectedChoiceIndex = ref.watch(choiceProvider);     // Seçilen seçenek indeksini dinle
    final viewModel = ref.read(choiceProvider.notifier);     // seçim işlemleri gerçekleştirilir

    var media = MediaQuery.of(context).size;  //ekran boyutuna göre dinamik olarak ayarla

return Scaffold(
backgroundColor: TColor.white,
body: SafeArea(
  child: Stack(         // Üst üste yerleştirilecek bileşenleri içeren Stack widget'i
    children: [
      Center(
        child: CarouselSlider(
          items: viewModel.getChoices().asMap().entries.map( // viewModel'den alinan seçenekleri map ile dolaşarak her birini bir widget haline getir
            (entry) {
              int index = entry.key;
              var choiceObj = entry.value;
              return GestureDetector( // Kullanicinin dokunuşunu algilamak için GestureDetector
                onTap: () {
                  viewModel.selectChoice(index); // Seçilen tercihi güncelle
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: TColor.primaryColor2,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: media.width * 0.1, horizontal: 25),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Column(
                      children: [
                        Image.asset(
                          choiceObj.image,
                          width: media.width * 0.5,
                          fit: BoxFit.fitWidth,
                        ),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Text(
                          choiceObj.title,
                          style: TextStyle(
                              color: TColor.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          width: media.width * 0.1,
                          height: 1,
                          color: TColor.white,
                        ),
                        SizedBox(
                          height: media.width * 0.02,
                        ),
                        Text(
                          choiceObj.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(), // Seçenekler listesi oluştur
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,    // Merkezdeki sayfa büyütülür
            viewportFraction: 0.7, //ekranin %70'i kadar
            aspectRatio: 0.74, // Genişlik-yükseklik orani
            initialPage: 0, // İlk gösterilecek sayfa
            onPageChanged: (index, reason) {
              viewModel.selectChoice(index); // Sayfa değiştiğinde seçilen tercihi güncelle
            },
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: media.width,
        child: Column(
          children: [
            SizedBox(
              height: media.width * 0.05,
            ),
            Text(
              "Ne yapmak istiyorsun ?",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "Sizin için en uygunu seçiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
            const Spacer(),
            SizedBox(
              height: media.width * 0.05,
            ),
            ElevatedButton(
              onPressed: () {
            
                if (selectedChoiceIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServerScreen()),
                  );
                } else if (selectedChoiceIndex == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClientScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff9DCEFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Onayla",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
