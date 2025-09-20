import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../model/choiceScreenModel.dart';

// ViewModel Provider'i
class ChoiceViewModel extends StateNotifier<int> {
  ChoiceViewModel() : super(0);

  List<Choice> choices = [
    Choice(
      image: "lib/assets/png/5.png",
      title: "Sunucu Oluştur",
      subtitle: "Sunucu oluşturma seçeneği, \nkullanıcıların kendi \nTCP sunucularını başlatmalarına \nolanak tanır. \nBu, diğer kullanıcıların \naynı ağda bu sunucuya \nbağlanarak iletişim kurmasına \nolanak sağlar.",
    ),
    Choice(
      image: "lib/assets/png/6.png",
      title: "İstemci Olarak Katıl",
      subtitle: "İstemci olarak katılma,\n kullanıcıların mevcut \nbir TCP sunucusuna \nbağlanmalarını sağlar.\nBu, kullanıcıların \nbaşka birinin sunucusunu \nkullanarak mesajlaşmalarını \nmümkün kılar.",
    ),
  ];

  // Seçim güncelleme
  void selectChoice(int index) {
    state = index; // Seçilen tercihi güncelle
  }

  // Seçimleri döndüren metod
  List<Choice> getChoices() {
    return choices;
  }
}

// Provider'i tanimla
final choiceProvider = StateNotifierProvider<ChoiceViewModel, int>((ref) {
  return ChoiceViewModel();
});
