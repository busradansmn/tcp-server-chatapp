import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


// OnboardingViewModel sinifi, StateNotifier olarak tanimli ve onboarding sürecini yönetir
class OnboardingViewModel extends StateNotifier<int> {

  OnboardingViewModel() : super(0); // başlangic durumu olarak 0 (ilk sayfa)

  // Bir sonraki sayfaya geçiş
  void nextPage() {
    if (state < 2) { // Eğer mevcut sayfa 2'den küçükse
      state++;
    }
  }

  // Önceki sayfaya dönmek için metot
  void previousPage() {
    if (state > 0) { // Eğer mevcut sayafa 0'dan büyükse
      state--;
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingViewModel, int>(
  (ref) => OnboardingViewModel(), // Yeni bir OnboardingViewModel örneği oluştur
);
