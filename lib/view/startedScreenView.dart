import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../class/colorClass.dart';
import '../viewmodel/startedScreenViewmodel.dart';
import 'onboardingScreenView.dart';

class StartedView extends ConsumerWidget {    // Riverpod ile durum yönetimi sağlayan bir widget.
  const StartedView({super.key});   // Yapici metod, anahtar alir.

  @override
  Widget build(BuildContext context, WidgetRef ref) {            // Widget'in kullanici arayüzünü oluşturur.
    final viewModel = ref.watch(startedViewModelProvider);   // ViewModel'i dinler.

    var media = MediaQuery.of(context).size;      // Ekran boyutlarini al
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        width: media.width,    // Genişliği ekran genişliği kadar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(), // Üst boşluk
            Text(
              "ChatterBox",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "Dilediğin gibi mesajlaşmaya başla",
              style: TextStyle(
                color: TColor.gray,
                fontSize: 18,
              ),
            ),
            const Spacer(), // Alt boşluk
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff9DCEFF),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OnBoardingView()));
                  },
                  child: Text(
                    "Mesajlaşmaya Başla",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
