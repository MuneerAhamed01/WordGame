import 'package:english_wordle/views/screens/wordle_view/wordle_bindings.dart';
import 'package:english_wordle/views/screens/wordle_view/wordle_screen.dart';
import 'package:get/get.dart';

class Routes {
  List<GetPage> getGetXPages() {
    return [
      GetPage(
        name: WordleScreen.routeName,
        page: () => const WordleScreen(),
        transition: Transition.fadeIn,
        binding: WordleBindings(),
      ),
      // GetPage(
      //   name: RoutesName.signUp,
      //   page: () => const SignUpScreen(),
      //   transition: Transition.fadeIn,
      //   binding: SignUpBindings(),
      // ),
      // GetPage(
      //   name: RoutesName.showcase,
      //   page: () => const ShowcasePage(),
      //   transition: Transition.fadeIn,
      // ),

      // GetPage(
      //   name: RoutesName.addProfile,
      //   page: () => const AddProfileScreen(),
      //   transition: Transition.fadeIn,
      //   binding: AddProfileBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.subscription,
      //   page: () => const SubscriptionScreen(),
      //   transition: Transition.fadeIn,
      //   // binding: SubscriptionBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.followPlayer,
      //   page: () => const FollowPlayerScreen(),
      //   transition: Transition.fadeIn,
      //   binding: FollowPlayerBindings(),
      // ),
      // GetPage(
      //   name: RoutesName.followEvent,
      //   page: () => const FollowEventScreen(),
      //   transition: Transition.fadeIn,
      //   binding: FollowEventBindings(),
      // ),
      // GetPage(
      //   name: RoutesName.main,
      //   page: () => const MainScreen(),
      //   transition: Transition.fadeIn,
      //   binding: MainBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.globalSearch,
      //   page: () => const SearchScreen(),
      //   transition: Transition.fadeIn,
      //   binding: SearchBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.loading,
      //   page: () => const LoadingScreen(),
      //   transition: Transition.fadeIn,
      //   binding: LoadingBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.playerProfile,
      //   page: () => const ProfileScreen(),
      //   transition: Transition.fadeIn,
      //   binding: ProfileBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.viewMatch,
      //   page: () => const MatchScreen(),
      //   transition: Transition.fadeIn,
      //   binding: MatchBindings(),
      // ),
      // GetPage(
      //   name: RoutesName.viewTournament,
      //   page: () => const TournamentScreen(),
      //   transition: Transition.fadeIn,
      //   binding: TournamentBinding(),
      // ),
      // GetPage(
      //   name: RoutesName.teamDetails,
      //   page: () => const TeamViewPage(),
      //   binding: TeamViewBinding(),
      //   maintainState: false,
      //   transition: Transition.fadeIn,
      // ),
      // GetPage(
      //   name: RoutesName.teeTime,
      //   page: () => const TeeTimeScreen(),
      //   binding: TeeTimeBinding(),
      //   maintainState: false,
      //   transition: Transition.fadeIn,
      // ),

      // //notification
      // GetPage(
      //   name: RoutesName.notification,
      //   page: () => const NotificationScreen(),
      //   // binding: NotificationBinding(),
      //   maintainState: false,
      //   transition: Transition.fadeIn,
      // ),

      // GetPage(
      //   name: RoutesName.error,
      //   page: () => ErrorScreen(
      //     errorType: Get.arguments as ErrorType,
      //   ),
      //   transition: Transition.fadeIn,
      // )
    ];
  }
}
