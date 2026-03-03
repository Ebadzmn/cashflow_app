import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/splash/splash_page.dart';
import '../features/splash/splash_binding.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/onboarding/onboarding_binding.dart';
import '../features/home/home_page.dart';
import '../features/home/home_binding.dart';
import '../features/auth/login/login_page.dart';
import '../features/auth/login/login_controller.dart';
import '../features/auth/signup/signup_page.dart';
import '../features/auth/signup/signup_controller.dart';
import '../features/auth/otp/otp_page.dart';
import '../features/auth/otp/otp_controller.dart';
import '../features/auth/forgot_password/forgot_password_page.dart';
import '../features/auth/forgot_password/forgot_password_controller.dart';
import '../features/scan_receipt/scan_receipt_page.dart';
import '../features/audit_readiness/audit_readiness_page.dart';
import '../features/audit_readiness/expert_support_page.dart';
import '../features/scan_receipt/scan_receipt_controller.dart';
import '../features/profile/my_profile_page.dart';
import '../features/profile/edit_profile_page.dart';
import '../features/auth/forgot_password/change_password_page.dart';
import '../features/auth/forgot_password/change_password_controller.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: Routes.SPLASH,
    routes: [
      GoRoute(
        path: Routes.SPLASH,
        builder: (context, state) {
          SplashBinding().dependencies();
          return const SplashPage();
        },
      ),
      GoRoute(
        path: Routes.ONBOARDING,
        builder: (context, state) {
          OnboardingBinding().dependencies();
          return const OnboardingPage();
        },
      ),
      GoRoute(
        path: Routes.HOME,
        builder: (context, state) {
          HomeBinding().dependencies();
          return const HomePage();
        },
      ),
      GoRoute(
        path: Routes.LOGIN,
        builder: (context, state) {
          Get.lazyPut(() => LoginController());
          return const LoginPage();
        },
      ),
      GoRoute(
        path: Routes.SIGNUP,
        builder: (context, state) {
          Get.lazyPut(() => SignupController());
          return const SignupPage();
        },
      ),
      GoRoute(
        path: Routes.OTP,
        builder: (context, state) {
          Get.lazyPut(() => OtpController());
          return const OtpPage();
        },
      ),
      GoRoute(
        path: Routes.FORGOT_PASSWORD,
        builder: (context, state) {
          Get.lazyPut(() => ForgotPasswordController());
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: Routes.SCAN_RECEIPT,
        builder: (context, state) {
          Get.lazyPut(() => ScanReceiptController());
          return const ScanReceiptPage();
        },
      ),
      GoRoute(
        path: Routes.AUDIT_READINESS,
        builder: (context, state) => const AuditReadinessPage(),
      ),
      GoRoute(
        path: Routes.EXPERT_SUPPORT,
        builder: (context, state) => const ExpertSupportPage(),
      ),
      GoRoute(
        path: Routes.MY_PROFILE,
        builder: (context, state) => const MyProfilePage(),
      ),
      GoRoute(
        path: Routes.EDIT_PROFILE,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: Routes.CHANGE_PASSWORD,
        builder: (context, state) {
          Get.lazyPut(() => ChangePasswordController());
          return const ChangePasswordPage();
        },
      ),
    ],
  );
}
