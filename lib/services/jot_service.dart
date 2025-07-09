// services/jot_service.dart
import 'package:hive/hive.dart';
import '../models/jot_model.dart';

class JotService {
  final Box<JotModel> jotBox = Hive.box<JotModel>('jots');

  List<JotModel> getAllJots() {
    return jotBox.values.toList();
  }

  void addJot(JotModel jot) {
    jotBox.add(jot);
  }

  void updateJot(int index, JotModel jot) {
    jotBox.putAt(index, jot);
  }

  void deleteJot(int index) {
    jotBox.deleteAt(index);
  }
}
