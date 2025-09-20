import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


class StartedViewModel extends StateNotifier<StartedModel> {

  // Başlangiçta StartedModel ile başlar
  StartedViewModel() : super(StartedModel());

  /// Renk değişimini tetikleyen metot
  void toggleColor() {
    // Mevcut renk değişim durumunu tersine çevir
    state.isChangeColor = !state.isChangeColor;
    // Durumu güncelle
    state = StartedModel(isChangeColor: state.isChangeColor);
  }

  /// Renk değişim durumunu döndüren getter
  bool get isChangeColor => state.isChangeColor; // Mevcut renk değişim durumunu döndür
}

// Provider tanimi
final startedViewModelProvider = StateNotifierProvider<StartedViewModel, StartedModel>((ref) {
  return StartedViewModel(); // StartedViewModel örneğini döndür
});
// started_model.dart
class StartedModel {
  bool isChangeColor;

  StartedModel({this.isChangeColor = false});
}
