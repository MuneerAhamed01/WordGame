import 'package:english_wordle/views/screens/wordle_view/wordle_controller.dart';
import 'package:get/get.dart';

class WordleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordleController>(() => WordleController());
  }
}
