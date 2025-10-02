import 'package:get/get.dart';
import 'package:the_leaderboard/screens/account_delete_screen/account_delete_screen.dart';
import 'package:the_leaderboard/screens/auth_screens/verify_otp_screen/verify_otp_screen.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/screens/change_password_screen/change_password_screen.dart';
import 'package:the_leaderboard/screens/join_leaderboard_screen/join_leaderboard_screen.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/screens/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:the_leaderboard/screens/profile_screen/profile_screen.dart';
import 'package:the_leaderboard/screens/raffle_rules_screen/raffle_rules_screen.dart';
import 'package:the_leaderboard/screens/refund_policy_screen/refund_policy_screen.dart';
import 'package:the_leaderboard/screens/server_off_screen/server_off_screen.dart';
import 'package:the_leaderboard/screens/withdraw_amount_screen/withdraw_amount_screen.dart';

import '../screens/auth_screens/create_new_password_screen/create_new_password_screen.dart';
import '../screens/auth_screens/forgot_password_screen/forgot_password_screen.dart';
import '../screens/auth_screens/forgot_verify_otp_screen/forgot_verify_otp_screen.dart';
import '../screens/auth_screens/login_screen/login_screen.dart';
import '../screens/auth_screens/register_screen/register_screen.dart';
import '../screens/edit_profile_screen/edit_profile_screen.dart';
import '../screens/faq_screen/faq_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/notification_screen/notification_screen.dart';
import '../screens/onboarding_screen/onboarding_screen.dart';
import '../screens/report_problem_screen/report_problem_screen.dart';
import '../screens/search_screen/search_screen.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../screens/terms_condition_screen/terms_conditions_screen.dart';
import 'app_routes.dart';

class RouteManager {
  RouteManager._();

  static const initial = AppRoutes.splashScreen;

  static List<GetPage> getPages() {
    return [
      // General Screens
      GetPage(
        name: AppRoutes.splashScreen,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.onboardingScreen,
        page: () => const OnboardingScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.registerScreen,
        page: () => const RegisterScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.loginScreen,
        page: () => const LoginScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.forgotPasswordScreen,
        page: () => const ForgotPasswordScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.forgotVerifyOtpScreen,
        page: () => const ForgotVerifyOtpScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.createNewPasswordScreen,
        page: () => const CreateNewPasswordScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.homeScreen,
        page: () => const HomeScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.searchScreen,
        page: () => const SearchScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.notificationsScreen,
        page: () => const NotificationsScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.settingsScreen,
        page: () => const SettingsScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.editProfileScreen,
        page: () => const EditProfileScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.faqScreen,
        page: () => const FAQScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.termsAndConditionsScreen,
        page: () => const TermsAndConditionsScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.reportProblemsScreen,
        page: () => const ReportProblemsScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.verifyOtpScreen,
        page: () => const VerifyOtpScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.changePasswordScreen,
        page: () => const ChangePasswordScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.withdrawAmountScreen,
        page: () => const WithdrawAmountScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),

      GetPage(
        name: AppRoutes.appNavigation,
        page: () => const BottomNav(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.joinLeaderboard,
        page: () => const JoinLeaderboardScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.serverOff,
        page: () => const ServerOffScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.accountDelete,
        page: () => const AccountDeleteScreen(),
        transition: Transition.fadeIn,
        // binding: GeneralBindings(),
      ),
      GetPage(
        name: AppRoutes.refundPolicyScreen,
        page: () => RefundPolicyScreen(),
      ),
      GetPage(
        name: AppRoutes.raffleRulesScreen,
        page: () => RaffleRulesScreen(),
      ),
      GetPage(
        name: AppRoutes.privacyPolicyScreen,
        page: () => PrivacyPolicyScreen(),
      ),
      GetPage(
          name: AppRoutes.otherProfileScreen, page: () => OtherProfileScreen())
    ];
  }
}
