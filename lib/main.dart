import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:english_wordle/themes/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:english_wordle/themes/colors.dart';
import 'package:english_wordle/firebase_options.dart';
import 'package:english_wordle/services/routes/routes.dart';
import 'package:english_wordle/views/widgets/snackbar.dart';
import 'package:english_wordle/services/auth/auth_service.dart';
import 'package:english_wordle/services/apis/spell_service.dart';
import 'package:english_wordle/services/apis/words_service.dart';
import 'package:english_wordle/services/local_db/words_box.dart';
import 'package:english_wordle/services/apis/gemeni_service.dart';
import 'package:english_wordle/services/database/streak_repo.dart';
import 'package:english_wordle/views/screens/auth/auth_screen.dart';
import 'package:english_wordle/views/screens/wordle_view/wordle_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await WordsBoxDB.instance.initBox();

  // WordsBoxDB.instance.clearTodayWord();
  // WordsBoxDB.instance.clearTypedValuesOfToday();

  final user = FirebaseAuth.instance.currentUser;

  // print(user?.displayName);
  // if (user != null) {
  await Get.putAsync(StreakRepo().init, permanent: true);
  // }

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {         
  const MyApp({super.key, this.user});

  final User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackBarService.messengerKey,
      title: 'Wordle Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: MyColorScheme.dark(),
        useMaterial3: true,
        textTheme: ThemeData.light().textTheme.nunito,
      ),
      getPages: Routes().getGetXPages(),
      initialBinding: InitialBinding(),
      initialRoute:
          user != null ? WordleScreen.routeName : AuthScreen.routeName,
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(GemeniService());
    Get.put(AuthService());
    Get.put(WordsRepository());
    Get.put(SpellService());
  }
}
