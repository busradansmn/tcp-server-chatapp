import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/colorClass.dart';
import '../model/onboardingScreenModel.dart';
import '../viewmodel/onboardingScreenViewmodel.dart';
import 'choiceScreenView.dart';

class OnBoardingPageWidget extends StatelessWidget {

  final OnboardingPageModel pageModel;

  const OnBoardingPageWidget({super.key, required this.pageModel});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            pageModel.image,
            width: media.width,
            fit: BoxFit.fitWidth, // Resmin kapsama stili.
          ),
          SizedBox(height: media.width * 0.1), // Resim ile başlik arasi boşluk
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15), // Yatay kenar boşluk
            child: Text(
              pageModel.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700), // Başlik stili
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15), // Yatay kenar boşluk
            child: Text(
              pageModel.subtitle,
              style: TextStyle(color: TColor.gray, fontSize: 14), // Alt başlik stili
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingView extends ConsumerWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectPage = ref.watch(onboardingProvider); // Mevcut sayfayi dinle

    PageController controller = PageController(initialPage: selectPage); // Sayfa kontrolcüsü oluştur

    // Onboarding verilerini model olarak tanimla
    List<OnboardingPageModel> pageArr = [
      OnboardingPageModel(
        title: "Merhaba!",
        subtitle: "Bu uygulama, arkadaşlarınızla aynı Wi-Fi ağı üzerinden anlık olarak iletişim kurmanızı sağlar. Hızlı, kolay ve eğlenceli bir iletişim deneyimi için doğru yerdesiniz!",
        image: "lib/assets/png/1.png",
      ),
      OnboardingPageModel(
        title: "Anlık Mesajlaşma",
        subtitle: "Artık beklemek yok! TCP bağlantımız sayesinde mesajlarınız hemen iletilir. İster bir arkadaşınıza, ister grup sohbetine yazın; anlık olarak bağlantıda kalmanın keyfini çıkarın!",
        image: "lib/assets/png/2.png",
      ),
      OnboardingPageModel(
        title: "Mesajlarınız Özel",
        subtitle: "Mesajlarınız, sadece sizin ve arkadaşlarınız arasında kalır. Güvenli bağlantımız sayesinde, özel sohbetlerinizi kimse göremez. İçinizi ferah tutun, burada konuşmalarınız güvende!",
        image: "lib/assets/png/3.png",
      ),
    ];

    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,   // Öğeleri sağ alt köşeye hizala
        children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArr.length, // Sayfa sayisi
              onPageChanged: (index) {
                ref.read(onboardingProvider.notifier).state = index; // Sayfa değiştiğinde durumu güncelle
              },
              itemBuilder: (context, index) {
                var pageModel = pageArr[index];
                return OnBoardingPageWidget(pageModel: pageModel);
              }),
              
          // Devam butonu
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70, // Çizgi göstericinin genişliği.
                  height: 70,
                  child: CircularProgressIndicator(
                    color: TColor.primaryColor1, // Çizgi göstericinin rengi
                    value: (selectPage + 1) / 3, // Sayfa ilerlemesini göster
                    strokeWidth: 2, // Çizgi kalinliği
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30), // Kenar boşluklari
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: TColor.primaryColor1,
                      borderRadius: BorderRadius.circular(35)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: TColor.white,
                    ),
                    onPressed: () {
                      if (selectPage < 2) {
                        ref.read(onboardingProvider.notifier).nextPage(); // Sayfayi ileri al
                        controller.animateToPage(selectPage + 1,
                            duration: const Duration(milliseconds: 600), // Animasyon süresi
                            curve: Curves.easeInOut);
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => WhatYourChoiceView()));
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
